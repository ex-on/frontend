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
import 'package:exon_app/ui/widgets/community/loading_blocks.dart';
import 'package:exon_app/ui/widgets/profile/clickable_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

    void _onDeletePressed(int id, String category) async {
      var success = await controller.delete(id, category);
      if (success) {
        Get.back();
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text(
              '댓글을 성공적으로 삭제했습니다',
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
        controller.qnaAnswerCommentsRefreshController.requestRefresh();
      }
    }

    void _onReportPressed() {}

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
                onPressed: _onReportPressed,
                child: const Text(
                  '신고',
                  style: TextStyle(
                    color: clearBlackColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }
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
      body: SafeArea(
        child: Column(
          children: [
            CommentsHeader(
              onPressed: _onBackPressed,
              numComments: controller.answerNumComments!,
            ),
            const Divider(
              indent: 6,
              endIndent: 6,
              color: lightGrayColor,
              height: 1,
              thickness: 1,
            ),
            Expanded(
              child: SmartRefresher(
                controller: controller.qnaAnswerCommentsRefreshController,
                onRefresh: controller.onQnaAnswerCommentsRefresh,
                header: const MaterialClassicHeader(
                  color: brightPrimaryColor,
                ),
                child: GetBuilder<CommunityController>(builder: (_) {
                  if (_.commentsLoading) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: Column(
                        children: [
                          const LoadingCommentBlock(),
                          verticalSpacer(20),
                          const LoadingCommentBlock(),
                        ],
                      ),
                    );
                  } else {
                    return Stack(
                      children: [
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (_.qnaAnswerCommentList[index]['replies']
                                    .length ==
                                0) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  color: (_.commentId ==
                                              _.qnaAnswerCommentList[index]
                                                      ['comment']
                                                  ['comment_data']['id'] &&
                                          _.commentTextFieldFocus!.hasFocus)
                                      ? const Color(0xffEDFCFF)
                                      : Colors.transparent,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 25, 5),
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
                                              ClickableProfile(
                                                username:
                                                    _.qnaAnswerCommentList[
                                                                    index]
                                                                ['comment']
                                                            ['user_data']
                                                        ['username'],
                                                child: Text(
                                                  activityLevelIntToStr[
                                                          _.qnaAnswerCommentList[
                                                                          index]
                                                                      [
                                                                      'comment']
                                                                  ['user_data'][
                                                              'activity_level']]! +
                                                      ' ' +
                                                      _.qnaAnswerCommentList[
                                                                      index]
                                                                  ['comment']
                                                              ['user_data']
                                                          ['username'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: clearBlackColor,
                                                  ),
                                                ),
                                              ),
                                              if (_.qnaAnswerCommentList[index]
                                                              ['comment']
                                                          ['user_data']
                                                      ['username'] ==
                                                  (_.qnaAnswerList
                                                          .where((element) =>
                                                              element['answer_data']
                                                                  ['id'] ==
                                                              _.answerId)
                                                          .toList()[0])[
                                                      'user_data']['username'])
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    '답변자',
                                                    style: TextStyle(
                                                      color: brightPrimaryColor,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
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
                                                    type: MaterialType
                                                        .transparency,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(6)),
                                                    child: InkWell(
                                                      splashColor:
                                                          brightSecondaryColor,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
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
                                                                color: _.qnaAnswerCommentList[index]
                                                                            [
                                                                            'comment']
                                                                        [
                                                                        'liked']
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
                                                    type: MaterialType
                                                        .transparency,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(6)),
                                                    child: InkWell(
                                                      splashColor:
                                                          brightPrimaryColor,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(6),
                                                        bottomRight:
                                                            Radius.circular(6),
                                                      ),
                                                      onTap: () => _onReplyPressed(
                                                          _.qnaAnswerCommentList[
                                                                          index]
                                                                      [
                                                                      'comment']
                                                                  [
                                                                  'comment_data']
                                                              ['id']),
                                                      child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: GetBuilder<
                                                                CommunityController>(
                                                            builder: (_) {
                                                          return Center(
                                                            child: CommentIcon(
                                                              color: (_.commentId ==
                                                                          _.qnaAnswerCommentList[index]['comment']['comment_data']
                                                                              [
                                                                              'id'] &&
                                                                      _.commentTextFieldFocus!
                                                                          .hasFocus)
                                                                  ? brightPrimaryColor
                                                                  : unselectedIconColor,
                                                            ),
                                                          );
                                                        }),
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
                                                    type: MaterialType
                                                        .transparency,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(6)),
                                                    child: InkWell(
                                                      highlightColor:
                                                          Colors.transparent,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(6),
                                                        bottomRight:
                                                            Radius.circular(6),
                                                      ),
                                                      onTap: () =>
                                                          _onMenuPressed(
                                                        _.qnaAnswerCommentList[
                                                                            index]
                                                                        [
                                                                        'comment']
                                                                    [
                                                                    'user_data']
                                                                ['username'] ==
                                                            AuthController.to
                                                                    .userInfo[
                                                                'username'],
                                                        _.qnaAnswerCommentList[
                                                                        index]
                                                                    ['comment']
                                                                ['comment_data']
                                                            ['id'],
                                                        'qna_answer_comment',
                                                      ),
                                                      child: const SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons
                                                                .more_vert_rounded,
                                                            color:
                                                                lightGrayColor,
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
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 5),
                                        child: Text(
                                          _.qnaAnswerCommentList[index]
                                                  ['comment']['comment_data']
                                              ['content'],
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
                                                          ['comment']
                                                      ['comment_data']
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
                              );
                            } else {
                              List<Widget> children = <Widget>[
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: (_.commentId ==
                                                _.qnaAnswerCommentList[index]
                                                        ['comment']
                                                    ['comment_data']['id'] &&
                                            _.commentTextFieldFocus!.hasFocus)
                                        ? const Color(0xffEDFCFF)
                                        : Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 5, 25, 5),
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
                                                ClickableProfile(
                                                  username:
                                                      _.qnaAnswerCommentList[
                                                                      index][
                                                                  'comment']
                                                              ['user_data']
                                                          ['username'],
                                                  child: Text(
                                                    activityLevelIntToStr[
                                                            _.qnaAnswerCommentList[
                                                                            index]
                                                                        ['comment']
                                                                    [
                                                                    'user_data']
                                                                [
                                                                'activity_level']]! +
                                                        ' ' +
                                                        _.qnaAnswerCommentList[
                                                                        index]
                                                                    ['comment']
                                                                ['user_data']
                                                            ['username'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: clearBlackColor,
                                                    ),
                                                  ),
                                                ),
                                                (() {
                                                  if (_.qnaAnswerCommentList[
                                                                      index]
                                                                  ['comment']
                                                              ['user_data']
                                                          ['username'] ==
                                                      _.qnaAnswerList
                                                              .where((element) =>
                                                                  element['answer_data']
                                                                      ['id'] ==
                                                                  _.answerId)
                                                              .toList()[0][
                                                          'user_data']['username']) {
                                                    return const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text(
                                                        '답변자',
                                                        style: TextStyle(
                                                          color:
                                                              brightPrimaryColor,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    );
                                                  } else if (_.qnaAnswerCommentList[
                                                                      index]
                                                                  ['comment']
                                                              ['user_data']
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
                                                      type: MaterialType
                                                          .transparency,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  6)),
                                                      child: InkWell(
                                                        splashColor:
                                                            brightSecondaryColor,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  6),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  6),
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
                                                                  color: _.qnaAnswerCommentList[index]
                                                                              [
                                                                              'comment']
                                                                          [
                                                                          'liked']
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
                                                      color:
                                                          unselectedIconColor,
                                                    ),
                                                    Material(
                                                      type: MaterialType
                                                          .transparency,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  6)),
                                                      child: InkWell(
                                                        splashColor:
                                                            brightPrimaryColor,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  6),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  6),
                                                        ),
                                                        onTap: () => _onReplyPressed(
                                                            _.qnaAnswerCommentList[
                                                                        index]
                                                                    ['comment'][
                                                                'comment_data']['id']),
                                                        child: SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: GetBuilder<
                                                                  CommunityController>(
                                                              builder: (_) {
                                                            return Center(
                                                              child:
                                                                  CommentIcon(
                                                                color: (_.commentId ==
                                                                            _.qnaAnswerCommentList[index]['comment']['comment_data'][
                                                                                'id'] &&
                                                                        _.commentTextFieldFocus!
                                                                            .hasFocus)
                                                                    ? brightPrimaryColor
                                                                    : unselectedIconColor,
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                    ),
                                                    const VerticalDivider(
                                                      thickness: 1,
                                                      width: 2,
                                                      indent: 8,
                                                      endIndent: 8,
                                                      color:
                                                          unselectedIconColor,
                                                    ),
                                                    Material(
                                                      type: MaterialType
                                                          .transparency,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  6)),
                                                      child: InkWell(
                                                        highlightColor:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  6),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  6),
                                                        ),
                                                        onTap: () =>
                                                            _onMenuPressed(
                                                          _.qnaAnswerCommentList[
                                                                              index]
                                                                          [
                                                                          'comment']
                                                                      [
                                                                      'user_data']
                                                                  [
                                                                  'username'] ==
                                                              AuthController.to
                                                                      .userInfo[
                                                                  'username'],
                                                          _.qnaAnswerCommentList[
                                                                          index]
                                                                      [
                                                                      'comment']
                                                                  [
                                                                  'comment_data']
                                                              ['id'],
                                                          'qna_answer_comment',
                                                        ),
                                                        child: const SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .more_vert_rounded,
                                                              color:
                                                                  lightGrayColor,
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
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 5),
                                          child: Text(
                                            _.qnaAnswerCommentList[index]
                                                    ['comment']['comment_data']
                                                ['content'],
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
                                                            ['comment']
                                                        ['comment_data']
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30, top: 5),
                                          child:
                                              SvgPicture.asset(_replyArrowIcon),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.fromLTRB(
                                              5, 5, 0, 10),
                                          width: context.width - 80,
                                          decoration: BoxDecoration(
                                            color: mainBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      ClickableProfile(
                                                        username:
                                                            reply['user_data']
                                                                ['username'],
                                                        child: Text(
                                                          activityLevelIntToStr[
                                                                  reply['user_data']
                                                                      [
                                                                      'activity_level']]! +
                                                              ' ' +
                                                              reply['user_data']
                                                                  ['username'],
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color:
                                                                clearBlackColor,
                                                          ),
                                                        ),
                                                      ),
                                                      (() {
                                                        if (reply['user_data']
                                                                ['username'] ==
                                                            _.qnaAnswerList
                                                                .where((element) =>
                                                                    element['answer_data']
                                                                        [
                                                                        'id'] ==
                                                                    _.answerId)
                                                                .toList()[0]['user_data']['username']) {
                                                          return const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              '답변자',
                                                              style: TextStyle(
                                                                color:
                                                                    brightPrimaryColor,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          );
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
                                                      })(),
                                                    ],
                                                  ),
                                                  DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(6),
                                                      ),
                                                    ),
                                                    child: Material(
                                                      type: MaterialType
                                                          .transparency,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(6),
                                                      ),
                                                      child: InkWell(
                                                        highlightColor:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(6),
                                                        ),
                                                        onTap: () =>
                                                            _onMenuPressed(
                                                          reply['user_data'][
                                                                  'username'] ==
                                                              AuthController.to
                                                                      .userInfo[
                                                                  'username'],
                                                          reply['reply_data']
                                                              ['id'],
                                                          'qna_answer_comment_reply',
                                                        ),
                                                        child: const SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .more_vert_rounded,
                                                              color:
                                                                  lightGrayColor,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, bottom: 5),
                                                child: Text(
                                                  reply['reply_data']
                                                      ['content'],
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
                                                          ['created_at'],
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
      ),
    );
  }
}
