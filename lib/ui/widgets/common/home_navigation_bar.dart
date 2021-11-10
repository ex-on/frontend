import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const String _chartIcon = 'assets/icons/chart.svg';
const String _deskIcon = 'assets/icons/desk.svg';
const String _homeIcon = 'assets/icons/home.svg';
const String _starIcon = 'assets/icons/star.svg';
const String _userIcon = 'assets/icons/userCircle.svg';
const String _statViewLabel = '';
const String _communityViewLabel = '';
const String _homeViewLabel = '';
const String _rankViewLabel = '';
const String _profileViewLabel = '';
// const String _statViewLabel = '통계';
// const String _communityViewLabel = '게시판';
// const String _homeViewLabel = '홈';
// const String _rankViewLabel = '랭킹';
// const String _profileViewLabel = '프로필';
const Color _bottomNavigationBarColor = Color(0xffFEFEFE);
const Size _svgSize = Size(42, 42);

class HomeNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onIconTap;
  const HomeNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = HomeController.to.theme == ColorTheme.day
        ? brightPrimaryColor
        : darkSecondaryColor;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _chartIcon,
              color: currentIndex == 0 ? primaryColor : null,
            ),
            label: _statViewLabel,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _deskIcon,
              color: currentIndex == 1 ? primaryColor : null,
            ),
            label: _communityViewLabel,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _homeIcon,
              color: currentIndex == 2 ? primaryColor : null,
            ),
            label: _homeViewLabel,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _starIcon,
              color: currentIndex == 3 ? primaryColor : null,
            ),
            label: _rankViewLabel,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _userIcon,
              color: currentIndex == 4 ? primaryColor : null,
            ),
            label: _profileViewLabel,
          ),
        ],
        onTap: onIconTap,
        currentIndex: currentIndex,
        backgroundColor: _bottomNavigationBarColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
