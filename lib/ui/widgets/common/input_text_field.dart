import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/constants/colors.dart';

class InputTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double? height;
  final double? borderRadius;

  const InputTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      height: height ?? 45,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 20)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: textFieldFillColor,
          label: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumberInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLength;
  const NumberInputField({
    Key? key,
    required this.controller,
    this.hintText,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 50,
      child: TextField(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.bottom,
        scrollPadding: EdgeInsets.zero,
        keyboardType: TextInputType.number,
        controller: controller,
        style: const TextStyle(
          fontSize: 22,
        ),
        maxLength: maxLength,
        decoration: InputDecoration(
          counter: const SizedBox.shrink(),
          contentPadding: const EdgeInsets.only(bottom: 12),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 22,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Color(0xff777777),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
