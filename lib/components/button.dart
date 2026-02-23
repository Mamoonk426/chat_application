import 'dart:ffi';

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String title;
  Void Function()? call;
  Button({super.key, this.call, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text(title.toString()));
  }
}
