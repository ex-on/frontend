import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/transformers.dart';

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

class InputFieldDisplay extends StatelessWidget {
  final String labelText;
  final String inputText;
  final void Function() onPressed;
  final bool isOpen;
  final Widget inputWidget;
  const InputFieldDisplay({
    Key? key,
    required this.labelText,
    required this.inputText,
    required this.onPressed,
    required this.isOpen,
    required this.inputWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: isOpen ? null : 46,
      decoration: BoxDecoration(
        color: textFieldFillColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onPressed,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 15, right: 10, bottom: 15),
                    child: Text(
                      labelText,
                      style: const TextStyle(
                        color: deepGrayColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  inputText == ''
                      ? const SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            inputText,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            isOpen
                ? inputWidget
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  final Function(DateTime) onBirthDateChanged;
  const DatePicker({
    Key? key,
    required this.onBirthDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310,
      height: 300,
      child: CupertinoDatePicker(
        onDateTimeChanged: onBirthDateChanged,
        initialDateTime: DateTime.now(),
        minimumYear: 1900,
        maximumDate: DateTime.now(),
        maximumYear: DateTime.now().year,
        mode: CupertinoDatePickerMode.date,
      ),
    );
  }
}

class GenderPicker extends StatelessWidget {
  final void Function(Gender?) onChanged;
  final Gender? selectedValue;
  const GenderPicker({
    Key? key,
    required this.onChanged,
    required this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310,
      height: 120,
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text(
              '남성',
              style: TextStyle(fontSize: 15),
            ),
            leading: Radio<Gender?>(
              value: Gender.male,
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
          ),
          ListTile(
            title: const Text(
              '여성',
              style: TextStyle(fontSize: 15),
            ),
            leading: Radio<Gender?>(
              value: Gender.female,
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
