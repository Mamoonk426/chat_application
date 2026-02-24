import 'package:chat_application/services/authServices.dart';
import 'package:flutter/material.dart';

class Loginprovider with ChangeNotifier {
  Authservices authservices = Authservices();
  Future<void> login(String email, String password) async {
    await authservices.login(email, password);
  }
}
