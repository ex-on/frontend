import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/pages/community/saved/saved_user_answered_qnas_list_page.dart';
import 'package:exon_app/ui/pages/community/saved/saved_user_qnas_list_page.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QnaActivityTabView extends GetView<CommunityController> {
  const QnaActivityTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '내 Q&A';

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
            controller: controller.bookmarkedListTabController,
            isScrollable: true,
            indicatorWeight: 2,
            indicatorColor: brightPrimaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: brightPrimaryColor,
            unselectedLabelColor: deepGrayColor,
            tabs: const <Widget>[
              Tab(child: Text('내 질문')),
              Tab(child: Text('내 답변')),
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
          controller: controller.bookmarkedListTabController,
          children: const <Widget>[
            SavedUserQnasListPage(),
            SavedUserAnsweredQnasListPage(),
          ],
        ),
      ),
    );
  }
}
