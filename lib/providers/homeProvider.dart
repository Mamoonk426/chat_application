import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/services/getUserServices.dart';
import 'package:flutter/material.dart';

class Homeprovider with ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  void serIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  Getuserservices getuserservices = Getuserservices();
  Future<List<Usermodel>> getUser(String email) async {
    return await getuserservices.getUsers(email.trim().toString());
  }
}
