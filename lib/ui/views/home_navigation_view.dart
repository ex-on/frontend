import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/core/controllers/profile_controller.dart';
import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/ui/pages/home/main_home_page.dart';
import 'package:exon_app/ui/views/community/community_tab_view.dart';
import 'package:exon_app/ui/views/profile_view.dart';
import 'package:exon_app/ui/views/rank_tab_view.dart';
import 'package:exon_app/ui/views/stats/stats_view.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/ui/widgets/common/home_navigation_bar.dart';
import 'package:get/get.dart';

class HomeNavigationView extends StatelessWidget {
  HomeNavigationView({Key? key}) : super(key: key);

  final List<Widget> _pages = [
    const RankTabView(),
    const CommunityTabView(),
    const MainHomePage(),
    const StatsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    Get.put<RankController>(RankController());
    Get.put<CommunityController>(CommunityController());
    Get.put<HomeController>(HomeController());
    Get.put<StatsController>(StatsController());
    Get.put<ProfileController>(ProfileController());
    return GetBuilder<HomeNavigationController>(
      builder: (_) {
        return Scaffold(
          extendBody: true,
          backgroundColor: _.currentIndex == 2 || _.currentIndex == 4
              ? mainBackgroundColor
              : Colors.white,
          body: SafeArea(
            bottom: false,
            maintainBottomViewPadding: false,
            child: _pages[_.currentIndex],
          ),
          bottomNavigationBar: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: HomeNavigationBar(
              currentIndex: _.currentIndex,
              onIconTap: _.onIconTap,
              height: 60 + context.mediaQueryPadding.bottom,
              bottomPadding: context.mediaQueryPadding.bottom,
            ),
          ),
        );
      },
    );
  }
}
