import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  dynamic Function()? onPressed;
  final String? title;

  Header({Key? key, required dynamic Function() this.onPressed, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return title == null
        ? AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: onPressed,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          )
        : AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: onPressed,
            ),
            title: Text(
              title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          );
  }
}
