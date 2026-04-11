import 'dart:convert';

String prettyJsonString(dynamic json) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String jsonString = encoder.convert(json);

  return jsonString;
}
