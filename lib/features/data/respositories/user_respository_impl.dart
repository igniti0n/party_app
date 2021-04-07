import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class UserRepository extends ChangeNotifier {
  User _user;

  void setUser(User user) {
    this._user = user;
    notifyListeners();
  }

  User get user => _user;
}
