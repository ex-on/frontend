import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/core/controllers/profile_controller.dart';
import 'package:exon_app/ui/views/community_main_view.dart';
import 'package:exon_app/ui/views/profile_view.dart';
import 'package:exon_app/ui/views/home_view.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';

import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/ui/widgets/common/home_navigation_bar.dart';
import 'package:get/get.dart';

class HomeNavigationView extends StatelessWidget {
  HomeNavigationView({Key? key}) : super(key: key);
  final List<Widget> _pages = [
    LoadingIndicator(),
    const CommunityMainView(),
    HomeView(),
    LoadingIndicator(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    Get.put<HomeController>(HomeController());
    Get.put<CommunityController>(CommunityController());
    Get.put<ProfileController>(ProfileController());
    return GetBuilder<HomeNavigationController>(
      init: HomeNavigationController(),
      builder: (_) {
        return Scaffold(
          extendBody: true,
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
