class Result<T> {
  Result({
    required this.code,
    this.data,
    this.items,
  });

  factory Result.fromJson(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic> json)? convert,
  }) {
    T? data;
    List<T>? items = [];
    if (convert != null) {
      if (json['data'] != null) {
        data = convert(json['data']);
      }
      if (json['items'] != null) {
        Iterable l = json['items'] as List;
        items = l.map((item) => convert(item)).toList();
      }
    }
    return Result(
      code: json['code'],
      data: data,
      items: items,
    );
  }
  int code;
  T? data;
  List<T>? items;
}
