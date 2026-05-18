pub fn normalize_optional_language(value: Option<String>) -> Option<String> {
    value
        .map(|value| value.trim().to_ascii_lowercase())
        .filter(|value| !value.is_empty())
}

pub fn normalize_required_language(value: String) -> String {
    value.trim().to_ascii_lowercase()
}

pub fn trim_required_text(value: String) -> String {
    value.trim().to_owned()
}

pub fn normalized_prefix(path: &str) -> &str {
    match path.trim_end_matches('/') {
        "" => "",
        "/" => "",
        prefix => prefix,
    }
}

#[cfg(test)]
mod tests {
    use super::{normalize_optional_language, normalized_prefix};

    #[test]
    fn trims_optional_language() {
        assert_eq!(
            normalize_optional_language(Some(" EN ".to_owned())),
            Some("en".to_owned())
        );
        assert_eq!(normalize_optional_language(Some("   ".to_owned())), None);
    }

    #[test]
    fn normalizes_root_prefix() {
        assert_eq!(normalized_prefix("/"), "");
        assert_eq!(normalized_prefix(""), "");
        assert_eq!(normalized_prefix("/admin/"), "/admin");
    }
}
