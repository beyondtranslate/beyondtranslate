class OcrEngineConfig {
  OcrEngineConfig({
    this.position = -1,
    this.group,
    required this.identifier,
    required this.type,
    required this.option,
    this.disabled = false,
  });

  factory OcrEngineConfig.fromJson(Map<dynamic, dynamic> json) {
    return OcrEngineConfig(
      position: json['position'] ?? -1,
      group: json['group'],
      identifier: json['identifier'],
      type: json['type'],
      option: Map<String, dynamic>.from(json['option'] ?? {}),
      disabled: json['disabled'] ?? false,
    );
  }

  int position;
  String? group;
  final String identifier;
  String type;
  Map<String, dynamic> option;
  bool disabled = false;

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'group': group,
      'identifier': identifier,
      'type': type,
      'option': option,
      'disabled': disabled,
    };
  }
}
