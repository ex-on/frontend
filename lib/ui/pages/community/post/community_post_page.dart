import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/loading_blocks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommunityPostPage extends GetView<CommunityController> {
  const CommunityPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _commentLabelText = '댓글';
    const String _replyArrowIcon = 'assets/icons/replyArrowIcon.svg';

    Future.delayed(Duration.zero, () => controller.getPostUserStatus('all'));

    void _onBackPressed() {
      Get.back();
    }

    void _onLikePressed() {
      controller.updatePostCountLikes();
    }

    void _onSavePressed() {
      controller.updatePostCountSaved();
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

    void _onDeletePressed(int id, String category) async {
      var success = await controller.delete(id, category);
      if (category == 'post') {
        if (success) {
          Get.back(closeOverlays: true);
          Get.showSnackbar(
            GetSnackBar(
              messageText: const Text(
                '게시글을 성공적으로 삭제했습니다',
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
          if (Get.currentRoute == '/community/post/list') {
            // controller.postListRefreshController.requestRefresh();
            controller.postContentList.removeWhere(
                (element) => element['post_data']['id'] == controller.postId!);
          } else {
            controller.postCategoryRefreshController.requestRefresh();
          }
        }
      } else if (category == 'post_comment' ||
          category == 'post_comment_reply') {
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
          controller.postRefreshController.requestRefresh(needCallback: false);
          controller.getPostCount(controller.postId!);
          controller.getPostComments(controller.postId!);
          controller.postRefreshController.refreshCompleted();
        }
      }
    }

    void _onEditPressed() {
      Get.back();
      controller.postTitleTextController.text =
          controller.postContent['post']['title'];
      controller.postContentTextController.text =
          controller.postContent['post']['content'];
      Get.toNamed('community/post/edit');
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
              if (category == 'post')
                CupertinoActionSheetAction(
                  onPressed: () => _onEditPressed(),
                  child: const Text(
                    '수정',
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
        Get.bottomSheet(CupertinoActionSheet(
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
        ));
      }
    }

    void _onSendPressed() {
      if (controller.commentId != null) {
        controller.postPostCommentReply(
            controller.commentId!, controller.commentTextController.text);
        controller.updateReplyCommentId(null);
      } else {
        controller.postPostComment(controller.commentTextController.text);
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
            if (_.contentLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: LoadingContentBlock(),
                ),
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
                          Text(
                            activityLevelIntToStr[_.postContent['user_data']
                                    ['activity_level']]! +
                                ' ' +
                                _.postContent['user_data']['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: clearBlackColor,
                            ),
                          ),
                          Text(
                            formatDateTimeRawString(
                                    _.postContent['post']['created_at']) +
                                ((_.postContent['post']['modified'] == true)
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
                      color: clearBlackColor,
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
      return GetBuilder<CommunityController>(builder: (_) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: (_.commentId ==
                        _.postCommentList[index]['comments']['comment_data']
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          activityLevelIntToStr[_.postCommentList[index]
                                      ['comments']['user_data']
                                  ['activity_level']]! +
                              ' ' +
                              _.postCommentList[index]['comments']['user_data']
                                  ['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: clearBlackColor,
                          ),
                        ),
                        if (controller.postCommentList[index]['comments']
                                ['user_data']['username'] ==
                            AuthController.to.userInfo['username'])
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              '글쓴이',
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
                                onTap: () => _onCommentLikePressed(index),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: GetBuilder<CommunityController>(
                                    builder: (_) {
                                      return Center(
                                        child: LikeIcon(
                                          color: _.postCommentList[index]
                                                  ['comments']['liked']
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
                                onTap: () => _onReplyPressed(
                                    controller.postCommentList[index]
                                        ['comments']['comment_data']['id']),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: GetBuilder<CommunityController>(
                                      builder: (_) {
                                    return Center(
                                      child: CommentIcon(
                                        color: (_.commentId ==
                                                    _.postCommentList[index]
                                                                ['comments']
                                                            ['comment_data']
                                                        ['id'] &&
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
                                    controller.postCommentList[index]
                                                ['comments']['user_data']
                                            ['username'] ==
                                        AuthController.to.userInfo['username'],
                                    controller.postCommentList[index]
                                        ['comments']['comment_data']['id'],
                                    'post_comment'),
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
                    controller.postCommentList[index]['comments']
                        ['comment_data']['content'],
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
                        controller.postCommentList[index]['comments']
                            ['comment_data']['created_at'],
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
                          controller.postCommentList[index]['comments']
                                  ['comment_count']['count_likes']
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

    Widget _replyBlockBuilder(
        int commentIndex, List<dynamic> replyList, int index) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 5),
            child: SvgPicture.asset(_replyArrowIcon),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(5, 5, 0, 10),
            width: context.width - 80,
            decoration: BoxDecoration(
              color: mainBackgroundColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          activityLevelIntToStr[replyList[index]['user_data']
                                  ['activity_level']]! +
                              ' ' +
                              replyList[index]['user_data']['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: clearBlackColor,
                          ),
                        ),
                        if (replyList[index]['user_data']['username'] ==
                            AuthController.to.userInfo['username'])
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              '글쓴이',
                              style: TextStyle(
                                  color: brightPrimaryColor, fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        // color: mainBackgroundColor,
                        color: Colors.white,
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
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                onTap: () =>
                                    _onReplyLikePressed(commentIndex, index),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: GetBuilder<CommunityController>(
                                    builder: (_) {
                                      return Center(
                                        child: LikeIcon(
                                          color: _.postCommentList[commentIndex]
                                                  ['replies'][index]['liked']
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
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                                onTap: () => _onMenuPressed(
                                    replyList[index]['user_data']['username'] ==
                                        AuthController.to.userInfo['username'],
                                    replyList[index]['reply_data']['id'],
                                    'post_comment_reply'),
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
                    replyList[index]['reply_data']['content'],
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
                        replyList[index]['reply_data']['created_at'],
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
                          replyList[index]['reply_count']['count_likes']
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
        ],
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
                          _.postCount['count_comments'].toString(),
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
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: LoadingCommentBlock(),
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
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Header(
                  onPressed: _onBackPressed,
                  title: (postTypeIntToStr[controller.postType] ?? '') + ' 게시판',
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: clearBlackColor,
                      ),
                      splashRadius: 20,
                      onPressed: () => _onMenuPressed(
                          controller.postContent['user_data']['username'] ==
                              AuthController.to.userInfo['username'],
                          controller.postId!,
                          'post'),
                    ),
                  ],
                ),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.postRefreshController,
                    onRefresh: controller.onPostRefresh,
                    header: const MaterialClassicHeader(
                      color: brightPrimaryColor,
                    ),
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      controller: controller.postScrollController,
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
