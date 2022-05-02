import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:exon_app/ui/widgets/community/loading_blocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
        controller.postCategoryListCallback(controller.postCategory.value);
        // controller.postCategoryRefreshController.requestRefresh();
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

    void _onWriteFreePostPressed() {
      controller.updatePostType(1);
      controller.resetPostWrite();
      Get.toNamed('community/post/write');
    }

    void _onWriteInfoPostPressed() {
      controller.updatePostType(2);
      controller.resetPostWrite();
      Get.toNamed('community/post/write');
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
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: CircleAvatar(
                                    backgroundColor: mainBackgroundColor,
                                    radius: 28.5,
                                    child: () {
                                      switch (index) {
                                        case 0:
                                          return HotIcon();
                                        case 1:
                                          return EditIcon();
                                        case 2:
                                          return InfoIcon();
                                        default:
                                          break;
                                      }
                                    }(),
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
            child: Stack(
              children: [
                Column(
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
                            child: _.loading
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: LoadingCommentBlock(),
                                  )
                                : ListView.separated(
                                    physics: const ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return PostContentPreviewBuilder(
                                          displayType:
                                              _.postCategory.value == 0,
                                          data: _.postContentList[index]);
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      color: lightGrayColor,
                                      thickness: 0.5,
                                      height: 0.5,
                                    ),
                                    itemCount: _.loading
                                        ? 0
                                        : _.postContentList.length,
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Positioned(
                  bottom: 35,
                  right: 35,
                  child: SpeedDial(
                    buttonSize: const Size(70, 70),
                    backgroundColor: brightPrimaryColor,
                    activeBackgroundColor: Colors.white,
                    overlayColor: mainBackgroundColor,
                    iconTheme: const IconThemeData(
                      size: 35,
                    ),
                    animatedIconTheme: const IconThemeData(
                      size: 25,
                    ),
                    icon: Icons.edit_rounded,
                    activeIcon: Icons.close_rounded,
                    activeForegroundColor: brightPrimaryColor,
                    foregroundColor: Colors.white,
                    spaceBetweenChildren: 5,
                    spacing: 5,
                    children: [
                      SpeedDialChild(
                        labelWidget: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Text(
                            '정보글 쓰기',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        labelBackgroundColor: mainBackgroundColor,
                        elevation: 5,
                        labelShadow: [],
                        child: const InfoIcon(),
                        onTap: _onWriteInfoPostPressed,
                      ),
                      SpeedDialChild(
                        labelWidget: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Text(
                            '자유글 쓰기',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        labelBackgroundColor: mainBackgroundColor,
                        elevation: 5,
                        labelShadow: [],
                        child: const EditIcon(),
                        onTap: _onWriteFreePostPressed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
