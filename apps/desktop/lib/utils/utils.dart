import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'env.dart';
import 'platform_util.dart';

// 请按文件名排序放置

final sharedEnv = Env.instance;

Directory? _dataDirectory;

Future<Directory> getAppDirectory() async {
  if (!kIsWeb && _dataDirectory == null) {
    final docDir = await getApplicationDocumentsDirectory();

    if (kIsLinux || kIsWindows) {
      _dataDirectory = Directory(path.join(docDir.parent.path, '.biyi'));
      if (!_dataDirectory!.existsSync()) {
        _dataDirectory!.createSync(recursive: true);
      }
    } else {
      _dataDirectory = docDir;
    }
  }
  if (kIsWeb && _dataDirectory == null) {
    _dataDirectory = Directory('');
  }
  return _dataDirectory!;
}

Future<Directory> getAppDataDirectory() async {
  return getAppDirectory();
}
