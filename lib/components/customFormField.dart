import 'package:flutter/material.dart';

class Customformfield extends StatelessWidget {
  String title;
  Icon? prefix;
  Icon? suffix;
  IconButton? suffixImage;
  String? errortext;
  Function(String? value)? onChanged;
  TextEditingController controller;
  Customformfield({
    super.key,
    this.onChanged,
    this.suffixImage,
    required this.title,
    this.prefix,
    this.suffix,
    required this.controller,
    this.errortext,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        errorText: errortext,
        suffixIcon: suffixImage,
        prefixIcon: prefix,
        hint: Text(title.toString()),
      ),
    );
  }
}
