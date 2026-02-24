import 'dart:io';
import 'dart:math';

import 'package:chat_application/components/Toasts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Picuploading {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  File? image;
  Future<void> imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    if (image != null) {
      return;
    }
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }

  Future<String> uploading(File? image) async {
    try {
      String filename = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = firebaseStorage.ref().child(filename);
      UploadTask task = ref.putFile(image ?? File(''));
      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Image Uploaded : $downloadUrl');
      return downloadUrl;
    } catch (e) {
      Toasts.errorToast(e.toString());
      return e.toString();
    }
  }
}
