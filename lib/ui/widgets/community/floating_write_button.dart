import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';

class FloatingWriteButton extends StatelessWidget {
  final Function() onPressed;
  final double? height;
  final double? width;
  const FloatingWriteButton({
    Key? key,
    required this.onPressed,
    this.height = 70,
    this.width = 70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FittedBox(
        child: FloatingActionButton(
          heroTag: 'write',
          onPressed: onPressed,
          child: const Icon(
            Icons.edit_rounded, 
            color: Colors.white,
            size: 35,
          ),
          backgroundColor: brightPrimaryColor,
        ),
      ),
    );
  }
}
