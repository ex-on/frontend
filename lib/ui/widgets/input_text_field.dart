import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/constants/colors.dart';

class InputTextField extends StatelessWidget {
  final String label;

  const InputTextField({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 45,
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: textFieldFillColor,
          label: Text(label),
        ),
      ),
    );
  }
}
