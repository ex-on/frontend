import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
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
              splashRadius: 20,
            ),
            elevation: 0,
            backgroundColor: color,
          )
        : AppBar(
            leading: IconButton(
              splashRadius: 20,
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
  final Color? color;
  const ProfileHeader(
      {Key? key, required this.onPressed, this.color = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.menu_rounded, color: Colors.black, size: 30),
          onPressed: onPressed,
        ),
      ],
      elevation: 0,
      backgroundColor: color,
    );
  }
}

class SearchHeader extends StatelessWidget {
  final Function() onPressed;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final TextEditingController searchController;
  const SearchHeader({
    Key? key,
    required this.onPressed,
    required this.searchController,
    this.backgroundColor = Colors.transparent,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.search_rounded,
              color: darkPrimaryColor, size: 30),
          onPressed: onPressed,
        ),
      ],
      title: InputTextField(
        label: '',
        controller: searchController,
        autofocus: false,
        backgroundColor: Colors.transparent,
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: backgroundColor,
      bottom: bottom,
    );
  }
}
