import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String title;
  Function()? call;
  Button({super.key, this.call, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: call, child: Text(title.toString()));
  }
}
