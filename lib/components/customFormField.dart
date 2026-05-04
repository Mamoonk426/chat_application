import 'package:flutter/material.dart';

class Customformfield extends StatelessWidget {
  String title;
  Icon? prefix;
  Icon? suffix;
  IconButton? suffixImage;
  String? errortext;
  bool? isObscure;
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
    this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure ?? false,
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        errorText: errortext,
        suffixIcon: suffixImage,
        prefixIcon: prefix,
        hintText: title.toString(),
      ),
    );
  }
}
