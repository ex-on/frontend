import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostWritePage extends GetView<CommunityController> {
  const PostWritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _headerTitle = '글 쓰기';
    const String _submitButtonText = '등록';

    void _onBackPressed() {
      controller.resetPostWrite();
      Get.back();
    }

    void _onSubmitPressed() async {
      await controller.postPost();
      controller.postListStartIndex.value = 0;
      controller.postCategory.value = controller.postType;
      Get.back();
      controller.resetPostWrite();
      controller.getPostPreview(null, controller.postType);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                GetBuilder<CommunityController>(builder: (_) {
                  return Header(
                    onPressed: _onBackPressed,
                    title: postTypeIntToStr[_.postType]! + _headerTitle,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: TextActionButton(
                          buttonText: _submitButtonText,
                          onPressed: _onSubmitPressed,
                          fontSize: 16,
                          textColor: brightPrimaryColor,
                          activated: _
                                  .postTitleTextController.text.isNotEmpty &&
                              _
                                  .postContentTextController.text.isNotEmpty,
                          isUnderlined: false,
                        ),
                      )
                    ],
                  );
                }),
                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsets.only(top: 15, left: 30, right: 30),
                    children: [
                      TitleInputField(
                        onChanged: (String val) => controller.update(),
                        controller: controller.postTitleTextController,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ContentInputField(
                          onChanged: (String val) => controller.update(),
                          controller: controller.postContentTextController,
                        ),
                      ),
                      const Divider(
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
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
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
                          const Text(
                            communityGuidelines,
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
            controller.apiPostLoading
                ? const LoadingIndicator()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
