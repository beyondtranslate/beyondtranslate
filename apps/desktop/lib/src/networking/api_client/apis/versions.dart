import 'dart:async';

import 'package:dio/dio.dart';

import '../../../models/version.dart';

class VersionsApi {
  VersionsApi(this._http);

  final Dio _http;

  String? _versionId;

  void setVersionId(String? id) {
    _versionId = id;
  }

  Future<List<Version>> list() async {
    final response = await _http.get('/versions');
    List<Version> list = (response.data as List)
        .map(
          (e) => Version.fromJson(e),
        )
        .toList();
    return list;
  }

  Future<Version> get() async {
    final response = await _http.get('/versions/$_versionId');

    var d = Version.fromJson(response.data);
    return d;
  }
}
