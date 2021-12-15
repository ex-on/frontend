import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/pages/community/post_tab_page.dart';
import 'package:exon_app/ui/pages/community/saved_posts_page.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityTabView extends GetView<CommunityController> {
  const CommunityTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onSearchPressed() {}

    TabBar _tabBar = TabBar(
      controller: controller.communityMainTabController,
      indicatorColor: darkPrimaryColor,
      labelColor: darkPrimaryColor,
      tabs: const <Widget>[
        Tab(child: Text('게시판')),
        Tab(child: Text('Q&A')),
        Tab(child: Text('보관함')),
      ],
    );

    Widget _communitySearchBar = SearchHeader(
      onPressed: _onSearchPressed,
      backgroundColor: Colors.white,
      bottom: _tabBar,
      searchController: TextEditingController(),
    );

    return Column(
      children: [
        SizedBox(
          child: _communitySearchBar,
          height: 100,
        ),
        Expanded(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: controller.communityMainTabController,
            children: const <Widget>[
              PostTabPage(),
              Center(
                child: Text("It's rainy here"),
              ),
              SavedPostsPage(),
            ],
          ),
        ),
      ],
    );
  }
}
