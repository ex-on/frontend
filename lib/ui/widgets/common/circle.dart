import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final Color? borderColor;
  final Widget? child;
  const Circle({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.borderColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: child,
      ),
    );
  }
}
