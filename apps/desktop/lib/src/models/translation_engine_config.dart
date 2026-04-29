class TranslationEngineConfig {
  TranslationEngineConfig({
    this.position = -1,
    this.group,
    required this.identifier,
    required this.type,
    this.supportedScopes = const [],
    required this.option,
    this.disabled = false,
  });

  factory TranslationEngineConfig.fromJson(Map<dynamic, dynamic> json) {
    return TranslationEngineConfig(
      position: json['position'] ?? -1,
      group: json['group'],
      identifier: json['identifier'],
      type: json['type'],
      supportedScopes: json['supportedScopes'] != null
          ? List<String>.from(json['supportedScopes'])
          : [],
      option: Map<String, dynamic>.from(json['option'] ?? {}),
      disabled: json['disabled'] ?? false,
    );
  }

  int position;
  String? group;
  final String identifier;
  String type;
  List<String> supportedScopes;
  Map<String, dynamic> option;
  bool disabled = false;

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'group': group,
      'identifier': identifier,
      'type': type,
      'supportedScopes': supportedScopes,
      'option': option,
      'disabled': disabled,
    };
  }
}
