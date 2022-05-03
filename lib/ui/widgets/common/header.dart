import 'package:badges/badges.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  final dynamic Function() onPressed;
  final Color? color;
  final String? title;
  final List<Widget>? actions;
  final Widget? icon;

  const Header({
    Key? key,
    required this.onPressed,
    this.color = Colors.transparent,
    this.title,
    this.actions,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return title == null
        ? AppBar(
            leading: IconButton(
              icon: icon ??
                  const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: onPressed,
              splashRadius: 20,
            ),
            elevation: 0,
            backgroundColor: color,
            actions: actions,
          )
        : AppBar(
            leading: IconButton(
              splashRadius: 20,
              icon: icon ??
                  const Icon(Icons.arrow_back_rounded, color: Colors.black),
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
            actions: actions,
          );
  }
}

class TabBarHeader extends StatelessWidget {
  final dynamic Function() onPressed;
  final Color? color;
  final String? title;
  final List<Widget>? actions;
  final Widget? icon;
  final PreferredSizeWidget bottom;

  const TabBarHeader({
    Key? key,
    required this.onPressed,
    required this.bottom,
    this.color = Colors.transparent,
    this.title,
    this.actions,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return title == null
        ? AppBar(
            leading: IconButton(
              icon: icon ??
                  const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: onPressed,
              splashRadius: 20,
            ),
            elevation: 0,
            backgroundColor: color,
            actions: actions,
            bottom: bottom,
            shape: const Border(
              bottom: BorderSide(color: lightGrayColor, width: 0.5),
            ),
          )
        : AppBar(
            leading: IconButton(
              splashRadius: 20,
              icon: icon ??
                  const Icon(Icons.arrow_back_rounded, color: Colors.black),
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
            actions: actions,
            bottom: bottom,
            shape: const Border(
              bottom: BorderSide(color: lightGrayColor, width: 0.5),
            ),
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

class SearchHeader extends StatelessWidget with PreferredSizeWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function() onCancelPressed;
  final void Function(String) onFieldSubmitted;

  @override
  final Size preferredSize;

  SearchHeader({
    Key? key,
    required this.controller,
    required this.onCancelPressed,
    required this.onFieldSubmitted,
    this.focusNode,
  })  : preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const Border(
        bottom: BorderSide(color: lightGrayColor, width: 0.5),
      ),
      leading: const Padding(
        padding: EdgeInsets.only(left: 6),
        child: Icon(
          Icons.search_rounded,
          color: brightPrimaryColor,
          size: 30,
        ),
      ),
      title: SizedBox(
        height: 56,
        child: SearchInputField(
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6, top: 10, bottom: 10),
          child: TextActionButton(
            isUnderlined: false,
            textColor: deepGrayColor,
            buttonText: '취소',
            onPressed: onCancelPressed,
          ),
        ),
      ],
    );
  }
}

class CommunityHeader extends StatelessWidget {
  final Widget leading;
  final Function() onSearchPressed;
  final bool displaySearch;

  const CommunityHeader({
    Key? key,
    required this.leading,
    required this.onSearchPressed,
    this.displaySearch = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: context.width,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: lightGrayColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 56,
              child: leading,
            ),
            displaySearch
                ? Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      splashRadius: 20,
                      icon: const Icon(
                        Icons.search_rounded,
                        color: darkPrimaryColor,
                        size: 30,
                      ),
                      onPressed: onSearchPressed,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class AnimatedSearchHeader extends StatefulWidget {
  final Widget? leading;
  final Color? backgroundColor;
  final TextEditingController searchController;
  final Function() onSearchPressed;
  final Function() onCancelPressed;
  final FocusNode? focusNode;
  final void Function(String) onFieldSubmitted;
  const AnimatedSearchHeader({
    Key? key,
    required this.searchController,
    required this.onSearchPressed,
    required this.onCancelPressed,
    required this.onFieldSubmitted,
    this.leading,
    this.focusNode,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  State<AnimatedSearchHeader> createState() => _AnimatedSearchHeaderState();
}

class _AnimatedSearchHeaderState extends State<AnimatedSearchHeader> {
  bool searchOpen = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: context.width,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: lightGrayColor,
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            SizedBox(
              width: searchOpen ? 0 : null,
              height: 56,
              child: widget.leading,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              left: searchOpen ? 50 : context.width,
              child: SizedBox(
                width: 300,
                height: 56,
                child: SearchInputField(
                  controller: widget.searchController,
                  focusNode: widget.focusNode,
                  onFieldSubmitted: widget.onFieldSubmitted,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              right: searchOpen ? context.width - 50 : 10,
              child: Material(
                type: MaterialType.transparency,
                child: searchOpen
                    ? const Icon(
                        Icons.search_rounded,
                        color: brightPrimaryColor,
                        size: 30,
                      )
                    : IconButton(
                        splashRadius: 20,
                        icon: const Icon(
                          Icons.search_rounded,
                          color: darkPrimaryColor,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            searchOpen = !searchOpen;
                          });
                          widget.onSearchPressed();
                        },
                      ),
              ),
            ),
            searchOpen
                ? Positioned(
                    right: 10,
                    child: TextActionButton(
                      isUnderlined: false,
                      textColor: deepGrayColor,
                      buttonText: '취소',
                      onPressed: () {
                        setState(() {
                          searchOpen = !searchOpen;
                        });
                        widget.onCancelPressed();
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class StatsHeader extends StatelessWidget {
  final Function() onByPeriodPressed;
  final Function() onCumulativePressed;
  final String title;
  final int currentIndex;
  final PreferredSizeWidget? bottom;
  final Color backgroundColor;
  const StatsHeader({
    Key? key,
    required this.onByPeriodPressed,
    required this.onCumulativePressed,
    required this.title,
    required this.currentIndex,
    required this.bottom,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String calendarIcon = 'assets/icons/Calendar.svg';
    print(currentIndex);

    return AppBar(
      actions: [
        IconButton(
          splashRadius: 20,
          icon: StatIcon(
            width: 24,
            height: 24,
            color: currentIndex == 0 ? brightPrimaryColor : deepGrayColor,
          ),
          padding: EdgeInsets.zero,
          onPressed: onByPeriodPressed,
        ),
        IconButton(
          splashRadius: 20,
          icon: SvgPicture.asset(
            calendarIcon,
            width: 24,
            height: 24,
            color: currentIndex == 1 ? brightPrimaryColor : deepGrayColor,
          ),
          padding: EdgeInsets.zero,
          onPressed: onCumulativePressed,
        ),
        horizontalSpacer(10),
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

class CustomLeadingHeader extends StatelessWidget {
  final Widget leading;
  const CustomLeadingHeader({
    Key? key,
    required this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: context.width,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: lightGrayColor,
            ),
          ),
        ),
        child: leading,
      ),
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

class NotificationHeader extends StatelessWidget {
  final dynamic Function() onPressed;
  final int numNotifications;

  const NotificationHeader({
    Key? key,
    required this.onPressed,
    required this.numNotifications,
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
          text: '알림 ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: numNotifications.toString(),
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
      backgroundColor: Colors.transparent,
    );
  }
}
