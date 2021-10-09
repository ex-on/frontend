import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElevatedActionButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final Color backgroundColor;
  // final Color textColor;

  const ElevatedActionButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.backgroundColor,
    // required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      primary: backgroundColor,
      minimumSize: const Size(250, 50),
      textStyle: const TextStyle(
        fontSize: 16,
      ),
      side: backgroundColor == Colors.white
          ? const BorderSide(color: Color(0xff999999), width: 1.0)
          : BorderSide.none,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    return ElevatedButton(
      child: Text(
        buttonText,
        style: TextStyle(
          color: (int.parse(backgroundColor.toString().substring(10, 16),
                      radix: 16) <
                  int.parse('800000', radix: 16))
              ? Colors.white
              : Colors.black,
        ),
      ),
      onPressed: onPressed(),
      style: style,
    );
  }
}

class TextActionButton extends StatelessWidget {
  final String buttonText;
  final String route;
  final double fontSize;

  const TextActionButton({
    Key? key,
    required this.buttonText,
    required this.route,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: const EdgeInsets.all(5),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return TextButton(
      onPressed: () => Get.toNamed(route),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
      style: style,
    );
  }
}
