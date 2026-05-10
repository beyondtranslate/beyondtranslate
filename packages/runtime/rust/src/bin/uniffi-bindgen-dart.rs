use anyhow::Result;
use camino::Utf8PathBuf;

fn main() -> Result<()> {
    let mut args = std::env::args().skip(1);
    let cdylib: Utf8PathBuf = args
        .next()
        .expect("usage: uniffi-bindgen-dart <cdylib> <out_dir>")
        .into();
    let out_dir: Utf8PathBuf = args
        .next()
        .expect("usage: uniffi-bindgen-dart <cdylib> <out_dir>")
        .into();
    let manifest_dir = Utf8PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let udl = manifest_dir.join("src/api.udl");
    let config = manifest_dir.join("uniffi.toml");
    let config_override = if config.exists() {
        Some(config.as_path())
    } else {
        None
    };

    uniffi_dart::gen::generate_dart_bindings(&udl, config_override, Some(&out_dir), &cdylib, true)?;
    Ok(())
}
