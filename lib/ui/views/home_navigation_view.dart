import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/views/community_main_view.dart';
import 'package:exon_app/ui/pages/profile_page.dart';
import 'package:exon_app/ui/views/home_view.dart';
import 'package:flutter/material.dart';

import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/ui/widgets/common/home_navigation_bar.dart';
import 'package:get/get.dart';

class HomeNavigationView extends StatelessWidget {
  HomeNavigationView({Key? key}) : super(key: key);
  final List<Widget> _pages = [
    HomeView(),
    CommunityMainView(),
    HomeView(),
    HomeView(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    Get.put<HomeController>(HomeController());
    Get.put<CommunityController>(CommunityController());
    return GetBuilder<HomeNavigationController>(
      init: HomeNavigationController(),
      builder: (_) {
        return Scaffold(
          backgroundColor: mainBackgroundColor,
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: _pages[_.currentIndex],
          ),
          bottomNavigationBar: HomeNavigationBar(
            currentIndex: _.currentIndex,
            onIconTap: _.onIconTap,
          ),
        );
      },
    );
  }
}
