import 'dart:io';

import 'package:chat_application/services/picUploadingServices.dart';
import 'package:flutter/material.dart';

class Registerproivder with ChangeNotifier {
  File? image;
  Picuploading picuploading = Picuploading();
  Future<void> pickPic() async {
    await picuploading.imagePicker();
    if (picuploading.image != null) {
      print(picuploading.image!.path.toString());
      image = picuploading.image;
      notifyListeners();
    }
  }
}
