import 'dart:io';

import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/services/picUploadingServices.dart';
import 'package:flutter/material.dart';

class Registerproivder with ChangeNotifier {
  File? image;
  Authservices authservices = Authservices();
  String? avatarUrl;
  Picuploading picuploading = Picuploading();
  Future<void> pickPic() async {
    await picuploading.imagePicker();
    if (picuploading.image != null) {
      print(picuploading.image!.path.toString());
      image = picuploading.image;
      notifyListeners();
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    await Authservices().register(email, password, name);
  }
}
