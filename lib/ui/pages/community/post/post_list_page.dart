import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:exon_app/ui/widgets/community/floating_write_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<CommunityController>(CommunityController());

    controller.postListStartIndex.listen((val) {
      controller.postListPageCallback(val);
    });

    void _onBackPressed() {
      controller.resetContent();
      Get.back();
      controller.postListCallback(controller.postCategory.value);
    }

    void _onWritePressed() {
      Get.toNamed('community/post/write');
    }

    void _onScrollUpPressed() {
      controller.postListScrollController.animateTo(0,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    }

    return Scaffold(
      body: GetBuilder<CommunityController>(
        builder: (_) {
          return Column(
            children: [
              Header(
                onPressed: _onBackPressed,
                title: (postCategoryIntToStr[controller.postCategory.value] ??
                        '') +
                    ' 게시판',
              ),
              Expanded(
                child: GetBuilder<CommunityController>(
                  builder: (_) {
                    if (_.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: brightPrimaryColor),
                      );
                    } else {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          NotificationListener<OverscrollIndicatorNotification>(
                            onNotification:
                                (OverscrollIndicatorNotification overscroll) {
                              overscroll.disallowGlow();
                              return true;
                            },
                            child: ListView.separated(
                              controller: _.postListScrollController,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                if (index == _.postContentList.length) {
                                  return const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: CircularProgressIndicator(
                                          color: brightPrimaryColor),
                                    ),
                                  );
                                }
                                return PostContentPreviewBuilder(
                                    data: _.postContentList[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: lightGrayColor,
                                thickness: 0.5,
                                height: 0.5,
                              ),
                              itemCount: _.postContentList.length +
                                  (_.listPageLoading ? 1 : 0),
                            ),
                          ),
                          controller.postCategory.value != 0
                              ? Positioned(
                                  child: FloatingWriteButton(
                                    onPressed: _onWritePressed,
                                  ),
                                  bottom:
                                      // 35 + context.mediaQueryPadding.bottom + 88,
                                      50,
                                  right: 35,
                                )
                              : const SizedBox.shrink(),
                          Positioned(
                            bottom: 50,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linearToEaseOut,
                                  alignment: Alignment.center,
                                  transformAlignment: Alignment.center,
                                  width: _.showScrollToTopButton ? 40 : 0,
                                  height: _.showScrollToTopButton ? 40 : 0,
                                  child: FloatingIconButton(
                                    heroTag: 'scroll_up',
                                    backgroundColor: Colors.white,
                                    onPressed: _onScrollUpPressed,
                                    icon: const ScrollUpIcon(
                                        color: lightGrayColor),
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
