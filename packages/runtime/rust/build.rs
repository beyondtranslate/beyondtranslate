fn main() {
    uniffi_dart::generate_scaffolding("./src/api.udl".into()).unwrap();
}
