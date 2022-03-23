import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostEditPage extends GetView<CommunityController> {
  const PostEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _headerTitle = '글 수정';
    const String _submitButtonText = '완료';

    void _onBackPressed() {
      Get.back();
      controller.resetPostWrite();
    }

    void _onSubmitPressed() async {
      await controller.updatePost();
      Get.back();
      Get.showSnackbar(
        GetSnackBar(
          messageText: const Text(
            '게시글이 성공적으로 수정되었습니다',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          borderRadius: 10,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
          duration: const Duration(seconds: 2),
          isDismissible: false,
          backgroundColor: darkSecondaryColor.withOpacity(0.8),
        ),
      );
      controller.resetPostWrite();
      controller.postRefreshController.requestRefresh(needCallback: false);
      await controller.getPost(controller.postId!);
      controller.postRefreshController.refreshCompleted();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<CommunityController>(builder: (_) {
          return Stack(
            children: [
              Column(
                children: [
                  Header(
                    onPressed: _onBackPressed,
                    title: _headerTitle,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: TextActionButton(
                          buttonText: _submitButtonText,
                          onPressed: _onSubmitPressed,
                          fontSize: 16,
                          textColor: brightPrimaryColor,
                          isUnderlined: false,
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 15, left: 30, right: 30),
                      children: [
                        TitleInputField(
                          controller: controller.postTitleTextController,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ContentInputField(
                            controller: controller.postContentTextController,
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          height: 0.5,
                          color: Color(0xffAEADAD),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: mainBackgroundColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '엑손 게시판 이용규칙',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffA1A0A0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '1. 욕설 및 비방 금지',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Color(0xffA1A0A0),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              _.apiPostLoading
                  ? const LoadingIndicator()
                  : const SizedBox.shrink(),
            ],
          );
        }),
      ),
    );
  }
}
