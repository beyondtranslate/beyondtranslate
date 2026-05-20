use async_trait::async_trait;
use base64::Engine;
use beyondtranslate_core::{
    DetectLanguageRequest, DetectLanguageResponse, DictionaryError, DictionaryService,
    LookUpRequest, LookUpResponse, OcrError, OcrService, Provider, RecognizeTextRequest,
    RecognizeTextResponse, RecognizedRect, TextDetection, TextRecognition, TextTranslation,
    TranslateRequest, TranslateResponse, TranslationError, TranslationService, WordDefinition,
    WordPronunciation,
};

// ── macOS: Apple Vision Framework ──────────────────────────────────────────

#[cfg(target_os = "macos")]
mod platform {
    use super::*;
    use objc2::encode::{Encode, Encoding, RefEncode};
    use objc2::{msg_send, rc::Retained, runtime::AnyObject};
    use std::ffi::{c_char, c_void, CStr, CString};
    use std::ptr::null_mut;

    // ── CoreGraphics type stubs with proper objc2 encoding ──────────────

    #[repr(C)]
    #[derive(Clone, Copy, Debug, Default)]
    struct CGPoint {
        x: f64,
        y: f64,
    }

    unsafe impl Encode for CGPoint {
        const ENCODING: Encoding = Encoding::Struct(
            "CGPoint",
            &[<f64 as Encode>::ENCODING, <f64 as Encode>::ENCODING],
        );
    }

    #[repr(C)]
    #[derive(Clone, Copy, Debug, Default)]
    struct CGSize {
        width: f64,
        height: f64,
    }

    unsafe impl Encode for CGSize {
        const ENCODING: Encoding = Encoding::Struct(
            "CGSize",
            &[<f64 as Encode>::ENCODING, <f64 as Encode>::ENCODING],
        );
    }

    #[repr(C)]
    #[derive(Clone, Copy, Debug, Default)]
    struct CGRect {
        origin: CGPoint,
        size: CGSize,
    }

    unsafe impl Encode for CGRect {
        const ENCODING: Encoding = Encoding::Struct(
            "CGRect",
            &[<CGPoint as Encode>::ENCODING, <CGSize as Encode>::ENCODING],
        );
    }

    unsafe impl RefEncode for CGRect {
        const ENCODING_REF: Encoding = Encoding::Pointer(&Self::ENCODING);
    }

    // ── C function from Vision framework ───────────────────────────────

    #[link(name = "Vision", kind = "framework")]
    extern "C" {
        fn VNImageRectForNormalizedRect(
            boundingBox: CGRect,
            imageWidth: usize,
            imageHeight: usize,
        ) -> CGRect;
    }

    // ── Helpers ─────────────────────────────────────────────────────────

    unsafe fn ns_string(s: &str) -> *mut AnyObject {
        let c = CString::new(s).unwrap();
        msg_send![objc2::class!(NSString), stringWithUTF8String: c.as_ptr()]
    }

    unsafe fn rust_string(ns: *mut AnyObject) -> String {
        if ns.is_null() {
            return String::new();
        }
        let c: *const c_char = msg_send![ns, UTF8String];
        if c.is_null() {
            String::new()
        } else {
            CStr::from_ptr(c).to_string_lossy().into_owned()
        }
    }

    unsafe fn ns_array(objects: &[*mut AnyObject]) -> *mut AnyObject {
        msg_send![objc2::class!(NSArray), arrayWithObjects: objects.as_ptr(), count: objects.len()]
    }

    pub fn recognize_text(base64_image: &str) -> Result<RecognizeTextResponse, OcrError> {
        unsafe {
            // ── 1. base64 → NSData ──────────────────────────────────────
            let ns_base64 = ns_string(base64_image);
            let ns_data: Option<Retained<AnyObject>> = msg_send![
                msg_send![objc2::class!(NSData), alloc],
                initWithBase64EncodedString: ns_base64, options: 0
            ];
            let ns_data = ns_data.ok_or_else(|| {
                OcrError::InvalidRequest("failed to create NSData from base64".into())
            })?;

            // ── 2. NSData → NSImage ─────────────────────────────────────
            let ns_image: Option<Retained<AnyObject>> = msg_send![
                msg_send![objc2::class!(NSImage), alloc],
                initWithData: &*ns_data
            ];
            let ns_image = ns_image.ok_or_else(|| {
                OcrError::InvalidRequest("failed to create NSImage from data".into())
            })?;

            // ── 3. Get CGImage from NSImage ─────────────────────────────
            // CGImageRef comes back as a non-object, so `msg_send!` is correct.
            let zero_rect = CGRect::default();
            let cg_image: *mut c_void = msg_send![
                &*ns_image,
                CGImageForProposedRect: &zero_rect as *const CGRect as *mut CGRect,
                context: null_mut::<*mut AnyObject>(),
                hints: null_mut::<*mut AnyObject>()
            ];
            if cg_image.is_null() {
                return Err(OcrError::InvalidRequest(
                    "failed to get CGImage from NSImage".into(),
                ));
            }

            // ── 4. VNImageRequestHandler ────────────────────────────────
            let handler: Option<Retained<AnyObject>> = msg_send![
                msg_send![objc2::class!(VNImageRequestHandler), alloc],
                initWithCGImage: cg_image, options: null_mut::<AnyObject>()
            ];
            let handler = handler.ok_or_else(|| {
                OcrError::InvalidRequest("failed to create VNImageRequestHandler".into())
            })?;

            // ── 5. VNRecognizeTextRequest ───────────────────────────────
            let request: Option<Retained<AnyObject>> =
                msg_send![objc2::class!(VNRecognizeTextRequest), new];
            let request = request.ok_or_else(|| {
                OcrError::InvalidRequest("failed to create VNRecognizeTextRequest".into())
            })?;

            // Set recognition languages
            let langs = ns_array(&[ns_string("zh-Hans"), ns_string("en-US")]);
            let () = msg_send![&*request, setRecognitionLanguages: langs];

            // ── 6. Perform (synchronous) ─────────────────────────────────
            let requests = ns_array(&[&*request as *const AnyObject as *mut AnyObject]);
            let mut error: *mut AnyObject = null_mut();
            let success: bool = msg_send![&*handler, performRequests: requests, error: &mut error];

            if !success {
                let message = if !error.is_null() {
                    let desc: *mut AnyObject = msg_send![error, localizedDescription];
                    let msg = rust_string(desc);
                    if msg.is_empty() {
                        "unknown Vision error".to_owned()
                    } else {
                        msg
                    }
                } else {
                    "unknown Vision error".to_owned()
                };
                return Err(OcrError::NetworkError(message));
            }

            // ── 7. Extract results ──────────────────────────────────────
            let observations: *mut AnyObject = msg_send![&*request, results];
            let count: usize = msg_send![observations, count];
            let image_size: CGSize = msg_send![&*ns_image, size];

            let mut recognitions: Vec<TextRecognition> = Vec::with_capacity(count);

            for i in 0..count {
                let obs: *mut AnyObject = msg_send![observations, objectAtIndex: i];

                // Top candidate
                let candidates: *mut AnyObject = msg_send![obs, topCandidates: 1];
                let candidate: *mut AnyObject = msg_send![candidates, firstObject];
                if candidate.is_null() {
                    continue;
                }

                let text = rust_string(msg_send![candidate, string]);
                if text.is_empty() {
                    continue;
                }

                // `VNRecognizedTextObservation.boundingBox` — normalized CGRect
                let normalized: CGRect = msg_send![obs, boundingBox];

                // Convert to pixel coordinates via the Vision C function.
                let pixel_rect = VNImageRectForNormalizedRect(
                    normalized,
                    image_size.width as usize,
                    image_size.height as usize,
                );

                recognitions.push(TextRecognition {
                    text,
                    recognized_rect: Some(RecognizedRect {
                        x: pixel_rect.origin.x,
                        y: pixel_rect.origin.y,
                        width: pixel_rect.size.width,
                        height: pixel_rect.size.height,
                        top: None,
                        right: None,
                        bottom: None,
                        left: None,
                    }),
                });
            }

            let full_text = recognitions
                .iter()
                .map(|r| r.text.as_str())
                .collect::<Vec<_>>()
                .join(" ");

            Ok(RecognizeTextResponse {
                text: full_text,
                recognitions: Some(recognitions),
            })
        }
    }

    // ── Translation via CFNotificationCenter broadcast ──────────────────
    //
    // Communication protocol with Swift (SystemTranslationServiceBridge.swift):
    //
    //   Rust → Swift: CFNotification "com.beyondtranslate.systemTranslation.request"
    //                 userInfo (NSDictionary):
    //                   - translate: requestId, operation=translate, text,
    //                                sourceLanguage, targetLanguage
    //                   - detectLanguage: requestId, operation=detectLanguage,
    //                                     texts (JSON string array)
    //
    //   Swift → Rust: CFNotification "com.beyondtranslate.systemTranslation.response"
    //                 userInfo (NSDictionary): requestId, operation, success,
    //                                          translatedText, detectedSourceLanguage,
    //                                          detections (JSON string array), error
    //
    // ── CFNotificationCenter C FFI ──────────────────────────────────────

    type CFNotificationCenterRef = *const c_void;
    type CFStringRef = *const c_void;
    type CFDictionaryRef = *const c_void;

    #[repr(C)]
    #[derive(Clone, Copy)]
    struct CFRange {
        location: isize,
        length: isize,
    }

    extern "C" {
        fn CFNotificationCenterGetLocalCenter() -> CFNotificationCenterRef;

        fn CFNotificationCenterAddObserver(
            center: CFNotificationCenterRef,
            observer: *const c_void,
            callback: unsafe extern "C" fn(
                CFNotificationCenterRef,
                *mut c_void,
                CFStringRef,
                *const c_void,
                CFDictionaryRef,
            ),
            name: CFStringRef,
            object: *const c_void,
            suspensionBehavior: isize,
        );

        fn CFNotificationCenterPostNotification(
            center: CFNotificationCenterRef,
            name: CFStringRef,
            object: *const c_void,
            userInfo: CFDictionaryRef,
            deliverImmediately: bool,
        );

        fn CFStringCreateWithCString(
            alloc: *const c_void,
            cStr: *const c_char,
            encoding: u32,
        ) -> CFStringRef;

        fn CFStringGetLength(theString: CFStringRef) -> isize;

        fn CFStringGetMaximumSizeForEncoding(length: isize, encoding: u32) -> isize;

        fn CFStringGetCString(
            theString: CFStringRef,
            buffer: *mut c_char,
            bufferSize: isize,
            encoding: u32,
        ) -> bool;

        fn CFRelease(cf: *const c_void);
    }

    #[link(name = "CoreServices", kind = "framework")]
    extern "C" {
        fn DCSCopyTextDefinition(
            dictionary: *const c_void,
            textString: CFStringRef,
            range: CFRange,
        ) -> CFStringRef;
    }

    const CF_STRING_ENCODING_UTF8: u32 = 0x08000100;

    unsafe fn cf_string_to_string(value: CFStringRef) -> Option<String> {
        if value.is_null() {
            return None;
        }

        let length = CFStringGetLength(value);
        let max_size = CFStringGetMaximumSizeForEncoding(length, CF_STRING_ENCODING_UTF8) + 1;
        if max_size <= 0 {
            return Some(String::new());
        }

        let mut buffer = vec![0_i8; max_size as usize];
        if !CFStringGetCString(
            value,
            buffer.as_mut_ptr(),
            max_size,
            CF_STRING_ENCODING_UTF8,
        ) {
            return None;
        }

        Some(
            CStr::from_ptr(buffer.as_ptr())
                .to_string_lossy()
                .into_owned(),
        )
    }

    // ── Pending request registry (thread-safe) ──────────────────────────

    use std::collections::HashMap;
    use std::sync::atomic::{AtomicU64, Ordering};
    use std::sync::mpsc;
    use std::sync::{Mutex, OnceLock};

    static NEXT_REQ_ID: AtomicU64 = AtomicU64::new(1);

    enum SystemTranslationResponse {
        Translation(TranslateResponse),
        LanguageDetection(DetectLanguageResponse),
    }

    struct PendingTx {
        sender: mpsc::Sender<Result<SystemTranslationResponse, TranslationError>>,
    }

    fn pending_registry() -> &'static Mutex<HashMap<String, PendingTx>> {
        static REG: OnceLock<Mutex<HashMap<String, PendingTx>>> = OnceLock::new();
        REG.get_or_init(|| Mutex::new(HashMap::new()))
    }

    // ── Response callback (called by CFNotificationCenter) ──────────────

    unsafe extern "C" fn on_translation_response(
        _center: CFNotificationCenterRef,
        _observer: *mut c_void,
        _name: CFStringRef,
        _object: *const c_void,
        user_info: CFDictionaryRef,
    ) {
        if user_info.is_null() {
            return;
        }

        // Read values from the NSDictionary via objc2 msg_send!
        let read_key = |key: &str| -> Option<String> {
            unsafe {
                let k = ns_string(key);
                let v: *mut AnyObject = msg_send![user_info as *mut AnyObject, objectForKey: k];
                if v.is_null() {
                    None
                } else {
                    Some(rust_string(v))
                }
            }
        };

        let request_id = match read_key("requestId") {
            Some(id) => id,
            None => return,
        };

        let mut reg = pending_registry().lock().unwrap();
        let entry = match reg.remove(&request_id) {
            Some(e) => e,
            None => return, // already handled or timed out
        };

        let success = read_key("success");
        if success.as_deref() == Some("true") {
            let operation = read_key("operation");
            if operation.as_deref() == Some("detectLanguage") {
                let detections_json = read_key("detections").unwrap_or_else(|| "[]".to_owned());
                let detections = match serde_json::from_str::<Vec<TextDetection>>(&detections_json)
                {
                    Ok(detections) => detections,
                    Err(error) => {
                        let _ = entry
                            .sender
                            .send(Err(TranslationError::SerializationError(error.to_string())));
                        return;
                    }
                };

                let _ = entry
                    .sender
                    .send(Ok(SystemTranslationResponse::LanguageDetection(
                        DetectLanguageResponse {
                            detections: Some(detections),
                        },
                    )));
            } else {
                let translated = read_key("translatedText").unwrap_or_default();
                let detected = read_key("detectedSourceLanguage").filter(|s| !s.is_empty());

                let _ = entry.sender.send(Ok(SystemTranslationResponse::Translation(
                    TranslateResponse {
                        translations: vec![TextTranslation {
                            detected_source_language: detected,
                            text: translated,
                            audio_url: None,
                        }],
                    },
                )));
            }
        } else {
            let err_msg =
                read_key("error").unwrap_or_else(|| "unknown system translation error".into());
            let _ = entry
                .sender
                .send(Err(TranslationError::NetworkError(err_msg)));
        }
    }

    // ── One-shot observer registration ──────────────────────────────────

    fn ensure_observer() {
        use std::sync::Once;
        static INIT: Once = Once::new();
        INIT.call_once(|| unsafe {
            let center = CFNotificationCenterGetLocalCenter();
            let name = CFStringCreateWithCString(
                std::ptr::null(),
                b"com.beyondtranslate.systemTranslation.response\0".as_ptr() as *const c_char,
                CF_STRING_ENCODING_UTF8,
            );
            CFNotificationCenterAddObserver(
                center,
                std::ptr::null(),
                on_translation_response,
                name,
                std::ptr::null(),
                0,
            );
        });
    }

    // ── Post a translation request via CFNotification ───────────────────

    unsafe fn post_translation_request(
        request_id: &str,
        text: &str,
        source: Option<&str>,
        target: &str,
    ) {
        let keys = ns_array(&[
            ns_string("requestId"),
            ns_string("operation"),
            ns_string("text"),
            ns_string("sourceLanguage"),
            ns_string("targetLanguage"),
        ]);
        let values = ns_array(&[
            ns_string(request_id),
            ns_string("translate"),
            ns_string(text),
            ns_string(source.unwrap_or("auto")),
            ns_string(target),
        ]);

        let dict: Option<Retained<AnyObject>> = msg_send![
            objc2::class!(NSDictionary),
            dictionaryWithObjects: values,
            forKeys: keys
        ];

        if let Some(dict) = dict {
            let center = CFNotificationCenterGetLocalCenter();
            let name = CFStringCreateWithCString(
                std::ptr::null(),
                b"com.beyondtranslate.systemTranslation.request\0".as_ptr() as *const c_char,
                CF_STRING_ENCODING_UTF8,
            );
            CFNotificationCenterPostNotification(
                center,
                name,
                std::ptr::null(),
                &*dict as *const AnyObject as CFDictionaryRef,
                true,
            );
        }
    }

    unsafe fn post_detect_language_request(request_id: &str, texts_json: &str) {
        let keys = ns_array(&[
            ns_string("requestId"),
            ns_string("operation"),
            ns_string("texts"),
        ]);
        let values = ns_array(&[
            ns_string(request_id),
            ns_string("detectLanguage"),
            ns_string(texts_json),
        ]);

        let dict: Option<Retained<AnyObject>> = msg_send![
            objc2::class!(NSDictionary),
            dictionaryWithObjects: values,
            forKeys: keys
        ];

        if let Some(dict) = dict {
            let center = CFNotificationCenterGetLocalCenter();
            let name = CFStringCreateWithCString(
                std::ptr::null(),
                b"com.beyondtranslate.systemTranslation.request\0".as_ptr() as *const c_char,
                CF_STRING_ENCODING_UTF8,
            );
            CFNotificationCenterPostNotification(
                center,
                name,
                std::ptr::null(),
                &*dict as *const AnyObject as CFDictionaryRef,
                true,
            );
        }
    }

    // ── Public translate API ────────────────────────────────────────────

    pub async fn detect_language(
        request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, TranslationError> {
        ensure_observer();

        if request.texts.is_empty() {
            return Err(TranslationError::InvalidRequest(
                "texts is required".to_owned(),
            ));
        }

        let texts_json = serde_json::to_string(&request.texts)
            .map_err(|error| TranslationError::SerializationError(error.to_string()))?;
        let request_id = NEXT_REQ_ID.fetch_add(1, Ordering::SeqCst).to_string();
        let (tx, rx) = mpsc::channel();

        pending_registry()
            .lock()
            .unwrap()
            .insert(request_id.clone(), PendingTx { sender: tx });

        unsafe {
            post_detect_language_request(&request_id, &texts_json);
        }

        let result = std::thread::spawn(move || {
            rx.recv().unwrap_or_else(|_| {
                Err(TranslationError::NetworkError(
                    "translation response channel closed unexpectedly".into(),
                ))
            })
        })
        .join()
        .map_err(|_| TranslationError::NetworkError("translation thread panicked".into()))?;

        match result? {
            SystemTranslationResponse::LanguageDetection(response) => Ok(response),
            SystemTranslationResponse::Translation(_) => Err(TranslationError::SerializationError(
                "unexpected translation response for language detection request".to_owned(),
            )),
        }
    }

    pub async fn translate(
        request: &TranslateRequest,
    ) -> Result<TranslateResponse, TranslationError> {
        ensure_observer();

        let request_id = NEXT_REQ_ID.fetch_add(1, Ordering::SeqCst).to_string();
        let (tx, rx) = mpsc::channel();

        pending_registry()
            .lock()
            .unwrap()
            .insert(request_id.clone(), PendingTx { sender: tx });

        let target = request.target_language.as_deref().ok_or_else(|| {
            TranslationError::InvalidRequest("target_language is required".into())
        })?;

        unsafe {
            post_translation_request(
                &request_id,
                &request.text,
                request.source_language.as_deref(),
                target,
            );
        }

        // Bridge from sync mpsc to async: spawn a blocking thread.
        // The CFNotificationCenter callback fires on the main run loop,
        // so blocking here is safe — no deadlock.
        let result = std::thread::spawn(move || {
            rx.recv().unwrap_or_else(|_| {
                Err(TranslationError::NetworkError(
                    "translation response channel closed unexpectedly".into(),
                ))
            })
        })
        .join()
        .map_err(|_| TranslationError::NetworkError("translation thread panicked".into()))?;

        match result? {
            SystemTranslationResponse::Translation(response) => Ok(response),
            SystemTranslationResponse::LanguageDetection(_) => {
                Err(TranslationError::SerializationError(
                    "unexpected language detection response for translation request".to_owned(),
                ))
            }
        }
    }

    pub async fn look_up(request: &LookUpRequest) -> Result<LookUpResponse, DictionaryError> {
        let word = request.word.trim();
        if word.is_empty() {
            return Err(DictionaryError::InvalidRequest(
                "word is required".to_owned(),
            ));
        }

        let c_word = CString::new(word)
            .map_err(|_| DictionaryError::InvalidRequest("word contains NUL byte".to_owned()))?;

        unsafe {
            let text = CFStringCreateWithCString(
                std::ptr::null(),
                c_word.as_ptr(),
                CF_STRING_ENCODING_UTF8,
            );
            if text.is_null() {
                return Err(DictionaryError::SerializationError(
                    "failed to create CFString".to_owned(),
                ));
            }

            let definition = DCSCopyTextDefinition(
                std::ptr::null(),
                text,
                CFRange {
                    location: 0,
                    length: CFStringGetLength(text),
                },
            );
            CFRelease(text);

            let definition_text = match cf_string_to_string(definition) {
                Some(value) if !value.trim().is_empty() => value.trim().to_owned(),
                _ => {
                    if !definition.is_null() {
                        CFRelease(definition);
                    }
                    return Ok(empty_lookup_response(word));
                }
            };

            CFRelease(definition);

            Ok(parse_lookup_response(word, &definition_text))
        }
    }

    /// Parses the raw dictionary definition text from `DCSCopyTextDefinition`
    /// into the structured `LookUpResponse` model fields.
    ///
    /// Strategy:
    /// 1. Extract pronunciation from `|...|` blocks (works reliably)
    /// 2. Strip those blocks and keep the remainder as definition body
    /// 3. Try to split the body into structured sections using known markers
    /// 4. If splitting fails, keep the entire body as one piece
    fn parse_lookup_response(word: &str, text: &str) -> LookUpResponse {
        let text = text.trim();
        if text.is_empty() {
            return empty_lookup_response(word);
        }

        let pronunciations = extract_pronunciation(text);
        let body = strip_headword(&strip_pipe_blocks(text), word);

        let definitions = if body.is_empty() {
            vec![]
        } else {
            parse_definition_sections(&body)
        };

        LookUpResponse {
            translations: Vec::<TextTranslation>::new(),
            word: Some(word.to_owned()),
            tip: None,
            tags: None,
            definitions: if definitions.is_empty() {
                None
            } else {
                Some(definitions)
            },
            pronunciations: if pronunciations.is_empty() {
                None
            } else {
                Some(pronunciations)
            },
            images: None,
            phrases: None,
            tenses: None,
            sentences: None,
            etymology: None,
            synonyms: None,
        }
    }

    /// Extracts pronunciation from the first `|...|` block in the text.
    /// Handles patterns like: `| BrE ... , AmE ... |` or `|pronunciation|`.
    fn extract_pronunciation(text: &str) -> Vec<WordPronunciation> {
        // Find the first pipe pair
        let pipe_start = match text.find('|') {
            Some(p) => p,
            None => return vec![],
        };
        let after_start = &text[pipe_start + 1..];
        let pipe_end = match after_start.find('|') {
            Some(p) => p,
            None => return vec![],
        };
        let content = after_start[..pipe_end].trim();

        if content.is_empty() {
            return vec![];
        }

        // Detect if this looks like a pronunciation block by checking
        // for IPA phonetic characters or known labels (BrE, AmE, etc.)
        let has_ipa = content.chars().any(|c| {
            matches!(
                c,
                'ə' | 'ː'
                    | 'ˈ'
                    | 'ˌ'
                    | 'ɛ'
                    | 'ɒ'
                    | 'ʌ'
                    | 'θ'
                    | 'ð'
                    | 'ʃ'
                    | 'ʒ'
                    | 'ŋ'
                    | 'ɡ'
                    | 'ɪ'
                    | 'ʊ'
                    | 'ɔ'
                    | 'ɑ'
                    | 'ɜ'
                    | 'æ'
                    | 'ɹ'
                    | 'ɾ'
            )
        });
        let has_label =
            content.to_lowercase().contains("bre") || content.to_lowercase().contains("ame");

        if !has_ipa && !has_label {
            return vec![];
        }

        let mut result = Vec::new();

        if has_label {
            let mut current_type: Option<String> = None;
            let mut current_symbols: Vec<String> = Vec::new();

            let flush_current =
                |result: &mut Vec<WordPronunciation>,
                 current_type: &mut Option<String>,
                 current_symbols: &mut Vec<String>| {
                    if current_symbols.is_empty() {
                        return;
                    }

                    result.push(WordPronunciation {
                        r#type: current_type.take(),
                        phonetic_symbol: Some(current_symbols.join(", ")),
                        audio_url: None,
                    });
                    current_symbols.clear();
                };

            for part in content.split(',') {
                let part = part.trim();
                if part.is_empty() {
                    continue;
                }

                let lower = part.to_ascii_lowercase();
                let labeled = if lower.starts_with("bre") {
                    Some(("uk".to_owned(), part[3..].trim().to_owned()))
                } else if lower.starts_with("ame") {
                    Some(("us".to_owned(), part[3..].trim().to_owned()))
                } else {
                    None
                };

                if let Some((label, symbol)) = labeled {
                    flush_current(&mut result, &mut current_type, &mut current_symbols);
                    current_type = Some(label);
                    if !symbol.is_empty() {
                        current_symbols.push(symbol);
                    }
                } else if !part.is_empty() {
                    current_symbols.push(part.to_owned());
                }
            }

            flush_current(&mut result, &mut current_type, &mut current_symbols);
        } else {
            result.push(WordPronunciation {
                r#type: None,
                phonetic_symbol: Some(content.to_owned()),
                audio_url: None,
            });
        }

        result
    }

    /// Removes all `|...|` blocks from the text and returns the remainder.
    fn strip_pipe_blocks(text: &str) -> String {
        let mut result = String::with_capacity(text.len());
        let mut in_pipe = false;

        for ch in text.chars() {
            match ch {
                '|' => in_pipe = !in_pipe,
                _ if !in_pipe => result.push(ch),
                _ => {}
            }
        }

        result.trim().to_owned()
    }

    fn strip_headword(body: &str, word: &str) -> String {
        let body = body.trim();
        let word = word.trim();
        if word.is_empty() || body.len() <= word.len() {
            return body.to_owned();
        }

        let Some(prefix) = body.get(..word.len()) else {
            return body.to_owned();
        };
        let rest = &body[word.len()..];
        if prefix.eq_ignore_ascii_case(word)
            && rest
                .chars()
                .next()
                .map(char::is_whitespace)
                .unwrap_or(false)
        {
            rest.trim().to_owned()
        } else {
            body.to_owned()
        }
    }

    /// Parses the definition body into `WordDefinition` entries.
    /// Tries multiple splitting strategies in order.
    fn parse_definition_sections(body: &str) -> Vec<WordDefinition> {
        let body = body.trim();
        if body.is_empty() {
            return vec![];
        }

        // Strategy 1: Try splitting by `▶` (U+25B6) — English dictionary format
        let sections = split_by_triangle(body);
        if sections.len() > 1 {
            return sections
                .iter()
                .filter_map(|s| {
                    let s = s.trim();
                    if s.is_empty() {
                        return None;
                    }
                    let (pos, lines) = split_pos_and_defs(s);
                    make_def(pos, lines)
                })
                .collect();
        }

        // Strategy 2: Try splitting by "A.", "B.", "C." markers — bilingual dict format
        let letter_sections = split_by_letters(body);
        if !letter_sections.is_empty() {
            return letter_sections
                .into_iter()
                .filter_map(|(_label, content)| parse_inline_definition_section(content))
                .collect();
        }

        // Strategy 3: macOS bilingual dictionaries often return one inline section:
        // `noun ① ... ② ...` or `noun translation`.
        if let Some(definition) = parse_inline_definition_section(body) {
            if definition.name.is_some()
                || definition
                    .values
                    .as_ref()
                    .map(|values| values.len() > 1)
                    .unwrap_or(false)
            {
                return vec![definition];
            }
        }

        // Strategy 4: Single section with circled-digit items
        let items = split_by_circled(body);
        if items.len() > 1 {
            let values: Vec<String> = items
                .into_iter()
                .map(clean_definition_value)
                .filter(|s| !s.is_empty())
                .collect();
            if !values.is_empty() {
                return vec![WordDefinition {
                    r#type: None,
                    name: None,
                    values: Some(values),
                }];
            }
        }

        // Strategy 5: Single section with numbered items (1., 2., etc.)
        let (_pos, lines) = split_pos_and_defs(body);
        let stripped: Vec<String> = lines
            .iter()
            .map(|l| clean_definition_value(&strip_leading_number(l)))
            .filter(|v| !v.is_empty())
            .collect();
        if !stripped.is_empty() {
            return vec![WordDefinition {
                r#type: None,
                name: None,
                values: Some(stripped),
            }];
        }

        // Fallback: whole body as one definition
        vec![WordDefinition {
            r#type: None,
            name: None,
            values: Some(vec![clean_definition_value(body)]),
        }]
    }

    fn parse_inline_definition_section(content: &str) -> Option<WordDefinition> {
        let content = content.trim();
        if content.is_empty() {
            return None;
        }

        let marker_index = first_circled_marker_index(content);
        let (head, values_text) = marker_index
            .map(|index| (&content[..index], Some(&content[index..])))
            .unwrap_or((content, None));

        let (name, head_remainder) = split_part_of_speech(head);
        let mut values = Vec::new();

        if let Some(values_text) = values_text {
            values.extend(
                split_by_circled(values_text)
                    .into_iter()
                    .map(clean_definition_value)
                    .filter(|value| !value.is_empty()),
            );
        }

        if values.is_empty() {
            let value = clean_definition_value(head_remainder.unwrap_or(head));
            if !value.is_empty() {
                values.push(value);
            }
        } else if let Some(remainder) = head_remainder {
            let remainder = clean_definition_value(remainder);
            if !remainder.is_empty() && !looks_like_form_metadata(&remainder) {
                values.insert(0, remainder);
            }
        }

        if name.is_none() && values.is_empty() {
            None
        } else {
            Some(WordDefinition {
                r#type: None,
                name,
                values: if values.is_empty() {
                    None
                } else {
                    Some(values)
                },
            })
        }
    }

    fn split_part_of_speech(text: &str) -> (Option<String>, Option<&str>) {
        let text = text.trim();
        for part_of_speech in PARTS_OF_SPEECH {
            if text.eq_ignore_ascii_case(part_of_speech) {
                return (Some((*part_of_speech).to_owned()), None);
            }
            if text.len() > part_of_speech.len() {
                if let Some(prefix) = text.get(..part_of_speech.len()) {
                    if prefix.eq_ignore_ascii_case(part_of_speech) {
                        let rest = &text[part_of_speech.len()..];
                        if rest
                            .chars()
                            .next()
                            .map(char::is_whitespace)
                            .unwrap_or(false)
                        {
                            return (Some((*part_of_speech).to_owned()), Some(rest.trim()));
                        }
                    }
                }
            }
        }

        (None, Some(text))
    }

    const PARTS_OF_SPEECH: &[&str] = &[
        "auxiliary verb",
        "intransitive verb",
        "transitive verb",
        "modal verb",
        "phrasal verb",
        "proper noun",
        "plural noun",
        "cardinal number",
        "ordinal number",
        "combining form",
        "past participle",
        "present participle",
        "adjective",
        "adverb",
        "article",
        "conjunction",
        "determiner",
        "exclamation",
        "interjection",
        "noun",
        "number",
        "prefix",
        "preposition",
        "pronoun",
        "suffix",
        "symbol",
        "verb",
    ];

    fn looks_like_form_metadata(value: &str) -> bool {
        let lower = value.to_ascii_lowercase();
        lower.contains("comparative form")
            || lower.contains("superlative form")
            || lower.contains("plural form")
            || lower.contains("past tense")
            || lower.contains("past participle")
            || lower.contains("present participle")
    }

    fn clean_definition_value(value: &str) -> String {
        value
            .split_whitespace()
            .collect::<Vec<_>>()
            .join(" ")
            .trim_matches(|c: char| c == ';' || c == ',' || c.is_whitespace())
            .to_owned()
    }

    fn first_circled_marker_index(content: &str) -> Option<usize> {
        content
            .char_indices()
            .find(|(_, c)| is_circled_marker(*c))
            .map(|(index, _)| index)
    }

    fn is_circled_marker(c: char) -> bool {
        matches!(
            c,
            '\u{2460}'
                | '\u{2461}'
                | '\u{2462}'
                | '\u{2463}'
                | '\u{2464}'
                | '\u{2465}'
                | '\u{2466}'
                | '\u{2467}'
                | '\u{2468}'
                | '\u{2469}'
                | '\u{246A}'
                | '\u{246B}'
                | '\u{246C}'
                | '\u{246D}'
                | '\u{246E}'
                | '\u{246F}'
                | '\u{2470}'
                | '\u{2471}'
                | '\u{2472}'
                | '\u{2473}'
                | '\u{3251}'
                | '\u{3252}'
                | '\u{3253}'
                | '\u{3254}'
                | '\u{3255}'
                | '\u{3256}'
                | '\u{3257}'
                | '\u{3258}'
                | '\u{3259}'
                | '\u{325A}'
                | '\u{325B}'
                | '\u{325C}'
                | '\u{325D}'
                | '\u{325E}'
                | '\u{325F}'
        )
    }

    /// Splits text by `▶` (U+25B6) — marks part-of-speech sections in English dictionaries.
    fn split_by_triangle(text: &str) -> Vec<&str> {
        let marker = '\u{25B6}';
        let mut sections: Vec<&str> = Vec::new();
        let mut start = 0;
        for (i, _c) in text.char_indices() {
            if text[i..].starts_with(marker) {
                if i > start {
                    sections.push(&text[start..i]);
                }
                // Skip the marker character itself
                start = i + marker.len_utf8();
            }
        }
        if start < text.len() {
            sections.push(&text[start..]);
        }
        sections
    }

    /// Splits a section (e.g. `"noun\n1. first def\n2. second def"`) into
    /// the part-of-speech name and the individual definition lines.
    fn split_pos_and_defs(section: &str) -> (String, Vec<String>) {
        let section = section.trim();
        if section.is_empty() {
            return (String::new(), vec![]);
        }

        let lines: Vec<&str> = section.lines().collect();
        if lines.is_empty() {
            return (section.to_owned(), vec![]);
        }

        // Find the first definition line (starts with a digit + '.' or a bullet).
        let def_start = lines.iter().position(|l| {
            let trimmed = l.trim();
            !trimmed.is_empty() && looks_like_definition_line(trimmed)
        });

        match def_start {
            Some(idx) => {
                let pos_name = lines[..idx]
                    .iter()
                    .map(|l| l.trim())
                    .filter(|l| !l.is_empty())
                    .collect::<Vec<_>>()
                    .join(" ");
                let def_lines: Vec<String> = lines[idx..]
                    .iter()
                    .map(|l| l.trim().to_owned())
                    .filter(|l| !l.is_empty())
                    .collect();
                (pos_name, def_lines)
            }
            None => {
                // No definition markers found; treat the whole section as a single definition
                (String::new(), vec![section.to_owned()])
            }
        }
    }

    /// Returns `true` if a line looks like a dictionary definition entry.
    fn looks_like_definition_line(line: &str) -> bool {
        let trimmed = line.trim();
        if trimmed.is_empty() {
            return false;
        }
        let first_char = trimmed.chars().next().unwrap();
        // Starts with a digit + '.' (e.g., "1. ", "2. ")
        if first_char.is_ascii_digit() {
            if let Some(rest) = trimmed.get(1..) {
                return rest.trim_start().starts_with('.');
            }
        }
        // Starts with a bullet (•, -, etc.)
        matches!(first_char, '•' | '-' | '*' | '·')
    }

    /// Strips a leading number + dot (e.g., "1. ", "2. ") from a definition line.
    fn strip_leading_number(line: &str) -> String {
        let trimmed = line.trim();
        if let Some(dot_pos) = trimmed.find('.').or_else(|| trimmed.find(')')) {
            let prefix = &trimmed[..dot_pos];
            if prefix
                .chars()
                .all(|c| c.is_ascii_digit() || c == '(' || c == ' ')
            {
                let rest = trimmed[dot_pos + 1..].trim();
                if !rest.is_empty() {
                    return rest.to_owned();
                }
            }
        }
        trimmed.to_owned()
    }

    /// Splits text by section markers like `A.`, `B.`, `C.` (uppercase letter + period).
    /// Returns `Vec<(label, content)>`.
    fn split_by_letters(text: &str) -> Vec<(String, &str)> {
        let mut sections: Vec<(String, &str)> = Vec::new();
        // We need to preserve the original text to take slices from it.
        // Use a manual scan for "A." at the start or " A." between sections.
        if text.len() < 3 {
            return sections;
        }

        let mut prev_start: Option<(usize, String)> = None;
        for (i, ch) in text.char_indices() {
            let remaining = &text[i..];
            let marker_at_start = i == 0
                && remaining.as_bytes().len() >= 2
                && remaining.as_bytes()[0].is_ascii_uppercase()
                && remaining.as_bytes()[1] == b'.';
            let marker_after_space = ch.is_whitespace()
                && remaining.as_bytes().len() >= 3
                && remaining.as_bytes()[1].is_ascii_uppercase()
                && remaining.as_bytes()[2] == b'.';

            if marker_at_start || marker_after_space {
                let label_index = if marker_at_start { i } else { i + 1 };
                let label = char::from(text.as_bytes()[label_index]).to_string();
                if let Some((start, prev_label)) = prev_start.take() {
                    let content = &text[start..i];
                    if !content.trim().is_empty() {
                        sections.push((prev_label, content));
                    }
                }
                prev_start = Some((label_index + 2, label));
            }
        }

        if let Some((start, label)) = prev_start.take() {
            let content = &text[start..];
            if !content.trim().is_empty() {
                sections.push((label, content));
            }
        }

        sections
    }

    /// Splits content by circled-digit markers ①, ②, ③, etc.
    /// Returns the parts BETWEEN the markers (excluding the markers themselves).
    fn split_by_circled(content: &str) -> Vec<&str> {
        let mut positions: Vec<usize> = Vec::new();
        for (i, c) in content.char_indices() {
            if is_circled_marker(c) {
                positions.push(i);
            }
        }

        if positions.is_empty() {
            return vec![content];
        }

        let mut parts = Vec::new();
        let mut last = 0;

        for &pos in &positions {
            // Everything from `last` to this marker (exclusive)
            if pos > last {
                parts.push(&content[last..pos]);
            }
            last = pos;
            // Skip the marker character itself
            let marker_len = content[last..]
                .chars()
                .next()
                .map(|c| c.len_utf8())
                .unwrap_or(0);
            last += marker_len;
        }
        // Remaining text after the last marker
        if last < content.len() {
            parts.push(&content[last..]);
        }

        parts
    }

    /// Helper to build a `WordDefinition` from a part-of-speech name and definition lines.
    fn make_def(pos_name: String, def_lines: Vec<String>) -> Option<WordDefinition> {
        let stripped: Vec<String> = def_lines
            .iter()
            .map(|l| strip_leading_number(l))
            .filter(|v| !v.is_empty())
            .collect();

        if !stripped.is_empty() {
            Some(WordDefinition {
                r#type: if pos_name.is_empty() {
                    None
                } else {
                    Some(pos_name)
                },
                name: None,
                values: Some(stripped),
            })
        } else if !def_lines.is_empty() {
            Some(WordDefinition {
                r#type: None,
                name: if pos_name.is_empty() {
                    None
                } else {
                    Some(pos_name)
                },
                values: Some(def_lines),
            })
        } else {
            None
        }
    }

    fn empty_lookup_response(word: &str) -> LookUpResponse {
        LookUpResponse {
            translations: Vec::<TextTranslation>::new(),
            word: Some(word.to_owned()),
            tip: None,
            tags: None,
            definitions: None,
            pronunciations: None,
            images: None,
            phrases: None,
            tenses: None,
            sentences: None,
            etymology: None,
            synonyms: None,
        }
    }

    #[cfg(test)]
    mod tests {
        use super::*;

        #[test]
        fn parses_macos_bilingual_lookup_sections() {
            let response = parse_lookup_response(
                "hello",
                "hello | BrE həˈləʊ, hɛˈləʊ, AmE həˈloʊ, hɛˈloʊ | A. noun 问候 wènhòu B. exclamation ① (greeting) 你好 nǐ hǎo; (on phone) 喂 wèi ② British (in surprise) 嘿 hēi",
            );

            let pronunciations = response.pronunciations.expect("pronunciations");
            assert_eq!(pronunciations.len(), 2);
            assert_eq!(pronunciations[0].r#type.as_deref(), Some("uk"));
            assert_eq!(
                pronunciations[0].phonetic_symbol.as_deref(),
                Some("həˈləʊ, hɛˈləʊ")
            );
            assert_eq!(pronunciations[1].r#type.as_deref(), Some("us"));
            assert_eq!(
                pronunciations[1].phonetic_symbol.as_deref(),
                Some("həˈloʊ, hɛˈloʊ")
            );

            let definitions = response.definitions.expect("definitions");
            assert_eq!(definitions.len(), 2);
            assert_eq!(definitions[0].name.as_deref(), Some("noun"));
            assert_eq!(
                definitions[0].values.as_deref(),
                Some(&["问候 wènhòu".to_owned()][..])
            );
            assert_eq!(definitions[1].name.as_deref(), Some("exclamation"));
            assert_eq!(
                definitions[1].values.as_deref(),
                Some(
                    &[
                        "(greeting) 你好 nǐ hǎo; (on phone) 喂 wèi".to_owned(),
                        "British (in surprise) 嘿 hēi".to_owned()
                    ][..]
                )
            );
        }

        #[test]
        fn parses_single_inline_circled_section() {
            let response = parse_lookup_response(
                "world",
                "world | BrE wəːld, AmE wərld | noun ① (earth, universe) the world 世界 ② (section of earth) [世界的] 某一地区 mǒu yī dìqū",
            );
            let definitions = response.definitions.expect("definitions");

            assert_eq!(definitions.len(), 1);
            assert_eq!(definitions[0].name.as_deref(), Some("noun"));
            assert_eq!(
                definitions[0].values.as_deref(),
                Some(
                    &[
                        "(earth, universe) the world 世界".to_owned(),
                        "(section of earth) [世界的] 某一地区 mǒu yī dìqū".to_owned()
                    ][..]
                )
            );
        }
    }
}

// ── Windows: Windows.Media.Ocr ────────────────────────────────────────────

#[cfg(target_os = "windows")]
mod platform {
    use super::*;
    use windows::{
        Graphics::Imaging::BitmapDecoder,
        Media::Ocr::OcrEngine,
        Storage::Streams::{DataWriter, InMemoryRandomAccessStream},
    };

    pub fn recognize_text(base64_image: &str) -> Result<RecognizeTextResponse, OcrError> {
        // Use a Tokio-current-thread runtime since the windows APIs are
        // async under the hood but we need a synchronous call.
        //
        // We use `futures::executor::block_on` or simply spawn a local
        // runtime here because the outer `recognize_text` on the impl is
        // already async and `OcrService` is `?Send`.
        //
        // In practice, Windows.Media.Ocr async APIs complete quickly, so
        // a simple `futures::executor::block_on` works fine.
        //
        // However, since we don't want to add a futures dependency, we use
        // `tokio::runtime::Runtime::new()?.block_on(...)`.
        let rt = tokio::runtime::Runtime::new()
            .map_err(|e| OcrError::NetworkError(format!("failed to create tokio runtime: {e}")))?;

        rt.block_on(async { recognize_text_async(base64_image).await })
    }

    async fn recognize_text_async(base64_image: &str) -> Result<RecognizeTextResponse, OcrError> {
        use windows::core::HSTRING;

        let image_bytes = base64::engine::general_purpose::STANDARD
            .decode(base64_image)
            .map_err(|e| OcrError::InvalidRequest(format!("base64 decode failed: {e}")))?;

        // Create an in-memory stream and write image bytes into it
        let stream = InMemoryRandomAccessStream::new()
            .map_err(|e| OcrError::NetworkError(format!("create stream failed: {e}")))?;

        let writer = DataWriter::CreateDataWriter(&stream)
            .map_err(|e| OcrError::NetworkError(format!("create data writer failed: {e}")))?;

        writer
            .WriteBytes(&image_bytes)
            .map_err(|e| OcrError::NetworkError(format!("write bytes failed: {e}")))?;

        writer
            .StoreAsync()
            .map_err(|e| OcrError::NetworkError(format!("store async failed: {e}")))?
            .await
            .map_err(|e| OcrError::NetworkError(format!("store async await failed: {e}")))?;

        // Set stream position to beginning
        stream
            .Seek(0)
            .map_err(|e| OcrError::NetworkError(format!("seek failed: {e}")))?;

        // Create a BitmapDecoder from the stream
        let decoder = BitmapDecoder::CreateAsync(&stream)
            .map_err(|e| OcrError::NetworkError(format!("create decoder failed: {e}")))?
            .await
            .map_err(|e| OcrError::NetworkError(format!("decoder await failed: {e}")))?;

        // Get the SoftwareBitmap
        let software_bitmap = decoder
            .GetSoftwareBitmapAsync()
            .map_err(|e| OcrError::NetworkError(format!("get software bitmap failed: {e}")))?
            .await
            .map_err(|e| OcrError::NetworkError(format!("software bitmap await failed: {e}")))?;

        // Create an OcrEngine from the user's preferred languages
        let ocr_engine = OcrEngine::TryCreateFromUserProfileLanguages()
            .map_err(|e| OcrError::NetworkError(format!("create OCR engine failed: {e}")))?;

        // Recognize the text
        let ocr_result = ocr_engine
            .RecognizeAsync(&software_bitmap)
            .map_err(|e| OcrError::NetworkError(format!("recognize failed: {e}")))?
            .await
            .map_err(|e| OcrError::NetworkError(format!("recognize await failed: {e}")))?;

        let text = ocr_result.Text().map(|s| s.to_string()).unwrap_or_default();

        Ok(RecognizeTextResponse {
            text,
            recognitions: None,
        })
    }

    pub async fn detect_language(
        _request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, TranslationError> {
        Err(TranslationError::UnsupportedMethod(
            "system language detection is not supported on Windows",
        ))
    }

    pub async fn translate(
        _request: &TranslateRequest,
    ) -> Result<TranslateResponse, TranslationError> {
        Err(TranslationError::UnsupportedMethod(
            "system translation is not supported on Windows",
        ))
    }

    pub async fn look_up(_request: &LookUpRequest) -> Result<LookUpResponse, DictionaryError> {
        Err(DictionaryError::UnsupportedMethod(
            "system dictionary is not supported on Windows",
        ))
    }
}

// ── Unsupported Platform ───────────────────────────────────────────────────

#[cfg(not(any(target_os = "macos", target_os = "windows")))]
mod platform {
    use super::*;

    pub fn recognize_text(_base64_image: &str) -> Result<RecognizeTextResponse, OcrError> {
        Err(OcrError::UnsupportedMethod(
            "system OCR is not supported on this platform",
        ))
    }

    pub async fn detect_language(
        _request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, TranslationError> {
        Err(TranslationError::UnsupportedMethod(
            "system language detection is not supported on this platform",
        ))
    }

    pub async fn translate(
        _request: &TranslateRequest,
    ) -> Result<TranslateResponse, TranslationError> {
        Err(TranslationError::UnsupportedMethod(
            "system translation is not supported on this platform",
        ))
    }

    pub async fn look_up(_request: &LookUpRequest) -> Result<LookUpResponse, DictionaryError> {
        Err(DictionaryError::UnsupportedMethod(
            "system dictionary is not supported on this platform",
        ))
    }
}

// ── System Translation Service ───────────────────────────────────────────

pub struct SystemTranslationService;

#[async_trait(?Send)]
impl TranslationService for SystemTranslationService {
    async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, TranslationError> {
        platform::detect_language(request).await
    }

    async fn translate(
        &self,
        request: TranslateRequest,
    ) -> Result<TranslateResponse, TranslationError> {
        platform::translate(&request).await
    }
}

// ── System Dictionary Service ─────────────────────────────────────────────

pub struct SystemDictionaryService;

#[async_trait(?Send)]
impl DictionaryService for SystemDictionaryService {
    async fn look_up(&self, request: LookUpRequest) -> Result<LookUpResponse, DictionaryError> {
        platform::look_up(&request).await
    }
}

// ── Provider ───────────────────────────────────────────────────────────────

pub struct SystemProvider {
    translation_service: SystemTranslationService,
    dictionary_service: SystemDictionaryService,
}

impl SystemProvider {
    pub fn new() -> Result<Self, String> {
        Ok(Self {
            translation_service: SystemTranslationService,
            dictionary_service: SystemDictionaryService,
        })
    }
}

impl Provider for SystemProvider {
    fn name(&self) -> &'static str {
        "system"
    }

    fn dictionary(&self) -> Option<&dyn DictionaryService> {
        Some(&self.dictionary_service)
    }

    fn translation(&self) -> Option<&dyn TranslationService> {
        Some(&self.translation_service)
    }

    fn ocr(&self) -> Option<&dyn OcrService> {
        Some(self)
    }
}

#[async_trait(?Send)]
impl OcrService for SystemProvider {
    async fn recognize_text(
        &self,
        request: RecognizeTextRequest,
    ) -> Result<RecognizeTextResponse, OcrError> {
        let base64_image = match (&request.base64_image, &request.image_path) {
            (Some(base64), _) => base64.clone(),
            (None, Some(path)) => {
                let bytes = std::fs::read(path).map_err(|e| {
                    OcrError::InvalidRequest(format!("failed to read image file '{path}': {e}"))
                })?;
                base64::engine::general_purpose::STANDARD.encode(&bytes)
            }
            (None, None) => {
                return Err(OcrError::InvalidRequest(
                    "either base64_image or image_path must be provided".to_owned(),
                ));
            }
        };

        platform::recognize_text(&base64_image)
    }
}
