import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';

class CommunityMainPage extends GetView<CommunityController> {
  const CommunityMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color _searchIconColor = darkPrimaryColor;
    const String _postCategoryLabelText = '주제별 게시판';
    const String _expandPostViewButtonText = '더보기 >';

    controller.postCategory.listen((val) {
      controller.callback(val);
    });

    void _onSearchPressed() {}

    void _onCategoryButtonPressed(int index) {
      controller.postCategory.value = index;
      controller.update();
    }

    void _onExpandPostViewPressed() {
      Get.toNamed('/community/post_list');
      controller.listPageCallback(controller.listPage.value);
    }

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

    Widget _postView = Column(
      children: [
        Container(
          color: Colors.white,
          width: context.width,
          height: 170,
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  _postCategoryLabelText,
                  style: TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 18,
                    letterSpacing: -2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: 5,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => horizontalSpacer(10),
                  itemBuilder: (BuildContext context, int index) =>
                      GetX<CommunityController>(builder: (_) {
                    return Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () => _onCategoryButtonPressed(index),
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 3,
                                    color: _.postCategory.value == index
                                        ? lightBrightPrimaryColor
                                        : Colors.transparent,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(3),
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffF3F4F6),
                                    radius: 28.5,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              postCategoryIntToStr[index] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: darkPrimaryColor,
                                letterSpacing: -2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        verticalSpacer(20),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<CommunityController>(
                        builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              (postCategoryIntToStr[_.postCategory.value] ??
                                      '') +
                                  ' 게시판',
                              style: const TextStyle(
                                color: darkPrimaryColor,
                                fontSize: 18,
                                letterSpacing: -2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      TextActionButton(
                        buttonText: _expandPostViewButtonText,
                        onPressed: _onExpandPostViewPressed,
                        isUnderlined: false,
                        textColor: deepGrayColor,
                      ),
                    ],
                  ),
                ),
                verticalSpacer(10),
                GetBuilder<CommunityController>(builder: (_) {
                  if (_.loading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                            color: brightPrimaryColor),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ContentPreviewBuilder(
                              postType: 0, index: index);
                        },
                        separatorBuilder: (context, index) => const Divider(
                          color: lightGrayColor,
                          thickness: 0.5,
                          height: 0.5,
                        ),
                        itemCount: _.contentList.length,
                      ),
                    );
                  }
                })
              ],
            ),
          ),
        ),
      ],
    );

    Widget _tabBarView = TabBarView(
      physics: const BouncingScrollPhysics(),
      controller: controller.communityMainTabController,
      children: <Widget>[
        _postView,
        Center(
          child: Text("It's rainy here"),
        ),
        Center(
          child: Text("It's sunny here"),
        ),
      ],
    );

    return Column(
      children: [
        SizedBox(
          child: _communitySearchBar,
          height: 100,
        ),
        Expanded(child: _tabBarView),
      ],
    );
  }
}
