import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final dynamic Function() onPressed;
  final Color? color;
  final String? title;

  const Header({
    Key? key,
    required this.onPressed,
    this.color = Colors.transparent,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return title == null
        ? AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: onPressed,
            ),
            elevation: 0,
            backgroundColor: color,
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
            backgroundColor: color,
          );
  }
}

class ProfileHeader extends StatelessWidget {
  final dynamic Function() onPressed;
  final String profileName;
  const ProfileHeader(
      {Key? key, required this.onPressed, required this.profileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        profileName,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.black, size: 30),
          onPressed: onPressed,
        ),
      ],
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
