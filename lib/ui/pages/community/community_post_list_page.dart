import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:exon_app/ui/widgets/community/floating_write_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityPostListPage extends StatelessWidget {
  const CommunityPostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<CommunityController>(CommunityController());

    controller.postListPage.listen((val) {
      controller.postListPageCallback(val);
    });

    void _onBackPressed() {
      controller.resetContent();
      Get.back();
      controller.postListCallback(controller.postCategory.value);
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
                child: GetBuilder<CommunityController>(builder: (_) {
                  if (_.loading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: brightPrimaryColor),
                    );
                  } else {
                    return Stack(children: [
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
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: CircularProgressIndicator(
                                      color: brightPrimaryColor),
                                ),
                              );
                            }
                            return PostContentPreviewBuilder(data: _.postContentList[index]);
                          },
                          separatorBuilder: (context, index) => const Divider(
                            color: lightGrayColor,
                            thickness: 0.5,
                            height: 0.5,
                          ),
                          itemCount: _.postContentList.length +
                              (_.listPageLoading ? 1 : 0),
                        ),
                      ),
                      Positioned(
                        child: FloatingWriteButton(onPressed: () {}),
                        bottom: 25,
                        right: 25,
                      ),
                    ]);
                  }
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
