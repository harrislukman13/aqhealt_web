import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:aqhealth_web/constants/color.dart';


Widget customTextFormField({
  required TextEditingController controller,
  required FocusNode focusNode,
  required String hintText,
  bool isObscured = false,
  Icon? prefixIcon,
  Function(String)? onChange,
  String? Function(String?)? validator,
}) =>
    TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isObscured,
      onChanged: onChange,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        isDense: true,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.sp),
          borderSide: BorderSide(
            color: primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.sp),
          borderSide: BorderSide(
            color: primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.sp),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
