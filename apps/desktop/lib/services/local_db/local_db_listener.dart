import 'package:biyi_advanced_features/biyi_advanced_features.dart';

abstract mixin class LocalDbListener {
  void onUserChanged(User oldUser, User newUser) {}
}
