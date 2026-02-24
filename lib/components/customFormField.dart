import 'package:flutter/material.dart';

class Customformfield extends StatelessWidget {
  String title;
  Icon? prefix;
  Icon? suffix;
  TextEditingController controller;
  Customformfield({
    super.key,
    required this.title,
    this.prefix,
    this.suffix,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefix,
        suffix: suffix,
        hint: Text(title.toString()),
      ),
    );
  }
}
