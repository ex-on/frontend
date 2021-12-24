import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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

class StatsHeader extends StatelessWidget {
  final Function() onCalendarPressed;
  final Function() onChartPressed;
  final String title;
  final int currentIndex;
  final PreferredSizeWidget bottom;
  final Color backgroundColor;
  const StatsHeader({
    Key? key,
    required this.onCalendarPressed,
    required this.onChartPressed,
    required this.title,
    required this.currentIndex,
    required this.bottom,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String calendarIcon = 'assets/icons/Calendar.svg';
    const String chartIcon = 'assets/icons/chart.svg';
    print(currentIndex);

    return AppBar(
      actions: [
        IconButton(
          splashRadius: 24,
          icon: SvgPicture.asset(
            chartIcon,
            width: 24,
            height: 24,
            color: currentIndex == 0 ? brightPrimaryColor : deepGrayColor,
          ),
          onPressed: onCalendarPressed,
        ),
        IconButton(
          splashRadius: 24,
          icon: SvgPicture.asset(
            calendarIcon,
            width: 24,
            height: 24,
            color: currentIndex == 1 ? brightPrimaryColor : deepGrayColor,
          ),
          onPressed: onChartPressed,
        ),
      ],
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -2,
          color: darkPrimaryColor,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: backgroundColor,
      bottom: bottom,
    );
  }
}

class CommentsHeader extends StatelessWidget {
  final dynamic Function() onPressed;
  final Color? color;
  final int? numComments;

  const CommentsHeader({
    Key? key,
    required this.onPressed,
    required this.numComments,
    this.color = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        splashRadius: 20,
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        onPressed: onPressed,
      ),
      title: Text.rich(
        TextSpan(
          text: '댓글 ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: (numComments ?? '-').toString(),
              style: const TextStyle(
                color: brightPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: color,
    );
  }
}
