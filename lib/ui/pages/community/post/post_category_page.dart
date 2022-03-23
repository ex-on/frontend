import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostCategoryPage extends GetView<CommunityController> {
  const PostCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.postContentList.isEmpty) {
        controller.postCategoryRefreshController.requestRefresh();
      }
    });

    const String _expandPostViewButtonText = '더보기 >';

    void _onCategoryButtonPressed(int index) {
      controller.postCategory.value = index;
      controller.updatePostType(index);
      controller.update();
    }

    void _onExpandPostViewPressed() {
      controller.setPostListInitialLoad(true);
      Get.toNamed('/community/post/list');
    }

    return Column(
      children: [
        Container(
          color: Colors.white,
          width: context.width,
          height: 130,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: 3,
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
                                    backgroundColor: mainBackgroundColor,
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
        SizedBox(
          height: 15,
          width: context.width,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: mainBackgroundColor,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(0, 15, 0, context.mediaQueryPadding.bottom),
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
                GetBuilder<CommunityController>(
                  builder: (_) {
                    return Expanded(
                      child: SmartRefresher(
                        controller: _.postCategoryRefreshController,
                        onRefresh: _.onPostCategoryRefresh,
                        header: const CustomRefreshHeader(),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return PostContentPreviewBuilder(
                                displayType: _.postCategory.value == 0,
                                data: _.postContentList[index]);
                          },
                          separatorBuilder: (context, index) => const Divider(
                            color: lightGrayColor,
                            thickness: 0.5,
                            height: 0.5,
                          ),
                          itemCount: _.loading ? 0 : _.postContentList.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
