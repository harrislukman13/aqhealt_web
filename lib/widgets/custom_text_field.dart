import 'package:flutter/material.dart';
import 'package:aqhealth_web/constants/color.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {this.hintText,
      this.controller,
      this.focusNode,
      this.isObscured = false,
      this.validator,
      this.isReadOnly = false,
      Key? key})
      : super(key: key);

  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isObscured;
  final bool isReadOnly;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      focusNode: focusNode,
      obscureText: isObscured,
      validator: validator,
      style: TextStyle(
        decoration: TextDecoration.none,
        color: primary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: hintText,
        hintStyle: TextStyle(color: primary),
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(
            color: primary,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(
            color: primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
