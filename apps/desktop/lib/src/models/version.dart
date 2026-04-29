class VersionPlatform {
  VersionPlatform({
    required this.platform,
    required this.url,
  });

  factory VersionPlatform.fromJson(Map<String, dynamic> json) {
    return VersionPlatform(
      platform: json['platform'],
      url: json['url'],
    );
  }

  String platform;
  String url;

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
    };
  }
}

class Version {
  Version({
    required this.version,
    required this.buildNumber,
    required this.platforms,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    List<VersionPlatform> platforms = [];

    if (json['platforms'] != null) {
      platforms = (json['platforms'] as List)
          .map((item) => VersionPlatform.fromJson(item))
          .toList();
    }
    return Version(
      version: json['version'],
      buildNumber: json['buildNumber'],
      platforms: platforms,
    );
  }
  String version;
  int buildNumber;
  List<VersionPlatform> platforms;

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'buildNumber': buildNumber,
      'platforms': platforms.map((e) => e.toJson()).toList(),
    };
  }
}
