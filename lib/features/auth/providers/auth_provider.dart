import 'package:flutter/foundation.dart';
import 'package:habit_tracker/features/auth/models/user_model.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// English comment: Model for storing User information
class UserInfo {
  final String name;
  final String email;

  UserInfo({required this.name, required this.email});
}

class UserProvider extends ChangeNotifier {
  UserInfo? _currentUser;

  // English comment: Access current user data from any UI screen
  UserInfo? get currentUser => _currentUser;

  // 1. --- LOAD DATA (Run this at app startup) ---
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('user_name');
    String? email = prefs.getString('user_email');

    if (name != null && email != null) {
      _currentUser = UserInfo(name: name, email: email);
      notifyListeners();
    }
  }

  // 2. --- SET DATA (Run this during Sign Up or Sign In) ---
  Future<void> setUserNameAndEmail({required String name, required String email}) async {
    // English comment: Update the local variable
    _currentUser = UserInfo(name: name, email: email);

    // English comment: Save to device memory so it stays after restart
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);

    notifyListeners();
  }

  // 3. --- CLEAR DATA (Run this for Logout) ---
  Future<void> clearUser() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    
    notifyListeners();
  }
}