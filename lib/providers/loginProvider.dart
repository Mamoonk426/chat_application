import 'package:chat_application/services/authServices.dart';
import 'package:flutter/material.dart';

class Loginprovider with ChangeNotifier {
  Authservices authservices = Authservices();
  Future<bool> login(String email, String password) async {
    return await authservices.login(email, password);
  }
}
