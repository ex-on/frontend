import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/comment_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CommunityQnaPage extends GetView<CommunityController> {
  const CommunityQnaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _commentLabelText = '답변';
    const String _answerButtonText = '답변하기';

    Future.delayed(Duration.zero, () => controller.getQnaUserStatus());

    void _onBackPressed() {
      Get.back();
    }

    void _onSavePressed() {
      controller.updateQnaCountSaved();
    }

    void _onAnswerLikePressed(int index) {
      controller.updateQnaAnswerCountLikes(index);
    }

    void _onAnswerCommentPressed(int answerId, int numComments) {
      controller.getQnaAnswerComments(answerId);
      controller.updateAnswerId(answerId);
      controller.updateAnswerNumComments(numComments);
      Get.toNamed('/community/qna/answer_comments');
    }

    void _onAnswerPressed() {
      Get.toNamed('community/qna/answer/write');
    }

    void _onMenuPressed() {}

    Widget _qnaContent = SizedBox(
      width: context.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: GetBuilder<CommunityController>(
          builder: (_) {
            if (_.contentLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: CircularProgressIndicator(
                    color: brightPrimaryColor,
                  ),
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: lightGrayColor,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _.qnaContent['user_data']['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: -2,
                                  color: clearBlackColor,
                                ),
                              ),
                              Text(
                                formatDateTimeRawString(
                                    _.qnaContent['qna']['created_at']),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: lightGrayColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          color: mainBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          child: InkWell(
                            splashColor: darkSecondaryColor,
                            highlightColor: Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                            onTap: _onSavePressed,
                            child: SizedBox(
                              height: 35,
                              width: 35,
                              child: Center(
                                child: BookmarkIcon(
                                  width: 16,
                                  height: 16,
                                  color: _.qnaSaved
                                      ? null
                                      : (_.qnaSaved
                                          ? darkSecondaryColor
                                          : unselectedIconColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(20),
                  Text(
                    _.qnaContent['qna']['title'],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            const LikeIcon(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 12),
                              child: Text(
                                _.qnaCount['count_likes'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const CommentIcon(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 12),
                              child: Text(
                                _.qnaCount['count_answers'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const BookmarkIcon(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 12),
                              child: Text(
                                _.qnaCount['count_saved'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: ElevatedActionButton(
                        buttonText: _answerButtonText,
                        onPressed: _onAnswerPressed,
                        backgroundColor: mainBackgroundColor,
                        width: 300,
                        textStyle: const TextStyle(
                          color: darkSecondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  verticalSpacer(20),
                ],
              );
            }
          },
        ),
      ),
    );

    Widget _answerBlockBuilder(int index) {
      return GetBuilder<CommunityController>(builder: (_) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color:
                // (_.commentId ==
                //             _.postCommentList[index]['comments']['comment_data']
                //                 ['id'] &&
                //         _.commentTextFieldFocus!.hasFocus)
                //     ? const Color(0xffEDFCFF)
                //     :
                Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 25, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: CircleAvatar(
                            backgroundColor: lightGrayColor,
                            radius: 10,
                          ),
                        ),
                        Text(
                          controller.qnaAnswerList[index]['user_data']
                              ['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: -2,
                            color: clearBlackColor,
                          ),
                        ),
                        if (_.qnaAnswerList[index]['user_data']['username'] ==
                            _.qnaContent['user_data']['username'])
                          const CommentBadge(text: '질문자'),
                      ],
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: mainBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Material(
                              type: MaterialType.transparency,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              child: InkWell(
                                splashColor: brightSecondaryColor,
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                ),
                                onTap: () => _onAnswerLikePressed(index),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: GetBuilder<CommunityController>(
                                    builder: (_) {
                                      return Center(
                                        child: LikeIcon(
                                          color: _.qnaAnswerList[index]['liked']
                                              ? brightSecondaryColor
                                              : unselectedIconColor,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              width: 2,
                              indent: 8,
                              endIndent: 8,
                              color: unselectedIconColor,
                            ),
                            Material(
                              type: MaterialType.transparency,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              child: InkWell(
                                splashColor: brightPrimaryColor,
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                                onTap: () => _onAnswerCommentPressed(
                                    controller.qnaAnswerList[index]
                                        ['answer_data']['id'],
                                    controller.qnaAnswerList[index]
                                        ['answer_count']['count_comments']),
                                child: const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                    child:
                                        CommentIcon(color: unselectedIconColor),
                                  ),
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              width: 2,
                              indent: 8,
                              endIndent: 8,
                              color: unselectedIconColor,
                            ),
                            Material(
                              type: MaterialType.transparency,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              child: InkWell(
                                splashColor: deepGrayColor,
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                                onTap: () => _onMenuPressed(),
                                child: const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                    child: Icon(
                                      Icons.more_vert_rounded,
                                      color: lightGrayColor,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                  child: Text(
                    controller.qnaAnswerList[index]['answer_data']['content'],
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
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
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
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child:
                          CircularProgressIndicator(color: brightPrimaryColor),
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
      body: Stack(children: [
        Column(
          children: [
            Header(
              onPressed: _onBackPressed,
              title:
                  (qnaCategoryIntToStr[controller.qnaCategory] ?? '') + ' Q&A',
            ),
            Expanded(
              child: DisableGlowListView(
                controller: controller.postScrollController,
                padding: EdgeInsets.zero,
                children: [
                  _qnaContent,
                  Container(
                    color: mainBackgroundColor,
                    height: 20,
                  ),
                  _qnaAnswers,
                ],
              ),
            ),
          ],
        ),
        GetBuilder<CommunityController>(builder: (_) {
          if (_.apiPostLoading) {
            return const LoadingIndicator();
          } else {
            return horizontalSpacer(0);
          }
        })
      ]),
    );
  }
}
