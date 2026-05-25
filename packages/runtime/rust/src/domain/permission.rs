#[cfg(target_os = "macos")]
mod platform {
    use std::ffi::c_void;
    use std::process::Command;

    use objc2::{msg_send, runtime::AnyObject};

    unsafe fn ns_string(s: &str) -> *mut AnyObject {
        let c = std::ffi::CString::new(s).unwrap();
        msg_send![objc2::class!(NSString), stringWithUTF8String: c.as_ptr()]
    }

    #[link(name = "ApplicationServices", kind = "framework")]
    extern "C" {
        fn AXIsProcessTrusted() -> bool;
        fn AXIsProcessTrustedWithOptions(options: *mut c_void) -> bool;
    }

    #[link(name = "CoreGraphics", kind = "framework")]
    extern "C" {
        fn CGPreflightScreenCaptureAccess() -> bool;
        fn CGRequestScreenCaptureAccess() -> bool;
    }

    pub fn is_accessibility_permission_granted() -> bool {
        unsafe { AXIsProcessTrusted() }
    }

    pub fn request_accessibility_permission(only_open_system_settings: bool) {
        if !only_open_system_settings {
            unsafe {
                let prompt_value: *mut AnyObject =
                    msg_send![objc2::class!(NSNumber), numberWithBool: true];
                let dict: *mut AnyObject = msg_send![
                    objc2::class!(NSDictionary),
                    dictionaryWithObject: prompt_value,
                    forKey: ns_string("AXTrustedCheckOptionPrompt")
                ];
                AXIsProcessTrustedWithOptions(dict as *mut c_void);
            }
        }

        open_privacy_pane("Privacy_Accessibility");
    }

    pub fn is_screen_recording_permission_granted() -> bool {
        unsafe { CGPreflightScreenCaptureAccess() }
    }

    pub fn request_screen_recording_permission(only_open_system_settings: bool) {
        if !only_open_system_settings && !is_screen_recording_permission_granted() {
            unsafe {
                CGRequestScreenCaptureAccess();
            }
        }

        open_privacy_pane("Privacy_ScreenCapture");
    }

    fn open_privacy_pane(anchor: &str) {
        let _ = Command::new("open")
            .arg(format!(
                "x-apple.systempreferences:com.apple.preference.security?{anchor}"
            ))
            .spawn();
    }
}

pub fn is_accessibility_permission_granted() -> bool {
    #[cfg(target_os = "macos")]
    {
        platform::is_accessibility_permission_granted()
    }
    #[cfg(not(target_os = "macos"))]
    {
        true
    }
}

pub fn request_accessibility_permission(only_open_system_settings: bool) {
    #[cfg(target_os = "macos")]
    {
        platform::request_accessibility_permission(only_open_system_settings);
    }
    #[cfg(not(target_os = "macos"))]
    {
        let _ = only_open_system_settings;
    }
}

pub fn is_screen_recording_permission_granted() -> bool {
    #[cfg(target_os = "macos")]
    {
        platform::is_screen_recording_permission_granted()
    }
    #[cfg(not(target_os = "macos"))]
    {
        true
    }
}

pub fn request_screen_recording_permission(only_open_system_settings: bool) {
    #[cfg(target_os = "macos")]
    {
        platform::request_screen_recording_permission(only_open_system_settings);
    }
    #[cfg(not(target_os = "macos"))]
    {
        let _ = only_open_system_settings;
    }
}
