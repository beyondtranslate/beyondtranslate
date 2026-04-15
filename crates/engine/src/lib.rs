pub fn crate_name() -> &'static str {
    env!("CARGO_PKG_NAME")
}

#[cfg(test)]
mod tests {
    use super::crate_name;

    #[test]
    fn crate_name_matches_package_name() {
        assert_eq!(crate_name(), "beyondtranslate_engine");
    }
}
