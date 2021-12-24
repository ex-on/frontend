import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/comment_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class QnaAnswerCommentsPage extends GetView<CommunityController> {
  const QnaAnswerCommentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _replyArrowIcon = 'assets/icons/replyArrowIcon.svg';

    void _onBackPressed() {
      Get.back();
    }

    void _onCommentLikePressed(int index) {
      controller.updateQnaAnswerCommentCountLikes(index);
    }

    void _onReplyPressed(int commentId) {
      controller.updateReplyCommentId(commentId);
      FocusScope.of(context).requestFocus(controller.commentTextFieldFocus);
    }

    void _onSendPressed() {
      if (controller.commentId != null) {
        controller.postQnaCommentReply(
            controller.commentId!, controller.commentTextController.text);
        controller.updateReplyCommentId(null);
      } else {
        controller.postQnaComment(controller.commentTextController.text);
      }
      controller.commentTextController.clear();
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CommentsHeader(
            onPressed: _onBackPressed,
            numComments: 13,
          ),
          const Divider(
            indent: 6,
            endIndent: 6,
            color: lightGrayColor,
            height: 1,
            thickness: 1,
          ),
          Expanded(
            child: GetBuilder<CommunityController>(builder: (_) {
              if (_.commentsLoading) {
                return const LoadingIndicator();
              } else {
                return Stack(
                  children: [
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        if (_.qnaAnswerCommentList[index]['replies'].length ==
                            0) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: (_.commentId ==
                                          _.qnaAnswerCommentList[index]
                                                  ['comment']['comment_data']
                                              ['id'] &&
                                      _.commentTextFieldFocus!.hasFocus)
                                  ? const Color(0xffEDFCFF)
                                  : Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 25, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            _.qnaAnswerCommentList[index]
                                                    ['comment']['user_data']
                                                ['username'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: -2,
                                              color: clearBlackColor,
                                            ),
                                          ),
                                          if (_.qnaAnswerCommentList[index]
                                                      ['comment']['user_data']
                                                  ['username'] ==
                                              (_.qnaAnswerList.where(
                                                      (element) =>
                                                          element['answer_data']
                                                              ['id'] ==
                                                          _.answerId) as Map)[
                                                  'user_data']['username'])
                                            const CommentBadge(text: '답변자'),
                                        ],
                                      ),
                                      DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: mainBackgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Material(
                                                type: MaterialType.transparency,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(6)),
                                                child: InkWell(
                                                  splashColor:
                                                      brightSecondaryColor,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    bottomLeft:
                                                        Radius.circular(6),
                                                  ),
                                                  onTap: () =>
                                                      _onCommentLikePressed(
                                                          index),
                                                  child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: GetBuilder<
                                                        CommunityController>(
                                                      builder: (_) {
                                                        return Center(
                                                          child: LikeIcon(
                                                            color: _.qnaAnswerCommentList[
                                                                            index]
                                                                        [
                                                                        'comment']
                                                                    ['liked']
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
                                                    const BorderRadius.all(
                                                        Radius.circular(6)),
                                                child: InkWell(
                                                  splashColor:
                                                      brightPrimaryColor,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(6),
                                                    bottomRight:
                                                        Radius.circular(6),
                                                  ),
                                                  onTap: () => _onReplyPressed(
                                                      _.qnaAnswerCommentList[
                                                                      index]
                                                                  ['comment']
                                                              ['comment_data']
                                                          ['id']),
                                                  child: const SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Center(
                                                      child: CommentIcon(),
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
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 5),
                                    child: Text(
                                      _.qnaAnswerCommentList[index]['comment']
                                          ['comment_data']['content'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        height: 1.3,
                                        color: darkPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatDateTimeRawString(
                                          _.qnaAnswerCommentList[index]
                                                  ['comment']['comment_data']
                                              ['creation_date'],
                                        ),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: lightGrayColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 5),
                                            child: LikeIcon(
                                              width: 7,
                                              height: 12,
                                            ),
                                          ),
                                          Text(
                                            _.qnaAnswerCommentList[index]
                                                    ['comment']['comment_count']
                                                    ['count_likes']
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
                        } else {
                          List<Widget> children = <Widget>[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: (_.commentId ==
                                            _.qnaAnswerCommentList[index]
                                                    ['comment']['comment_data']
                                                ['id'] &&
                                        _.commentTextFieldFocus!.hasFocus)
                                    ? const Color(0xffEDFCFF)
                                    : Colors.transparent,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 25, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: CircleAvatar(
                                                backgroundColor: lightGrayColor,
                                                radius: 10,
                                              ),
                                            ),
                                            Text(
                                              _.qnaAnswerCommentList[index]
                                                      ['comment']['user_data']
                                                  ['username'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                letterSpacing: -2,
                                                color: clearBlackColor,
                                              ),
                                            ),
                                            (() {
                                              if (_.qnaAnswerCommentList[index]['comment']
                                                          ['user_data']
                                                      ['username'] ==
                                                  _.qnaAnswerList
                                                          .where((element) =>
                                                              element['answer_data']
                                                                  ['id'] ==
                                                              _.answerId)
                                                          .toList()[0][
                                                      'user_data']['username']) {
                                                return const CommentBadge(
                                                    text: '답변자');
                                              } else if (_.qnaAnswerCommentList[
                                                          index]['comment']['user_data']
                                                      ['username'] ==
                                                  _.qnaContent['user_data']
                                                      ['username']) {
                                                return const CommentBadge(
                                                    text: '질문자');
                                              } else {
                                                return horizontalSpacer(0);
                                              }
                                            })(),
                                          ],
                                        ),
                                        DecoratedBox(
                                          decoration: const BoxDecoration(
                                            color: mainBackgroundColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                          ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6)),
                                                  child: InkWell(
                                                    splashColor:
                                                        brightSecondaryColor,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                    ),
                                                    onTap: () =>
                                                        _onCommentLikePressed(
                                                            index),
                                                    child: SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: GetBuilder<
                                                          CommunityController>(
                                                        builder: (_) {
                                                          return Center(
                                                            child: LikeIcon(
                                                              color: _.qnaAnswerCommentList[
                                                                              index]
                                                                          [
                                                                          'comment']
                                                                      ['liked']
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
                                                  type:
                                                      MaterialType.transparency,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6)),
                                                  child: InkWell(
                                                    splashColor:
                                                        brightPrimaryColor,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                    onTap: () => _onReplyPressed(
                                                        _.qnaAnswerCommentList[
                                                                        index]
                                                                    ['comment']
                                                                ['comment_data']
                                                            ['id']),
                                                    child: const SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: CommentIcon(),
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
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 5),
                                      child: Text(
                                        _.qnaAnswerCommentList[index]['comment']
                                            ['comment_data']['content'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          height: 1.3,
                                          color: darkPrimaryColor,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          formatDateTimeRawString(
                                            _.qnaAnswerCommentList[index]
                                                    ['comment']['comment_data']
                                                ['creation_date'],
                                          ),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: lightGrayColor,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 5),
                                              child: LikeIcon(
                                                width: 7,
                                                height: 12,
                                              ),
                                            ),
                                            Text(
                                              _.qnaAnswerCommentList[index]
                                                      ['comment']
                                                      ['comment_count']
                                                      ['count_likes']
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
                            ),
                          ];

                          _.qnaAnswerCommentList[index]['replies'].forEach(
                            (reply) {
                              children.add(
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, top: 5),
                                      child: SvgPicture.asset(_replyArrowIcon),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.fromLTRB(
                                          5, 5, 0, 10),
                                      width: context.width - 80,
                                      decoration: BoxDecoration(
                                        color: mainBackgroundColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          lightGrayColor,
                                                      radius: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    reply['user_data']
                                                        ['username'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      letterSpacing: -2,
                                                      color: clearBlackColor,
                                                    ),
                                                  ),
                                                  (() {
                                                    if (reply['user_data']
                                                            ['username'] ==
                                                        _.qnaAnswerList
                                                                .where((element) =>
                                                                    element['answer_data']
                                                                        ['id'] ==
                                                                    _.answerId)
                                                                .toList()[0][
                                                            'user_data']['username']) {
                                                      return const CommentBadge(
                                                          text: '답변자');
                                                    } else if (reply[
                                                                'user_data']
                                                            ['username'] ==
                                                        _.qnaContent[
                                                                'user_data']
                                                            ['username']) {
                                                      return const CommentBadge(
                                                          text: '질문자');
                                                    } else {
                                                      return horizontalSpacer(
                                                          0);
                                                    }
                                                  })()
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 5),
                                            child: Text(
                                              reply['reply_data']['content'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                height: 1.3,
                                                color: darkPrimaryColor,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                formatDateTimeRawString(
                                                  reply['reply_data']
                                                      ['creation_date'],
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: lightGrayColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                          return Column(
                            children: children,
                          );
                        }
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          thickness: 0.5,
                          color: lightGrayColor,
                          height: 1,
                          indent: 5,
                          endIndent: 5,
                        );
                      },
                      itemCount: _.qnaAnswerCommentList.length,
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
                );
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CommentInputTextField(
              focusNode: controller.commentTextFieldFocus,
              onSendPressed: _onSendPressed,
              controller: controller.commentTextController,
              width: context.width - 30,
            ),
          ),
        ],
      ),
    );
  }
}
