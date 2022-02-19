import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeNavigationBar extends StatelessWidget {
  final double bottomPadding;
  final double height;
  final int currentIndex;
  final void Function(int) onIconTap;
  const HomeNavigationBar({
    Key? key,
    required this.bottomPadding,
    required this.height,
    required this.currentIndex,
    required this.onIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = HomeController.to.theme == ColorTheme.day
        ? brightPrimaryColor
        : darkSecondaryColor;

    Widget _getNavigationBarItem(int index) {
      late Widget icon;
      late String text;

      switch (index) {
        case 0:
          icon = RankIcon(color: currentIndex == index ? primaryColor : null);
          text = '랭킹';
          break;
        case 1:
          icon =
              CommunityIcon(color: currentIndex == index ? primaryColor : null);
          text = '커뮤니티';
          break;
        case 2:
          icon = HomeIcon(color: currentIndex == index ? primaryColor : null);
          text = '홈';
          break;
        case 3:
          icon = StatIcon(color: currentIndex == index ? primaryColor : null);
          text = '통계';
          break;
        case 4:
          icon =
              ProfileIcon(color: currentIndex == index ? primaryColor : null);
          text = '프로필';
          break;
      }
      return SizedBox(
        width: (context.width - 20) / 5,
        // width: 60,
        height: 60,
        child: IconButton(
          splashRadius: 45,
          padding: EdgeInsets.zero,
          onPressed: () => onIconTap(index),
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  text,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 12,
                    color: clearBlackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
        ],
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(bottom: bottomPadding),
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          // padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
              (index) => _getNavigationBarItem(index),
            ),
          ),
        ),
      ),
    );
  }
}
