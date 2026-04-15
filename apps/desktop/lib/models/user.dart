import 'dart:convert';

import 'package:biyi_app/models/user_preference.dart';
import 'package:biyi_app/models/user_property.dart';
import 'package:crypto/crypto.dart';

class User {
  User({
    required this.id,
    this.name,
    this.username,
    this.email,
    this.preferences = const [],
    this.properties = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<UserPreference> preferences = [];
    List<UserProperty> properties = [];

    if (json['preferences'] != null) {
      preferences = (json['preferences'] as List)
          .map((item) => UserPreference.fromJson(item))
          .toList();
    }

    if (json['properties'] != null) {
      properties = (json['properties'] as List)
          .map((item) => UserProperty.fromJson(item))
          .toList();
    }

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      preferences: preferences,
      properties: properties,
    );
  }
  int id;
  String? name;
  String? username;
  String? email;
  List<UserPreference> preferences;
  List<UserProperty> properties;

  String get avatarUrl {
    String md5Value =
        md5.convert(utf8.encode((email ?? '').toLowerCase().trim())).toString();
    return 'https://dn-qiniu-avatar.qbox.me/avatar/$md5Value';
  }

  bool get isLocalUser => id == -1;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'preferences': preferences.map((e) => e.toJson()).toList(),
      'properties': properties.map((e) => e.toJson()).toList(),
    };
  }
}
