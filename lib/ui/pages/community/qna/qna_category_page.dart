import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';

class QnaCategoryPage extends GetView<CommunityController> {
  const QnaCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _qnaCategoryLabelText = '주제별 Q&A';
    const String _expandQnaViewButtonText = '더보기 >';

    void _onCategoryButtonPressed(int index) {
      controller.qnaCategory.value = index;
      controller.update();
    }

    void _onExpandQnaViewPressed() {
      Get.toNamed('/community/qna/list');
      controller.qnaListPageCallback(controller.qnaListPage.value);
    }

    return Column(
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
                  _qnaCategoryLabelText,
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
                  itemCount: 4,
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
                                    color: _.qnaCategory.value == index
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
                              qnaCategoryIntToStr[index] ?? '',
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
        verticalSpacer(15),
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
                              (qnaCategoryIntToStr[_.qnaCategory.value] ?? '') +
                                  ' Q&A',
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
                        buttonText: _expandQnaViewButtonText,
                        onPressed: _onExpandQnaViewPressed,
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
                          return QnaContentPreviewBuilder(data: _.qnaContentList[index]);
                        },
                        separatorBuilder: (context, index) => const Divider(
                          color: lightGrayColor,
                          thickness: 0.5,
                          height: 0.5,
                        ),
                        itemCount: _.qnaContentList.length,
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
  }
}
