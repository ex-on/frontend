import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/pages/community/saved/saved_user_commented_posts_list_page.dart';
import 'package:exon_app/ui/pages/community/saved/saved_user_posts_list_page.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostActivityTabView extends GetView<CommunityController> {
  const PostActivityTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '게시판 활동';

    void _onBackPressed() {
      Get.back();
    }

    PreferredSizeWidget _tabBar = PreferredSize(
      preferredSize: Size.fromWidth(context.width),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: TabBar(
            controller: controller.postActivityListTabController,
            isScrollable: true,
            indicatorWeight: 2,
            indicatorColor: brightPrimaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: brightPrimaryColor,
            unselectedLabelColor: deepGrayColor,
            tabs: const <Widget>[
              Tab(child: Text('내가 쓴 글')),
              Tab(child: Text('댓글 단 글')),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56 + 46 + 1.5),
        child: TabBarHeader(
          onPressed: _onBackPressed,
          title: _titleText,
          bottom: _tabBar,
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          physics: const ClampingScrollPhysics(),
          controller: controller.postActivityListTabController,
          children: const <Widget>[
            SavedUserPostsListPage(),
            SavedUserCommentedPostsListPage(),
          ],
        ),
      ),
    );
  }
}
