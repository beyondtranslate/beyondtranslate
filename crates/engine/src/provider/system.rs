use async_trait::async_trait;
use base64::Engine;
use beyondtranslate_core::{
    DetectLanguageRequest, DetectLanguageResponse, DictionaryError, DictionaryService,
    LookUpRequest, LookUpResponse, OcrError, OcrService, Provider, RecognizeTextRequest,
    RecognizeTextResponse, RecognizedRect, TextDetection, TextRecognition, TextTranslation,
    TranslateRequest, TranslateResponse, TranslationError, TranslationService, WordDefinition,
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

            Ok(LookUpResponse {
                translations: Vec::<TextTranslation>::new(),
                word: Some(word.to_owned()),
                tip: None,
                tags: None,
                definitions: Some(vec![WordDefinition {
                    r#type: None,
                    name: None,
                    values: Some(vec![definition_text]),
                }]),
                pronunciations: None,
                images: None,
                phrases: None,
                tenses: None,
                sentences: None,
            })
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
