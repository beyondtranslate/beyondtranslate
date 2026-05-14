use async_trait::async_trait;
use base64::Engine;
use beyondtranslate_core::{
    OcrError, OcrService, Provider, RecognizeTextRequest, RecognizeTextResponse, RecognizedRect,
    TextRecognition,
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
}

// ── Provider ───────────────────────────────────────────────────────────────

pub struct SystemProvider;

impl SystemProvider {
    pub fn new() -> Result<Self, String> {
        Ok(Self)
    }
}

impl Provider for SystemProvider {
    fn name(&self) -> &'static str {
        "system"
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
