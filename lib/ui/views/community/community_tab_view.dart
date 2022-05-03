import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/core/controllers/community_search_controller.dart';
import 'package:exon_app/ui/pages/community/post/post_category_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_category_page.dart';
import 'package:exon_app/ui/pages/community/saved/saved_post_qnas_page.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityTabView extends GetView<CommunityController> {
  const CommunityTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onSearchPressed() {
      print(controller.communityMainTabController.index);
      late int _searchCategory;
      switch (controller.communityMainTabController.index) {
        case 0:
          _searchCategory = 0;
          break;
        case 1:
          _searchCategory = 4;
          break;
        default:
          _searchCategory = 0;
          break;
      }
      CommunitySearchController.to.updateSearchCategory(_searchCategory);
      Get.toNamed('/community/search');
    }

    Widget _tabBar = TabBar(
      controller: controller.communityMainTabController,
      isScrollable: true,
      indicatorWeight: 3.5,
      indicatorColor: brightPrimaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: brightPrimaryColor,
      unselectedLabelColor: lightGrayColor,
      labelStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      tabs: const <Widget>[
        Tab(child: Text('게시판')),
        Tab(child: Text('Q&A')),
        Tab(child: Text('보관함')),
      ],
    );

    return Column(
      children: [
        GetBuilder<CommunityController>(builder: (_) {
          bool _displaySearch = true;
          if (_.communityMainTabController.index == 2) {
            _displaySearch = false;
          }
          return CommunityHeader(
            displaySearch: _displaySearch,
            leading: _tabBar,
            onSearchPressed: _onSearchPressed,
          );
        }),
        Expanded(
          child: TabBarView(
            physics: const ClampingScrollPhysics(),
            controller: controller.communityMainTabController,
            children: const <Widget>[
              PostCategoryPage(),
              QnaCategoryPage(),
              SavedPostQnasPage(),
            ],
          ),
        ),
      ],
    );
  }
}
