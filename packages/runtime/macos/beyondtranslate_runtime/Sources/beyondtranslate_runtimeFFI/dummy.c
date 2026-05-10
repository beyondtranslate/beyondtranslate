// SPM requires every C target to have at least one source file.
// All actual code lives in the generated header (`include/beyondtranslate_runtimeFFI.h`),
// which is consumed by the Swift binding.
void __beyondtranslate_runtime_ffi_keepalive(void) {}
