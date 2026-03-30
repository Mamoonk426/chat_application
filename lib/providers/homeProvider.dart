import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/services/getUserServices.dart';
import 'package:chat_application/view/chatListScreen.dart';
import 'package:chat_application/view/profileDetails.dart';
import 'package:chat_application/view/requestScreen.dart';
import 'package:flutter/material.dart';

class Homeprovider with ChangeNotifier {
  Widget bodyBuild(int index) {
    switch (index) {
      case 0:
        return Chatlistscreen();
      case 1:
        return Requestscreen();
      case 2:
        return Profiledetails();
      default:
        return Chatlistscreen();
    }
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  void setIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}
