import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:exon_app/ui/widgets/community/floating_write_button.dart';
import 'package:exon_app/ui/widgets/community/loading_blocks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class QnaCategoryPage extends GetView<CommunityController> {
  const QnaCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.qnaContentList.isEmpty) {
        controller.qnaCategoryListCallback(controller.qnaCategory.value);
      }
    });

    const String _expandQnaViewButtonText = '더보기 >';

    void _onCategoryButtonPressed(int index) {
      late bool? _solved;
      switch (index) {
        case 1:
          _solved = false;
          break;
        case 2:
          _solved = true;
          break;
        default:
          _solved = null;
          break;
      }

      controller.qnaCategory.value = index;
      controller.updateQnaSolved(_solved);
      controller.update();
    }

    void _onExpandQnaViewPressed() {
      controller.setQnaListInitialLoad(true);
      Get.toNamed('/community/qna/list');
    }

    void _onWritePressed() {
      controller.resetQnaWrite();
      Get.toNamed('community/qna/write');
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
                                    color: _.qnaCategory.value == index
                                        ? lightBrightPrimaryColor
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffF3F4F6),
                                    radius: 28.5,
                                    child: () {
                                      switch (index) {
                                        case 0:
                                          return HotIcon();
                                        case 1:
                                          return ProgressingIcon();
                                        case 2:
                                          return SolvedIcon();
                                        default:
                                          break;
                                      }
                                    }(),
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
            padding: EdgeInsets.only(
                top: 15, bottom: context.mediaQueryPadding.bottom),
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
                                  (qnaCategoryIntToStr[_.qnaCategory.value] ??
                                          '') +
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
                    GetBuilder<CommunityController>(
                      builder: (_) {
                        return Expanded(
                          child: SmartRefresher(
                            controller: _.qnaCategoryRefreshController,
                            onRefresh: _.onQnaCategoryRefresh,
                            header: const CustomRefreshHeader(),
                            child: _.loading
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: LoadingCommentBlock(),
                                  )
                                : ListView.separated(
                                    physics: const ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return QnaContentPreviewBuilder(
                                        displaySolved: _.qnaCategory.value == 0,
                                        data: _.qnaContentList[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      color: lightGrayColor,
                                      thickness: 0.5,
                                      height: 0.5,
                                    ),
                                    itemCount:
                                        _.loading ? 0 : _.qnaContentList.length,
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
                  child: FloatingWriteButton(onPressed: _onWritePressed),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
