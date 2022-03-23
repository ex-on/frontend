import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostContentPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool displayType;
  const PostContentPreviewBuilder({
    Key? key,
    required this.data,
    this.displayType = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(
      builder: (_) {
        return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              _.onPostPageInit(
                  data['post_data']['id'], data['post_data']['type']);
              Get.toNamed('/community/post');
            },
            child: SizedBox(
              height: 100,
              width: context.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['post_data']['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: darkPrimaryColor,
                          ),
                        ),
                        Text(
                          data['post_data']['created_at'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: -1,
                            color: darkPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 30,
                        ),
                        child: Text(
                          data['post_data']['content'],
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: deepGrayColor,
                          ),
                        ),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          displayType
                              ? Text(
                                  postTypeIntToStr[data['post_data']['type']]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: deepGrayColor,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          displayType
                              ? const VerticalDivider(
                                  color: deepGrayColor,
                                  width: 15,
                                  thickness: 1,
                                  indent: 3,
                                  endIndent: 3,
                                )
                              : const SizedBox.shrink(),
                          Text(
                            activityLevelIntToStr[data['user_data']
                                    ['activity_level']]! +
                                ' ' +
                                data['user_data']['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: darkPrimaryColor,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Row(
                            children: [
                              const LikeIcon(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  data['count']['count_likes'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                              ),
                              horizontalSpacer(10),
                              const CommentIcon(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  data['count']['count_comments'].toString(),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PostCommentContentPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool displayType;
  const PostCommentContentPreviewBuilder({
    Key? key,
    required this.data,
    this.displayType = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(
      builder: (_) {
        return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              _.onPostPageInit(
                  data['post_data']['id'], data['post_data']['type']);
              Get.toNamed('/community/post');
            },
            child: SizedBox(
              height: 170,
              width: context.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['post_data']['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: darkPrimaryColor,
                          ),
                        ),
                        Text(
                          data['post_data']['created_at'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: -1,
                            color: darkPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 30,
                        ),
                        child: Text(
                          data['post_data']['content'],
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: deepGrayColor,
                          ),
                        ),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          displayType
                              ? Text(
                                  postTypeIntToStr[data['post_data']['type']]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: deepGrayColor,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          displayType
                              ? const VerticalDivider(
                                  color: deepGrayColor,
                                  width: 15,
                                  thickness: 1,
                                  indent: 3,
                                  endIndent: 3,
                                )
                              : const SizedBox.shrink(),
                          Text(
                            activityLevelIntToStr[data['user_data']
                                    ['activity_level']]! +
                                ' ' +
                                data['user_data']['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: darkPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: mainBackgroundColor,
                      ),
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.fromLTRB(15, 15, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    '내 댓글',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: darkPrimaryColor,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      data['comment'],
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: darkPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 9),
                            child: Row(
                              children: [
                                const LikeIcon(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    data['comment_count']['count_likes']
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class QnaContentPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool displaySolved;
  const QnaContentPreviewBuilder({
    Key? key,
    required this.data,
    this.displaySolved = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(
      builder: (_) {
        return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              _.onQnaPageInit(
                  data['qna_data']['id'], data['qna_data']['solved']);
              Get.toNamed('/community/qna');
            },
            child: SizedBox(
              height: 100,
              width: context.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['qna_data']['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: darkPrimaryColor,
                          ),
                        ),
                        Text(
                          data['qna_data']['created_at'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: -1,
                            color: darkPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 30,
                        ),
                        child: Text(
                          data['qna_data']['content'],
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: deepGrayColor,
                          ),
                        ),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          displaySolved
                              ? Text(
                                  qnaSolvedBoolToStr[data['qna_data']
                                      ['solved']]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: deepGrayColor,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          displaySolved
                              ? const VerticalDivider(
                                  color: deepGrayColor,
                                  width: 15,
                                  thickness: 1,
                                  indent: 3,
                                  endIndent: 3,
                                )
                              : const SizedBox.shrink(),
                          Text(
                            data['qna_data']['solved'] == true
                                ? (activityLevelIntToStr[
                                        data['selected_user_data']
                                            ['activity_level']]! +
                                    ' ' +
                                    data['selected_user_data']['username'] +
                                    (hasBottomConsonant(
                                            data['selected_user_data']
                                                ['username'])
                                        ? '이'
                                        : '가') +
                                    ' 채택됨')
                                : ('답변 ' +
                                    data['count']['count_answers'].toString()),
                            // activityLevelIntToStr[data['user_data']
                            //         ['activity_level']]! +
                            //     ' ' +
                            //     data['user_data']['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Row(
                            children: [
                              const LikeIcon(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  data['count']['count_likes'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: darkPrimaryColor,
                                  ),
                                ),
                              ),
                              horizontalSpacer(10),
                              const CommentIcon(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  data['count']['count_answers'].toString(),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class QnaAnswerContentPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool displaySolved;
  const QnaAnswerContentPreviewBuilder({
    Key? key,
    required this.data,
    this.displaySolved = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(
      builder: (_) {
        return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              _.onQnaPageInit(
                  data['qna_data']['id'], data['qna_data']['solved']);
              Get.toNamed('/community/qna');
            },
            child: SizedBox(
              height: 170,
              width: context.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['qna_data']['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: darkPrimaryColor,
                          ),
                        ),
                        Text(
                          data['qna_data']['created_at'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: -1,
                            color: darkPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 30,
                        ),
                        child: Text(
                          data['qna_data']['content'],
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: deepGrayColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: mainBackgroundColor,
                      ),
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    '내 답변',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: darkPrimaryColor,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      data['answer'],
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: darkPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 9),
                            child: Row(
                              children: [
                                const LikeIcon(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    data['answer_count']['count_likes']
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
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    data['answer_count']['count_comments']
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
