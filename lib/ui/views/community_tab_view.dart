import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/pages/community/post/post_category_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_category_page.dart';
import 'package:exon_app/ui/pages/community/saved_post_qnas_page.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CommunityTabView extends GetView<CommunityController> {
  const CommunityTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _searchCharacter = 'assets/searchCharacter.svg';

    void _onSearchPressed() {
      controller.setSearchOpen(true);
      FocusScope.of(context).requestFocus(controller.searchFieldFocus);
    }

    void _onSearchCancelPressed() {
      controller.searchFieldFocus!.unfocus();
      controller.setSearchOpen(false);
    }

    Widget _tabBar = TabBar(
      controller: controller.communityMainTabController,
      isScrollable: true,
      indicator: BoxDecoration(),
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
        SearchHeader(
          backgroundColor: Colors.white,
          leading: _tabBar,
          searchController: TextEditingController(),
          onSearchPressed: _onSearchPressed,
          onCancelPressed: _onSearchCancelPressed,
          focusNode: controller.searchFieldFocus,
        ),
        Expanded(
          child: Stack(
            children: [
              TabBarView(
                physics: const BouncingScrollPhysics(),
                controller: controller.communityMainTabController,
                children: const <Widget>[
                  PostCategoryPage(),
                  QnaCategoryPage(),
                  SavedPostQnasPage(),
                ],
              ),
              GetBuilder<CommunityController>(builder: (_) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  left: _.searchOpen ? 0 : context.width,
                  child: Container(
                    // duration: const Duration(milliseconds: 300),
                    color: Colors.white,
                    height: _.searchOpen ? null : 0,
                    constraints: BoxConstraints(
                      maxHeight: context.height - 56,
                    ),
                    width: context.width,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        height: context.height - 56,
                        child: Column(
                          children: [
                            verticalSpacer(100),
                            SvgPicture.asset(_searchCharacter),
                            const Text(
                              '게시판의 글을 검색해보세요',
                              style: TextStyle(
                                color: deepGrayColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
