import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/loading_blocks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

const String _headerTitle = '답변 채택하기';
const String _commentLabelText = '답변';
const String _selectButtonText = '채택하기';

class QnaSelectAnswerPage extends GetView<CommunityController> {
  const QnaSelectAnswerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onBackPressed() {
      Get.back();
      controller.updateSelectedAnswerIndex(-1);
    }

    void _onSelectPressed() {
      controller.postQnaSelectedAnswer(controller
          .qnaAnswerList[controller.selectedAnswerIndex]['answer_data']['id']);
      controller.qnaRefreshController.requestRefresh();
      Get.back();
      controller.updateSelectedAnswerIndex(-1);
    }

    Widget _qnaContent = SizedBox(
      width: context.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: GetBuilder<CommunityController>(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WrappedKoreanText(
                  'Q. ' + _.qnaContent['qna']['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: communityTitleTextColor,
                    height: 1.3,
                  ),
                ),
                verticalSpacer(20),
                Text(
                  _.qnaContent['qna']['content'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                    color: darkPrimaryColor,
                    height: 1.3,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    Widget _answerBlockBuilder(int index) {
      return GetBuilder<CommunityController>(builder: (_) {
        return InkWell(
          onTap: () {
            if (_.selectedAnswerIndex == index) {
              _.updateSelectedAnswerIndex(-1);
            } else {
              _.updateSelectedAnswerIndex(index);
            }
          },
          splashColor: darkSecondaryColor.withOpacity(0.1),
          highlightColor: darkSecondaryColor.withOpacity(0.1),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: index == _.selectedAnswerIndex
                  ? darkSecondaryColor.withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 25, 10),
              child: Row(
                children: [
                  Radio<int>(
                    value: index,
                    groupValue: _.selectedAnswerIndex,
                    onChanged: _.updateSelectedAnswerIndex,
                    activeColor: darkSecondaryColor,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activityLevelIntToStr[controller.qnaAnswerList[index]
                                ['user_data']['activity_level']]! +
                            ' ' +
                            controller.qnaAnswerList[index]['user_data']
                                ['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: clearBlackColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                        child: Text(
                          controller.qnaAnswerList[index]['answer_data']
                              ['content'],
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.3,
                            color: clearBlackColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            formatDateTimeRawString(
                              controller.qnaAnswerList[index]['answer_data']
                                  ['created_at'],
                            ),
                            style: const TextStyle(
                              fontSize: 11,
                              color: lightGrayColor,
                            ),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 5),
                                child: LikeIcon(
                                  width: 7,
                                  height: 12,
                                ),
                              ),
                              Text(
                                controller.qnaAnswerList[index]['answer_count']
                                        ['count_likes']
                                    .toString(),
                                style: const TextStyle(
                                  color: darkPrimaryColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 5),
                                child: CommentIcon(
                                  width: 8,
                                  height: 8,
                                ),
                              ),
                              Text(
                                controller.qnaAnswerList[index]['answer_count']
                                        ['count_comments']
                                    .toString(),
                                style: const TextStyle(
                                  color: darkPrimaryColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }

    Widget _answerListBuilder(int index) {
      return SizedBox(
        child: Column(
          children: [
            _answerBlockBuilder(index),
            const Divider(
              thickness: 0.5,
              color: lightGrayColor,
              height: 1,
              indent: 5,
              endIndent: 5,
            ),
          ],
        ),
      );
    }

    Widget _qnaAnswers = SizedBox(
      width: context.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                children: [
                  const Text(
                    _commentLabelText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: darkPrimaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: GetBuilder<CommunityController>(builder: (_) {
                      if (!_.commentsLoading) {
                        return Text(
                          _.qnaAnswerList.length.toString(),
                          style: const TextStyle(
                            color: brightPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      } else {
                        return const Text(
                          '-',
                          style: TextStyle(
                            color: brightPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      }
                    }),
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 0.5,
              color: lightGrayColor,
              height: 1,
              indent: 5,
              endIndent: 5,
            ),
            GetBuilder<CommunityController>(
              builder: (_) {
                if (_.commentsLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                    child: Center(
                      child: LoadingContentBlock(),
                    ),
                  );
                } else {
                  return Column(
                    children: List.generate(
                      _.qnaAnswerList.length,
                      (index) {
                        return _answerListBuilder(index);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              onPressed: _onBackPressed,
              title: _headerTitle,
            ),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  _qnaContent,
                  const Divider(
                    height: 53,
                    thickness: 13,
                    color: mainBackgroundColor,
                  ),
                  _qnaAnswers,
                ],
              ),
            ),
            SizedBox(
              width: 320,
              height: 60,
              child: GetBuilder<CommunityController>(
                builder: (_) {
                  return ElevatedActionButton(
                    buttonText: _selectButtonText,
                    onPressed: _onSelectPressed,
                    backgroundColor: _.selectedAnswerIndex >= 0
                        ? darkSecondaryColor
                        : mainBackgroundColor,
                    textStyle: TextStyle(
                      color: _.selectedAnswerIndex >= 0
                          ? Colors.white
                          : deepGrayColor,
                      fontWeight: FontWeight.bold,
                    ),
                    activated: _.selectedAnswerIndex >= 0,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
