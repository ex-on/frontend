import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElevatedRouteButton extends StatelessWidget {
  final String buttonText;
  dynamic Function()? onPressed;
  final Color backgroundColor;

  ElevatedRouteButton({
    Key? key,
    required this.buttonText,
    required dynamic Function() this.onPressed,
    required this.backgroundColor,
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
      onPressed: onPressed,
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

class ElevatedActionButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function()? onPressed;
  const ElevatedActionButton({
    Key? key,
    required this.buttonText,
    required dynamic Function() this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledElevatedActionButtonColor;
          }
          return elevatedActionButtonColor; // Use the component's default.
        },
      ),
      minimumSize: MaterialStateProperty.all(const Size(250, 50)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 16,
      )),
      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      )),
    );

    return ElevatedButton(
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
      style: style,
    );
  }
}

class AddExcerciseButton extends StatelessWidget {
  final dynamic Function()? onPressed;
  const AddExcerciseButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _buttonText = '운동 추가하기';

    final ButtonStyle _style = OutlinedButton.styleFrom(
      fixedSize: const Size(165, 45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      side: const BorderSide(color: Color(0xffffffff), width: 0),
      padding: const EdgeInsets.all(5),
    );

    const Gradient _gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topRight,
      colors: [Color(0xff7896FF), Color(0xff1A49EE)],
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: _gradient,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: OutlinedButton(
            style: _style,
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 3.0),
                  child: Icon(
                    Icons.add,
                    size: 14,
                    color: deepPrimaryColor,
                  ),
                ),
                Text(_buttonText,
                    style: TextStyle(
                      fontSize: 14,
                      color: deepPrimaryColor,
                    ))
              ],
            )),
      ),
    );
  }
}
