class TranslationTarget {
  TranslationTarget({
    this.id,
    this.sourceLanguage,
    this.targetLanguage,
  });

  factory TranslationTarget.fromJson(Map<dynamic, dynamic> json) {
    return TranslationTarget(
      id: json['id'],
      sourceLanguage: json['sourceLanguage'],
      targetLanguage: json['targetLanguage'],
    );
  }

  String? id;
  String? sourceLanguage;
  String? targetLanguage;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
    };
  }
}
