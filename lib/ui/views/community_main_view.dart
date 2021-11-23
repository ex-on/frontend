import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityMainView extends GetView<CommunityController> {
  const CommunityMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color _searchIconColor = darkPrimaryColor;
    const String _postCategoryLabelText = '주제별 게시판';
    const String _expandPostViewButtonText = '더보기 >';

    void _onSearchPressed() {}

    void _onCategoryButtonPressed(int index) {
      controller.updatePostCategory(index);
    }

    void _onExpandPostViewPressed() {}

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
                      GetBuilder<CommunityController>(builder: (_) {
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
                                  // shape: CircleBorder(),
                                  border: Border.all(
                                  width: 2,
                                  color: _.postCategory == index
                                      ? lightBrightPrimaryColor
                                      : Colors.transparent,
                                ),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: Color(0xffF3F4F6),
                                  radius: 28.5,
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
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<CommunityController>(
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            (postCategoryIntToStr[_.postCategory] ?? '') +
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
                Expanded(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SizedBox(height: 70);
                      },
                      separatorBuilder: (context, index) => const Divider(
                            color: lightGrayColor,
                            thickness: 0.5,
                          ),
                      itemCount: 8),
                )
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
