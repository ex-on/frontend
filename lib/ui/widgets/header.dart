import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  dynamic Function()? onPressed;

  Header({Key? key, required dynamic Function() this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        onPressed: onPressed,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
