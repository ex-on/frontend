import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QnaWritePage extends GetView<CommunityController> {
  const QnaWritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _headerTitle = '질문하기';
    const String _submitButtonText = '등록';

    void _onBackPressed() {
      Get.back();
      controller.resetQnaWrite();
    }

    void _onSubmitPressed() async {
      await controller.postQna();
      controller.qnaListStartIndex.value = 0;
      Get.back();
      controller.resetQnaWrite();
      controller.getQnaPreview(
          null, controller.qnaCategory.value == 1 ? false : true);
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
                          activated: _.qnaTitleTextController.text.isNotEmpty &&
                              _.qnaContentTextController.text.isNotEmpty,
                          isUnderlined: false,
                        ),
                      )
                    ],
                  );
                },),
                Expanded(
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding:
                        const EdgeInsets.only(top: 15, left: 30, right: 30),
                    children: [
                      TitleInputField(
                        hintText: '질문 제목',
                        controller: controller.qnaTitleTextController,
                        onChanged: (String val) => controller.update(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ContentInputField(
                          controller: controller.qnaContentTextController,
                          onChanged: (String val) => controller.update(),
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
