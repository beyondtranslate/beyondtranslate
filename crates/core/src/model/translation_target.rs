use serde::{Deserialize, Serialize};

/// A language pair (source -> target).
///
/// `source == "auto"` means the target is always active. A concrete source
/// language only becomes active when it matches the detected language.
#[derive(Debug, Clone, PartialEq, Eq, Default, Serialize, Deserialize)]
pub struct TranslationTarget {
    pub source: String,
    pub target: String,
}

impl TranslationTarget {
    /// Sentinel value for auto-detected source language.
    pub const AUTO_SOURCE: &'static str = "auto";

    /// Returns the translation targets that should be used given the
    /// detected source language.
    pub fn filter_active(targets: &[Self], detected_language: Option<&str>) -> Vec<Self> {
        targets
            .iter()
            .filter(|t| {
                t.source == Self::AUTO_SOURCE || detected_language.is_none_or(|dl| t.source == dl)
            })
            .cloned()
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn filter_auto_source_targets() {
        let targets = vec![TranslationTarget {
            source: TranslationTarget::AUTO_SOURCE.into(),
            target: "zh-Hans".into(),
        }];

        let active = TranslationTarget::filter_active(&targets, Some("ja"));
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");
    }

    #[test]
    fn filter_auto_detect_matches() {
        let targets = vec![TranslationTarget {
            source: "en".into(),
            target: "zh-Hans".into(),
        }];

        let active = TranslationTarget::filter_active(&targets, Some("en"));
        assert_eq!(active.len(), 1);
    }

    #[test]
    fn filter_auto_detect_no_match() {
        let targets = vec![TranslationTarget {
            source: "en".into(),
            target: "zh-Hans".into(),
        }];

        let active = TranslationTarget::filter_active(&targets, Some("ja"));
        assert_eq!(active.len(), 0);
    }

    #[test]
    fn filter_auto_detect_no_detected_language() {
        let targets = vec![TranslationTarget {
            source: "en".into(),
            target: "zh-Hans".into(),
        }];

        let active = TranslationTarget::filter_active(&targets, None);
        assert_eq!(active.len(), 1);
    }

    #[test]
    fn filter_empty_targets() {
        let active = TranslationTarget::filter_active(&[], Some("en"));
        assert!(active.is_empty());
    }

    #[test]
    fn filter_mixed_strategies() {
        let targets = vec![
            TranslationTarget {
                source: "en".into(),
                target: "zh-Hans".into(),
            },
            TranslationTarget {
                source: "ja".into(),
                target: "zh-Hans".into(),
            },
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "ja".into(),
            },
        ];

        // Only "en" should match concrete sources, plus auto source.
        let active = TranslationTarget::filter_active(&targets, Some("en"));
        assert_eq!(active.len(), 2);
        assert!(active.iter().any(|t| t.target == "zh-Hans"));
        assert!(active.iter().any(|t| t.target == "ja"));
    }
}
