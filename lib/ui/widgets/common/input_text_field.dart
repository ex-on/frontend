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
