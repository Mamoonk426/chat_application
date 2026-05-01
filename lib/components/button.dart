import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String title;
  Function()? call;
  bool _isLoading = false;
  Button({super.key, this.call, required this.title, bool isLoading = false}) {
    _isLoading = isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: call,
      child: _isLoading
          ? SizedBox(
              width: 25.0,
              height: 25.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,

                color: Colors.white,
              ),
            )
          : Text(title.toString()),
    );
  }
}
