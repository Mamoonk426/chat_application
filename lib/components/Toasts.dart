import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {
  static void errorToast(String message) {
    Fluttertoast.showToast(
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_SHORT,
      msg: message,
    );
  }

  static void successToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      gravity: ToastGravity.SNACKBAR,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
