import 'package:flutter/material.dart';

class Customformfield extends StatelessWidget {
  final String title;
  final Icon? prefix;
  final Icon? suffix;
  final IconButton? suffixImage;
  final String? errortext;
  final bool? isObscure;
  final Function(String? value)? onChanged;
  final TextEditingController controller;
  const Customformfield({
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
