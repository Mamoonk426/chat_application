import 'package:chat_application/services/authServices.dart';
import 'package:flutter/material.dart';

class Loginprovider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Authservices authservices = Authservices();
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      isLoading = true;
      final success = await authservices.login(email, password, context);
      isLoading = false;
      return success;
    } catch (e) {
      print(e.toString());
      isLoading = false;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
