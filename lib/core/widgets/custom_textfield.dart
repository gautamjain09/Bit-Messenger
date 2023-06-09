import 'package:bit_messenger/core/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final IconData prefixIcon;
  final bool isObscure;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.inputType,
    required this.prefixIcon,
    required this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 44,
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: isObscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: bottomBarColor,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              prefixIcon,
              color: greyColor,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}
