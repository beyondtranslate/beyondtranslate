class UserProperty {
  UserProperty({
    this.key,
    this.type,
    this.value,
  });

  factory UserProperty.fromJson(Map<dynamic, dynamic> json) {
    return UserProperty(
      key: json['key'],
      type: json['type'],
      value: json['value'],
    );
  }

  String? key;
  String? type;
  String? value;

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type,
      'value': value,
    };
  }
}
