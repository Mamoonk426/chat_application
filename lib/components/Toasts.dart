import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {
  static void errorToast(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: message,
            contentType: ContentType.failure,
          ),
        ),
      );
  }

  static void successToast(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AwesomeSnackbarContent(
            color: Theme.of(context).primaryColor,
            title: 'Success',
            message: message,
            contentType: ContentType.success,
          ),
        ),
      );
  }
}
