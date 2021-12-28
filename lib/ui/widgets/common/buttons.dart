import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElevatedRouteButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function()? onPressed;
  final Color backgroundColor;

  const ElevatedRouteButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backgroundColor),
      overlayColor: backgroundColor == Colors.white
          ? MaterialStateProperty.all(Colors.grey[200])
          : null,
      minimumSize: MaterialStateProperty.all(const Size(250, 50)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 16,
      )),
      side: MaterialStateProperty.all(
        backgroundColor == Colors.white
            ? const BorderSide(color: Color(0xff999999), width: 1.0)
            : BorderSide.none,
      ),
      shape: MaterialStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      elevation: MaterialStateProperty.all(0),
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
  final void Function() onPressed;
  final double? fontSize;
  final Color? textColor;
  final bool? isUnderlined;
  final Widget? leading;
  final double? width;
  final double? height;
  final FontWeight? fontWeight;

  const TextActionButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.isUnderlined = true,
    this.leading,
    this.width,
    this.height,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: const EdgeInsets.all(5),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        child: leading == null
            ? Text(
                buttonText,
                style: TextStyle(
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                  color: textColor,
                  decoration: isUnderlined!
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              )
            : Row(
                children: [
                  leading!,
                  Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: textColor,
                      decoration: isUnderlined!
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
        style: style,
      ),
    );
  }
}

class ElevatedActionButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function()? onPressed;
  final bool? activated;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  const ElevatedActionButton({
    Key? key,
    required this.buttonText,
    required dynamic Function() this.onPressed,
    this.activated,
    this.height,
    this.width,
    this.backgroundColor = brightPrimaryColor,
    this.textStyle = const TextStyle(color: Colors.white),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return deepGrayColor;
          }
          return backgroundColor!; // Use the component's default.
        },
      ),
      minimumSize: MaterialStateProperty.all(const Size(250, 50)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 16,
      )),
      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      )),
      elevation: MaterialStateProperty.all(0),
    );

    return ElevatedButton(
      child: Text(buttonText, style: textStyle),
      onPressed: activated == null || activated! ? onPressed : null,
      style: style,
    );
  }
}


// class AddExcerciseButton extends StatelessWidget {
//   final dynamic Function()? onPressed;
//   const AddExcerciseButton({
//     Key? key,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     const _buttonText = '운동 추가하기 >';

//     final ButtonStyle _style = OutlinedButton.styleFrom(
//       fixedSize: const Size(165, 45),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(30)),
//       ),
//       side: const BorderSide(color: Color(0xffffffff), width: 0),
//       padding: const EdgeInsets.all(5),
//     );

//     const Gradient _gradient = LinearGradient(
//       begin: Alignment.bottomCenter,
//       end: Alignment.topRight,
//       colors: [Color(0xff7896FF), Color(0xff1A49EE)],
//     );

//     return DecoratedBox(
//       decoration: const BoxDecoration(
//         gradient: _gradient,
//         borderRadius: BorderRadius.all(Radius.circular(30)),
//       ),
//       child: Container(
//         margin: const EdgeInsets.all(2),
//         padding: EdgeInsets.zero,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(30)),
//         ),
//         child: OutlinedButton(
//             style: _style,
//             onPressed: onPressed,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Padding(
//                   padding: EdgeInsets.only(right: 3.0),
//                   child: Icon(
//                     Icons.add,
//                     size: 14,
//                     color: brightPrimaryColor,
//                   ),
//                 ),
//                 Text(_buttonText,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: brightPrimaryColor,
//                     ))
//               ],
//             )),
//       ),
//     );
//   }
// }
