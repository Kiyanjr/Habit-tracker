import 'package:flutter/foundation.dart';
import 'package:habit_tracker/features/auth/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserInfo? _currentUser;

  UserInfo? get currentUser => _currentUser;

  void setUserNameAndEmail({required String name, required String email}) {
    _currentUser = UserInfo(name: name, email: email);

    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
