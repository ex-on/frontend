import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:exon_app/ui/widgets/community/floating_write_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QnaListPage extends StatelessWidget {
  const QnaListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<CommunityController>(CommunityController());

    controller.qnaListPage.listen((val) {
      controller.qnaListPageCallback(val);
    });

    void _onBackPressed() {
      controller.resetContent();
      Get.back();
      controller.qnaListCallback(controller.qnaCategory.value);
    }

    void _onWritePressed() {
      Get.toNamed('community/qna/write');
    }

    return Scaffold(
      body: GetBuilder<CommunityController>(
        builder: (_) {
          return Column(
            children: [
              Header(
                onPressed: _onBackPressed,
                title: (qnaCategoryIntToStr[controller.qnaCategory.value] ??
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
                          controller: _.qnaListScrollController,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            if (index == _.qnaContentList.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: CircularProgressIndicator(
                                      color: brightPrimaryColor),
                                ),
                              );
                            }
                            return QnaContentPreviewBuilder(
                                data: _.qnaContentList[index]);
                          },
                          separatorBuilder: (context, index) => const Divider(
                            color: lightGrayColor,
                            thickness: 0.5,
                            height: 0.5,
                          ),
                          itemCount: _.qnaContentList.length +
                              (_.listPageLoading ? 1 : 0),
                        ),
                      ),
                      Positioned(
                        child: FloatingWriteButton(onPressed: _onWritePressed),
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
