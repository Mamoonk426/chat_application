import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final Function()? call;
  final bool isLoading;
  const Button({
    super.key,
    this.call,
    required this.title,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: call,
      child: isLoading
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
