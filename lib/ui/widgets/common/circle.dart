import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  const Circle({
    Key? key,
    this.width,
    this.height,
    this.color,
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
        ),
        child: child,
      ),
    );
  }
}
