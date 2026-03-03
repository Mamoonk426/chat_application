import 'dart:io';
import 'dart:math';

import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/services/picUploadingServices.dart';
import 'package:flutter/material.dart';

class Registerproivder with ChangeNotifier {
  String? _emailError;
  String? _passError;
  String? _nameError;

  String? get emailError => _emailError;
  String? get passError => _passError;
  String? get nameError => _nameError;

  void checkmail(String email) {
    if (email.isEmpty) {
      _emailError = 'Please fill the field';
      notifyListeners();
    } else if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$',
    ).hasMatch(email)) {
      _emailError = 'Please Enter valid mail';
      notifyListeners();
    } else {
      _emailError = null;
      notifyListeners();
    }
  }

  void checkpass(String pass) {
    if (pass.isEmpty) {
      _passError = 'Please fill the field';
      notifyListeners();
    } else if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    ).hasMatch(pass)) {
      _passError =
          '- 8+ characters\n'
          '- Uppercase letter\n'
          '- Lowercase letter\n'
          '- Number\n'
          '- Special character';
      notifyListeners();
    } else {
      _passError = null;
      notifyListeners();
    }
  }

  void checkName(String name) {
    if (name.isEmpty) {
      _nameError = 'Please fill the field';
      notifyListeners();
    } else if (!RegExp(r"^[a-zA-Z][a-zA-Z\s'-]{1,}$").hasMatch(name.trim())) {
      _nameError = 'Enter Valid Name';
      notifyListeners();
    } else {
      _nameError = null;
      notifyListeners();
    }
  }

  File? image;
  Authservices authservices = Authservices();
  String? avatarUrl;
  // Picuploading picuploading = Picuploading();
  // Future<void> pickPic() async {
  //   await picuploading.imagePicker();
  //   if (picuploading.image != null) {
  //     print(picuploading.image!.path.toString());
  //     image = picuploading.image;
  //     notifyListeners();
  //   }
  // }

  Future<void> registerUser(
    String email,
    String password,
    String name,
    BuildContext context,
  ) async {
    await authservices.register(email, password, name, context);
    notifyListeners();
  }
}
