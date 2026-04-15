import 'package:biyi_app/models/models.dart';

abstract mixin class LocalDbListener {
  void onUserChanged(User oldUser, User newUser) {}
}
