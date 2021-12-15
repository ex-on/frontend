import 'dart:ffi';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityPostPage extends GetView<CommunityController> {
  const CommunityPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int postId = Get.arguments;
    const String _commentLabelText = '댓글';
    const String _commentInputLabelText = '댓글을 입력하세요';

    Future.delayed(
        Duration.zero, () => controller.getPostUserStatus(postId, 'all'));

    void _onBackPressed() {
      Get.back();
    }

    void _onLikePressed() {
      controller.updatePostCountLikes(postId);
    }

    void _onSavePressed() {
      controller.updatePostCountSaved(postId);
    }

    void _onCommentLikePressed(int index) {
      controller.updatePostCommentCountLikes(index);
    }

    void _onReplyLikePressed(int commentIndex, int index) {
      controller.updatePostCommentReplyCountLikes(commentIndex, index);
    }

    void _onReplyPressed(int commentId) {
      controller.updateReplyCommentId(commentId);
      FocusScope.of(context).requestFocus(controller.commentTextFieldFocus);
    }

    void _onSendPressed() {
      if (controller.commentId != null) {
        controller.postPostCommentReply(postId, controller.commentId!,
            controller.commentTextController.text);
        controller.updateReplyCommentId(null);
      } else {
        controller.postPostComment(
            postId, controller.commentTextController.text);
      }
      controller.commentTextController.clear();
      FocusScope.of(context).unfocus();
    }

    Widget _postContent = SizedBox(
      width: context.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: GetBuilder<CommunityController>(
          builder: (_) {
            if (_.postContentLoading) {
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
                                _.postContent['user_data']['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: -2,
                                  color: clearBlackColor,
                                ),
                              ),
                              Text(
                                formatDateTimeRawString(
                                    _.postContent['post']['creation_date']),
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
                                  onTap: _onLikePressed,
                                  child: SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                      child: LikeIcon(
                                        width: 11,
                                        height: 21,
                                        color: _.postLiked
                                            ? null
                                            : unselectedIconColor,
                                      ),
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
                                        color: _.postSaved
                                            ? null
                                            : unselectedIconColor,
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
                  verticalSpacer(20),
                  Text(
                    _.postContent['post']['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: communityTitleTextColor,
                      height: 1.3,
                    ),
                  ),
                  verticalSpacer(20),
                  Text(
                    _.postContent['post']['content'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                      color: darkPrimaryColor,
                      height: 1.3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            const LikeIcon(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 12),
                              child: Text(
                                _.postCount['count_likes'].toString(),
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
                                _.postCount['count_comments'].toString(),
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
                                _.postCount['count_saved'].toString(),
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
                ],
              );
            }
          },
        ),
      ),
    );

    Widget _commentBlockBuilder(int index) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 25, 10),
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
                      controller.postCommentList[index]['comments']['user_data']
                          ['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: -2,
                        color: clearBlackColor,
                      ),
                    ),
                  ],
                ),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: mainBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
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
                          onTap: () => _onCommentLikePressed(index),
                          child: SizedBox(
                            height: 30,
                            width: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GetBuilder<CommunityController>(builder: (_) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: LikeIcon(
                                      width: 11,
                                      height: 21,
                                      color: _.postCommentList[index]
                                              ['comments']['liked']
                                          ? brightSecondaryColor
                                          : unselectedIconColor,
                                    ),
                                  );
                                }),
                                Text(
                                  controller.postCommentList[index]['comments']
                                          ['comment_count']['count_likes']
                                      .toString(),
                                  style: const TextStyle(
                                    color: darkPrimaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                          onTap: () => _onReplyPressed(
                              controller.postCommentList[index]['comments']
                                  ['comment_data']['id']),
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 5),
              child: Text(
                controller.postCommentList[index]['comments']['comment_data']
                    ['content'],
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  color: darkPrimaryColor,
                ),
              ),
            ),
            Text(
              formatDateTimeRawString(
                controller.postCommentList[index]['comments']['comment_data']
                    ['creation_date'],
              ),
              style: const TextStyle(
                fontSize: 11,
                color: lightGrayColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget _replyBlockBuilder(
        int commentIndex, List<dynamic> replyList, int index) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(45, 5, 25, 10),
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
                      replyList[index]['user_data']['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: -2,
                        color: clearBlackColor,
                      ),
                    ),
                  ],
                ),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: mainBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Row(
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        child: InkWell(
                          splashColor: brightSecondaryColor,
                          highlightColor: Colors.transparent,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                          onTap: () => _onReplyLikePressed(commentIndex, index),
                          child: SizedBox(
                            height: 30,
                            width: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GetBuilder<CommunityController>(
                                  builder: (_) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: LikeIcon(
                                        width: 11,
                                        height: 21,
                                        color: _.postCommentList[commentIndex]
                                                ['replies'][index]['liked']
                                            ? brightSecondaryColor
                                            : unselectedIconColor,
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  replyList[index]['reply_count']['count_likes']
                                      .toString(),
                                  style: const TextStyle(
                                    color: darkPrimaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 5),
              child: Text(
                replyList[index]['reply_data']['content'],
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  color: darkPrimaryColor,
                ),
              ),
            ),
            Text(
              formatDateTimeRawString(
                replyList[index]['reply_data']['creation_date'],
              ),
              style: const TextStyle(
                fontSize: 11,
                color: lightGrayColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget _commentListBuilder(int index) {
      if (controller.postCommentList[index]['replies'].length == 0) {
        return SizedBox(
          child: Column(
            children: [
              _commentBlockBuilder(index),
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
      } else {
        return SizedBox(
          child: Column(
            children: [
              _commentBlockBuilder(index),
              Column(
                children: List.generate(
                    controller.postCommentList[index]['replies'].length,
                    (val) => _replyBlockBuilder(index,
                        controller.postCommentList[index]['replies'], val)),
              ),
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
    }

    Widget _postComments = SizedBox(
      width: context.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Text(
                _commentLabelText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: darkPrimaryColor,
                ),
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
                if (_.postCommentsLoading) {
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
                      _.postCommentList.length,
                      (index) {
                        return _commentListBuilder(index);
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
                  (postCategoryIntToStr[controller.postCategory.value] ?? '') +
                      ' 게시판',
            ),
            Expanded(
              child: DisableGlowListView(
                padding: EdgeInsets.zero,
                children: [
                  _postContent,
                  Container(
                    color: mainBackgroundColor,
                    height: 20,
                  ),
                  _postComments,
                ],
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
