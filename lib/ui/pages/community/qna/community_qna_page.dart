import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/comment_badge.dart';
import 'package:exon_app/ui/widgets/community/loading_blocks.dart';
import 'package:exon_app/ui/widgets/profile/clickable_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommunityQnaPage extends GetView<CommunityController> {
  const CommunityQnaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _commentLabelText = '답변';
    const String _answerButtonText = '답변하기';
    const String _answerButtonLabelText = '답변이 채택되면 프로틴을 얻을 수 있어요';
    const String _selectAnswerButtonText = '답변 채택하기';
    const String _selectAnswerButtonLabelText = '궁금증이 해결되셨다면 답변을 채택해 주세요';

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

    void _onSelectAnswerPressed() {
      Get.toNamed('community/qna/select_answer');
    }

    void _onEditPressed(int id, String category) {
      Get.back();
      if (category == 'qna') {
        controller.qnaTitleTextController.text =
            controller.qnaContent['qna']['title'];
        controller.qnaContentTextController.text =
            controller.qnaContent['qna']['content'];
        Get.toNamed('community/qna/edit');
      } else if (category == 'qna_answer') {
        // controller.qnaAnswerContentTextController.text = controller.qnaAnswerCommentList[];
        controller.updateAnswerId(id);
        controller.qnaAnswerContentTextController.text =
            controller.qnaAnswerList.firstWhere((element) =>
                element['answer_data']['id'] == id)['answer_data']['content'];
        Get.toNamed('community/qna/answer/edit');
      }
    }

    void _onDeletePressed(int id, String category) async {
      var success = await controller.delete(id, category);
      if (success) {
        if (category == 'qna') {
          Get.back(closeOverlays: true);
          Get.showSnackbar(
            GetSnackBar(
              messageText: const Text(
                'Q&A를 성공적으로 삭제했습니다',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              borderRadius: 10,
              margin: const EdgeInsets.only(left: 10, right: 10),
              duration: const Duration(seconds: 2),
              isDismissible: false,
              backgroundColor: darkSecondaryColor.withOpacity(0.8),
            ),
          );
          if (Get.currentRoute == '/community/qna/list') {
            // controller.postListRefreshController.requestRefresh();
            controller.qnaContentList.removeWhere(
                (element) => element['qna_data']['id'] == controller.qnaId!);
          } else {
            controller.qnaCategoryRefreshController.requestRefresh();
          }
        } else if (category == 'qna_answer') {
          Get.back();
          Get.showSnackbar(
            GetSnackBar(
              messageText: const Text(
                '답변을 성공적으로 삭제했습니다',
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
          controller.qnaRefreshController.requestRefresh(needCallback: false);
          controller.getQnaCount(controller.qnaId!);
          controller.getQnaAnswers(controller.qnaId!);
          controller.qnaRefreshController.refreshCompleted();
        }
      }
    }

    void _onReportPressed(int id, String category) async {
      var success = await controller.report(id, category);
      if (success) {
        Get.back();
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text(
              '신고가 완료되었습니다',
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
      } else if (success == 208) {
        Get.back();
        late String messageText;

        if (category == 'qna') {
          messageText = '이미 신고한 Q&A입니다';
        } else {
          messageText = '이미 신고한 답볌입니다';
        }
        Get.showSnackbar(
          GetSnackBar(
            messageText: Text(
              messageText,
              style: const TextStyle(
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
      }
    }

    void _onMenuPressed(bool isSelf, int id, String category) {
      if (isSelf) {
        Get.bottomSheet(
          CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () => _onDeletePressed(id, category),
                child: const Text(
                  '삭제',
                  style: TextStyle(
                    color: cancelRedColor,
                  ),
                ),
              ),
              if (category == 'qna' || category == 'qna_answer')
                CupertinoActionSheetAction(
                  onPressed: () => _onEditPressed(id, category),
                  child: const Text(
                    '수정',
                    style: TextStyle(
                        // color: cancelRedColor,
                        ),
                  ),
                ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Get.back(),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: clearBlackColor,
                ),
              ),
            ),
          ),
        );
      } else {
        Get.bottomSheet(
          CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () => _onReportPressed(id, category),
                child: const Text(
                  '신고',
                  style: TextStyle(
                    color: clearBlackColor,
                  ),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Get.back(),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: clearBlackColor,
                ),
              ),
            ),
          ),
        );
      }
    }

    Widget _qnaContent = SizedBox(
      width: context.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: GetBuilder<CommunityController>(
          builder: (_) {
            if (_.contentLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: LoadingContentBlock(),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClickableProfile(
                            username: _.qnaContent['user_data']['username'],
                            child: Text(
                              activityLevelIntToStr[_.qnaContent['user_data']
                                      ['activity_level']]! +
                                  ' ' +
                                  _.qnaContent['user_data']['username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: clearBlackColor,
                              ),
                            ),
                          ),
                          Text(
                            formatDateTimeRawString(
                                    _.qnaContent['qna']['created_at']) +
                                ((_.qnaContent['qna']['modified'] == true)
                                    ? ' (수정됨)'
                                    : ''),
                            style: const TextStyle(
                              fontSize: 10,
                              color: lightGrayColor,
                            ),
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
                  if (_.qnaContent['qna']['solved'] == false)
                    Center(
                      child: Column(
                        children: [
                          () {
                            if (controller.qnaContent['user_data']
                                    ['username'] ==
                                AuthController.to.userInfo['username']) {
                              return ElevatedActionButton(
                                buttonText: _selectAnswerButtonText,
                                onPressed: _onSelectAnswerPressed,
                                backgroundColor: mainBackgroundColor,
                                width: 300,
                                textStyle: const TextStyle(
                                  color: darkSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return ElevatedActionButton(
                                buttonText: _answerButtonText,
                                onPressed: _onAnswerPressed,
                                backgroundColor: mainBackgroundColor,
                                width: 300,
                                textStyle: const TextStyle(
                                  color: darkSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: () {
                              if (controller.qnaContent['user_data']
                                      ['username'] ==
                                  AuthController.to.userInfo['username']) {
                                return const Text(
                                  _selectAnswerButtonLabelText,
                                  style: TextStyle(
                                    color: Color(0xff007793),
                                    fontSize: 10,
                                    height: 1.3,
                                  ),
                                );
                              } else {
                                return const Text(
                                  _answerButtonLabelText,
                                  style: TextStyle(
                                    color: Color(0xff007793),
                                    fontSize: 10,
                                    height: 1.3,
                                  ),
                                );
                              }
                            }(),
                          ),
                          verticalSpacer(20),
                        ],
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );

    Widget _answerBlockBuilder(int index) {
      return GetBuilder<CommunityController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 25, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_.qnaAnswerList[index]['answer_data']['selected_type'] ==
                        1 ||
                    _.qnaAnswerList[index]['answer_data']['selected_type'] == 3)
                  const SelectedAnswerBadge(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClickableProfile(
                          username: controller.qnaAnswerList[index]['user_data']
                              ['username'],
                          child: Text(
                            activityLevelIntToStr[
                                    controller.qnaAnswerList[index]['user_data']
                                        ['activity_level']]! +
                                ' ' +
                                controller.qnaAnswerList[index]['user_data']
                                    ['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: clearBlackColor,
                            ),
                          ),
                        ),
                        if (_.qnaAnswerList[index]['answer_data']
                                    ['selected_type'] ==
                                2 ||
                            _.qnaAnswerList[index]['answer_data']
                                    ['selected_type'] ==
                                3)
                          const CommentBadge(text: 'BEST'),
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
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                                onTap: () => _onMenuPressed(
                                    _.qnaAnswerList[index]['user_data']
                                            ['username'] ==
                                        AuthController.to.userInfo['username'],
                                    _.qnaAnswerList[index]['answer_data']['id'],
                                    'qna_answer'),
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
          );
        },
      );
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
        child: Stack(
          children: [
            Column(
              children: [
                Header(
                  onPressed: _onBackPressed,
                  title:
                      (qnaSolvedBoolToStr[controller.qnaSolved] ?? '') + ' Q&A',
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: clearBlackColor,
                      ),
                      splashRadius: 20,
                      onPressed: () => _onMenuPressed(
                          controller.qnaContent['user_data']['username'] ==
                              AuthController.to.userInfo['username'],
                          controller.qnaId!,
                          'qna'),
                    ),
                  ],
                ),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.qnaRefreshController,
                    onRefresh: controller.onQnaRefresh,
                    header: const MaterialClassicHeader(
                      color: brightPrimaryColor,
                    ),
                    child: ListView(
                      controller: controller.postScrollController,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        _qnaContent,
                        const Divider(
                          color: mainBackgroundColor,
                          height: 20,
                          thickness: 20,
                        ),
                        _qnaAnswers,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            GetBuilder<CommunityController>(
              builder: (_) {
                if (_.apiPostLoading) {
                  return const LoadingIndicator();
                } else {
                  return horizontalSpacer(0);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
