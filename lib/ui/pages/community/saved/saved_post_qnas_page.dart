import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/common/index_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SavedPostQnasPage extends GetView<CommunityController> {
  const SavedPostQnasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () {
        if (controller.savedData.isEmpty) {
          controller.getSaved();
        }
      },
    );

    void _onExpandBookmarkPressed() {
      Get.toNamed('/community/saved/bookmarks');
    }

    void _onExpandPostActivityPressed() {
      Get.toNamed('/community/saved/post_activity');
    }

    void _onExpandQnaActivityPressed() {
      Get.toNamed('/community/saved/qna_activity');
    }

    void _onBookmarkedPostTap(int index) {
      controller.onPostPageInit(
          controller.savedData['saved_posts'][index]['post_data']['id'],
          controller.savedData['saved_posts'][index]['post_data']['type']);
      Get.toNamed('/community/post');
    }

    void _onPostActivityPostTap(int index) {
      if (controller.postActivityCategory == 0) {
        controller.onPostPageInit(
            controller.savedData['post_activity']['user_posts'][index]
                ['post_data']['id'],
            controller.savedData['post_activity']['user_posts'][index]
                ['post_data']['type']);
      } else {
        controller.onPostPageInit(
            controller.savedData['post_activity']['user_commented_posts'][index]
                ['post_data']['id'],
            controller.savedData['post_activity']['user_commented_posts'][index]
                ['post_data']['type']);
      }
      Get.toNamed('/community/post');
    }

    void _onQnaActivityQnaTap(int index) {
      if (controller.qnaActivityCategory == 0) {
        controller.onQnaPageInit(
            controller.savedData['qna_activity']['user_qnas'][index]['qna_data']
                ['id'],
            controller.savedData['qna_activity']['user_qnas'][index]['qna_data']
                ['solved']);
      } else {
        controller.onQnaPageInit(
            controller.savedData['qna_activity']['user_answered_qnas'][index]
                ['qna_data']['id'],
            controller.savedData['qna_activity']['user_answered_qnas'][index]
                ['qna_data']['solved']);
      }
      Get.toNamed('/community/qna');
    }

    return GetBuilder<CommunityController>(
      builder: (_) {
        return SmartRefresher(
          controller: _.savedRefreshController,
          onRefresh: _.onSavedRefresh,
          header: const CustomRefreshHeader(),
          child: ListView(
            padding: EdgeInsets.only(
                top: 10, bottom: context.mediaQueryPadding.bottom),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  children: [
                    const Text(
                      '북마크한 글',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, right: 10),
                      child: BookmarkIcon(),
                    ),
                    TextActionButton(
                      buttonText: '게시글',
                      onPressed: () => controller.updateBookmarkCategory(0),
                      isUnderlined: false,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: _.bookmarkCategory == 0
                          ? brightPrimaryColor
                          : deepGrayColor,
                    ),
                    TextActionButton(
                      buttonText: 'Q&A',
                      onPressed: () => _.updateBookmarkCategory(1),
                      isUnderlined: false,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: _.bookmarkCategory == 1
                          ? brightPrimaryColor
                          : deepGrayColor,
                    ),
                    const Expanded(child: SizedBox()),
                    TextActionButton(
                      buttonText: '전체보기',
                      onPressed: _onExpandBookmarkPressed,
                      fontSize: 13,
                      textColor: deepGrayColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Builder(
                  builder: (context) {
                    if (_.savedData.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            '북마크를 불러오는 중이에요...',
                            style: TextStyle(
                              height: 2,
                              color: deepGrayColor,
                            ),
                          ),
                        ),
                      );
                    } else {
                      if ((_.bookmarkCategory == 0 &&
                              _.savedData['saved_posts'].length == 0) ||
                          (_.bookmarkCategory == 1 &&
                              _.savedData['saved_qnas'].length == 0)) {
                        return const Center(
                          child: Text(
                            '북마크가 없습니다',
                            style: TextStyle(
                              height: 2,
                              color: deepGrayColor,
                            ),
                          ),
                        );
                      } else {
                        Future.delayed(Duration.zero, () {
                          if (controller.bookmarkPageController.hasClients) {
                            if (controller.bookmarkCategory == 0) {
                              controller.bookmarkPageController
                                  .jumpToPage(controller.bookmarkedPostIndex);
                            } else {
                              controller.bookmarkPageController
                                  .jumpToPage(controller.bookmarkedQnaIndex);
                            }
                          }
                        });
                        return SizedBox(
                          height: 130,
                          width: context.width - 40,
                          child: PageView.builder(
                            controller: _.bookmarkPageController,
                            itemCount: _.bookmarkCategory == 0
                                ? _.savedData['saved_posts'].length
                                : _.savedData['saved_qnas'].length,
                            onPageChanged: _.bookmarkCategory == 0
                                ? _.updateBookmarkedPostIndex
                                : _.updateBookmarkedQnaIndex,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              Map<String, dynamic> _data =
                                  _.bookmarkCategory == 0
                                      ? _.savedData['saved_posts'][index]
                                      : _.savedData['saved_qnas'][index];

                              Map<String, dynamic> _contentData =
                                  _.bookmarkCategory == 0
                                      ? _data['post_data']
                                      : _data['qna_data'];
                              bool _isPost = _.bookmarkCategory == 0;

                              return Container(
                                width: context.width - 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: mainBackgroundColor,
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () => _onBookmarkedPostTap(index),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  _contentData['title'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _contentData['created_at'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: darkPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _contentData['content'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: deepGrayColor,
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Text(
                                                  _isPost
                                                      ? postTypeIntToStr[
                                                          _contentData['type']]!
                                                      : qnaSolvedBoolToStr[
                                                          _contentData[
                                                              'solved']]!,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: deepGrayColor,
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  color: deepGrayColor,
                                                  thickness: 1,
                                                  width: 15,
                                                  indent: 3,
                                                  endIndent: 3,
                                                ),
                                                Text(
                                                  activityLevelIntToStr[_data[
                                                              'user_data']
                                                          ['activity_level']]! +
                                                      ' ' +
                                                      _data['user_data']
                                                          ['username'],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: deepGrayColor,
                                                  ),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                const LikeIcon(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    _data['count']
                                                            ['count_likes']
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: darkPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                                horizontalSpacer(10),
                                                const CommentIcon(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    _isPost
                                                        ? _data['count'][
                                                                'count_comments']
                                                            .toString()
                                                        : _data['count'][
                                                                'count_answers']
                                                            .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: darkPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              IndexIndicator(
                currentIndex: _.bookmarkCategory == 0
                    ? _.bookmarkedPostIndex
                    : _.bookmarkedQnaIndex,
                totalLength: _.savedData.isEmpty
                    ? 0
                    : (_.bookmarkCategory == 0
                        ? _.savedData['saved_posts'].length
                        : _.savedData['saved_qnas'].length),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    const Text(
                      '게시판 활동',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    horizontalSpacer(10),
                    TextActionButton(
                      buttonText: '내가 쓴 글',
                      onPressed: () => _.updatePostActivityCategory(0),
                      isUnderlined: false,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: _.postActivityCategory == 0
                          ? brightPrimaryColor
                          : deepGrayColor,
                    ),
                    TextActionButton(
                      buttonText: '댓글 단 글',
                      onPressed: () => _.updatePostActivityCategory(1),
                      isUnderlined: false,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: _.postActivityCategory == 1
                          ? brightPrimaryColor
                          : deepGrayColor,
                    ),
                    const Expanded(child: SizedBox()),
                    TextActionButton(
                      buttonText: '전체보기',
                      onPressed: _onExpandPostActivityPressed,
                      fontSize: 13,
                      textColor: deepGrayColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Builder(
                  builder: (context) {
                    if (_.savedData.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            '게시판 활동 내역을 불러오는 중이에요...',
                            style: TextStyle(
                              height: 2,
                              color: deepGrayColor,
                            ),
                          ),
                        ),
                      );
                    } else {
                      if (_.postActivityCategory == 0 &&
                          _.savedData['post_activity']['user_posts'].length ==
                              0) {
                        return const Center(
                          child: Text(
                            '쓴 글이 없습니다',
                            style: TextStyle(
                              height: 2,
                              color: deepGrayColor,
                            ),
                          ),
                        );
                      } else if (_.postActivityCategory == 1 &&
                          _.savedData['post_activity']['user_commented_posts']
                                  .length ==
                              0) {
                        return const Center(
                          child: Text(
                            '댓글 단 글이 없습니다',
                            style: TextStyle(
                              height: 2,
                              color: deepGrayColor,
                            ),
                          ),
                        );
                      } else {
                        Future.delayed(Duration.zero, () {
                          if (controller
                              .postActivityPageController.hasClients) {
                            if (controller.postActivityCategory == 0) {
                              controller.postActivityPageController
                                  .jumpToPage(controller.userPostsIndex);
                            } else {
                              controller.postActivityPageController.jumpToPage(
                                  controller.userCommentedPostsIndex);
                            }
                          }
                        });
                        return SizedBox(
                          height: _.postActivityCategory == 1 ? 200 : 130,
                          width: context.width - 40,
                          child: PageView.builder(
                            controller: _.postActivityPageController,
                            itemCount: _.postActivityCategory == 0
                                ? _.savedData['post_activity']['user_posts']
                                    .length
                                : _
                                    .savedData['post_activity']
                                        ['user_commented_posts']
                                    .length,
                            onPageChanged: _.postActivityCategory == 0
                                ? _.updateUserPostsIndex
                                : _.updateUserCommentedPostsIndex,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              Map<String, dynamic> _data =
                                  _.postActivityCategory == 0
                                      ? _.savedData['post_activity']
                                          ['user_posts'][index]
                                      : _.savedData['post_activity']
                                          ['user_commented_posts'][index];

                              return Container(
                                width: context.width - 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: mainBackgroundColor,
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () => _onPostActivityPostTap(index),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 20, 15, 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  _data['post_data']['title'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _data['post_data']
                                                    ['created_at'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: darkPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _data['post_data']['content'],
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: deepGrayColor,
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Text(
                                                  postTypeIntToStr[
                                                      _data['post_data']
                                                          ['type']]!,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: deepGrayColor,
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  color: deepGrayColor,
                                                  thickness: 1,
                                                  width: 15,
                                                  indent: 3,
                                                  endIndent: 3,
                                                ),
                                                Text(
                                                  activityLevelIntToStr[_data[
                                                              'user_data']
                                                          ['activity_level']]! +
                                                      ' ' +
                                                      _data['user_data']
                                                          ['username'],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: deepGrayColor,
                                                  ),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                const LikeIcon(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    _data['count']
                                                            ['count_likes']
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: darkPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                                horizontalSpacer(10),
                                                const CommentIcon(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    _data['count']
                                                            ['count_comments']
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: darkPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          _.postActivityCategory == 1
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                      top: 5),
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  constraints:
                                                      const BoxConstraints
                                                          .expand(height: 75),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        '내 댓글',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              darkPrimaryColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        _.savedData['post_activity']
                                                                [
                                                                'user_commented_posts']
                                                            [index]['comment'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              clearBlackColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              IndexIndicator(
                currentIndex: _.postActivityCategory == 0
                    ? _.userPostsIndex
                    : _.userCommentedPostsIndex,
                totalLength: _.savedData.isEmpty
                    ? 0
                    : (_.postActivityCategory == 0
                        ? _.savedData['post_activity']['user_posts'].length
                        : _.savedData['post_activity']['user_commented_posts']
                            .length),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    const Text(
                      'Q&A',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    horizontalSpacer(10),
                    TextActionButton(
                      buttonText: '내 질문',
                      onPressed: () => _.updateQnaActivityCategory(0),
                      isUnderlined: false,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: _.qnaActivityCategory == 0
                          ? brightPrimaryColor
                          : deepGrayColor,
                    ),
                    TextActionButton(
                      buttonText: '내 답변',
                      onPressed: () => _.updateQnaActivityCategory(1),
                      isUnderlined: false,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: _.qnaActivityCategory == 1
                          ? brightPrimaryColor
                          : deepGrayColor,
                    ),
                    const Expanded(child: SizedBox()),
                    TextActionButton(
                      buttonText: '전체보기',
                      onPressed: _onExpandQnaActivityPressed,
                      fontSize: 13,
                      textColor: deepGrayColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Builder(
                  builder: (context) {
                    if (_.savedData.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Q&A 활동 내역을 불러오는 중이에요...',
                            style: TextStyle(
                              height: 2,
                              color: deepGrayColor,
                            ),
                          ),
                        ),
                      );
                    } else {
                      if (_.qnaActivityCategory == 0 &&
                          _.savedData['qna_activity']['user_qnas'].length ==
                              0) {
                        return const Center(
                          child: Text(
                            '쓴 질문이 없습니다',
                            style: TextStyle(
                              height: 2,
                              color: deepGrayColor,
                            ),
                          ),
                        );
                      } else if (_.qnaActivityCategory == 1 &&
                          _.savedData['qna_activity']['user_answered_qnas']
                                  .length ==
                              0) {
                        return const Center(
                          child: Text(
                            '답변한 질문이 없습니다',
                            style: TextStyle(
                              height: 2,
                              color: deepGrayColor,
                            ),
                          ),
                        );
                      } else {
                        Future.delayed(Duration.zero, () {
                          if (controller.qnaActivityPageController.hasClients) {
                            if (controller.qnaActivityCategory == 0) {
                              controller.qnaActivityPageController
                                  .jumpToPage(controller.userQnasIndex);
                            } else {
                              controller.qnaActivityPageController
                                  .jumpToPage(controller.userAnsweredQnasIndex);
                            }
                          }
                        });
                        return SizedBox(
                          height: 180,
                          width: context.width - 40,
                          child: PageView.builder(
                            controller: _.qnaActivityPageController,
                            itemCount: _.qnaActivityCategory == 0
                                ? _.savedData['qna_activity']['user_qnas']
                                    .length
                                : _
                                    .savedData['qna_activity']
                                        ['user_answered_qnas']
                                    .length,
                            onPageChanged: _.qnaActivityCategory == 0
                                ? _.updateUserQnasIndex
                                : _.updateUserAnsweredQnasIndex,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              Map<String, dynamic> _data =
                                  _.qnaActivityCategory == 0
                                      ? _.savedData['qna_activity']['user_qnas']
                                          [index]
                                      : _.savedData['qna_activity']
                                          ['user_answered_qnas'][index];

                              bool _isUserQna = _.qnaActivityCategory == 0;

                              return Container(
                                width: context.width - 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: mainBackgroundColor,
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () => _onQnaActivityQnaTap(index),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 20, 15, 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  _data['qna_data']['title'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _data['qna_data']['created_at'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: darkPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _data['qna_data']['content'],
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: deepGrayColor,
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Text(
                                                  _isUserQna
                                                      ? qnaSolvedBoolToStr[
                                                          _data['qna_data']
                                                              ['solved']]!
                                                      : qnaSolvedBoolToStr[
                                                          _data['qna_data']
                                                              ['solved']]!,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: deepGrayColor,
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  color: deepGrayColor,
                                                  thickness: 1,
                                                  width: 15,
                                                  indent: 3,
                                                  endIndent: 3,
                                                ),
                                                Text(
                                                  _data['qna_data']['solved'] ==
                                                          true
                                                      ? (activityLevelIntToStr[_data[
                                                                  'selected_user_data']
                                                              [
                                                              'activity_level']]! +
                                                          ' ' +
                                                          _data['selected_user_data']
                                                              ['username'] +
                                                          (hasBottomConsonant(_data[
                                                                      'selected_user_data']
                                                                  ['username'])
                                                              ? '이'
                                                              : '가') +
                                                          ' 채택됨')
                                                      : ('답변 ' +
                                                          _data['count'][
                                                                  'count_answers']
                                                              .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: deepGrayColor,
                                                  ),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                if (_.qnaActivityCategory == 0)
                                                  const LikeIcon(),
                                                if (_.qnaActivityCategory == 0)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      _data['count']
                                                              ['count_likes']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: darkPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                horizontalSpacer(10),
                                                if (_.qnaActivityCategory == 0)
                                                  const CommentIcon(),
                                                if (_.qnaActivityCategory == 0)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      _data['count']
                                                              ['count_answers']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: darkPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Builder(builder: (context) {
                                            if (_.qnaActivityCategory == 0) {
                                              bool _isSolved =
                                                  _.savedData['qna_activity']
                                                          ['user_qnas'][index]
                                                      ['qna_data']['solved'];

                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                padding:
                                                    const EdgeInsets.all(15),
                                                constraints:
                                                    const BoxConstraints.expand(
                                                        height: 75),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    _isSolved
                                                        ? const Text(
                                                            '채택된 답변',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  darkSecondaryColor,
                                                            ),
                                                          )
                                                        : const Text(
                                                            '채택대기중',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  clearBlackColor,
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      width: 220,
                                                      child: Text(
                                                        _isSolved
                                                            ? _.savedData[
                                                                        'qna_activity']
                                                                    [
                                                                    'user_qnas']
                                                                [
                                                                index]['answer']
                                                            : '마음에 드는 답변이 있다면 채택해주세요.',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              clearBlackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                padding:
                                                    const EdgeInsets.all(15),
                                                constraints:
                                                    const BoxConstraints.expand(
                                                        height: 75),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          '내 답변',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                clearBlackColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 220,
                                                          child: Text(
                                                            _.savedData['qna_activity']
                                                                    [
                                                                    'user_answered_qnas']
                                                                [
                                                                index]['answer'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  clearBlackColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const LikeIcon(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: Text(
                                                            _.savedData[
                                                                    'qna_activity']
                                                                    [
                                                                    'user_answered_qnas']
                                                                    [index][
                                                                    'answer_count']
                                                                    [
                                                                    'count_likes']
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  darkPrimaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                        horizontalSpacer(10),
                                                        const CommentIcon(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: Text(
                                                            _.savedData[
                                                                    'qna_activity']
                                                                    [
                                                                    'user_answered_qnas']
                                                                    [index][
                                                                    'answer_count']
                                                                    [
                                                                    'count_comments']
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  darkPrimaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: IndexIndicator(
                  currentIndex: _.qnaActivityCategory == 0
                      ? _.userQnasIndex
                      : _.userAnsweredQnasIndex,
                  totalLength: _.savedData.isEmpty
                      ? 0
                      : (_.qnaActivityCategory == 0
                          ? _.savedData['qna_activity']['user_qnas'].length
                          : _.savedData['qna_activity']['user_answered_qnas']
                              .length),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
