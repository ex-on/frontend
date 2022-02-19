import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostContentPreviewBuilder extends StatelessWidget {
  final Map<String, dynamic> data;
  const PostContentPreviewBuilder({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(
      builder: (_) {
        return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              _.getPost(data['post_data']['id']);
              _.getPostCount(data['post_data']['id']);
              _.getPostComments(data['post_data']['id']);
              _.updatePostId(data['post_data']['id']);
              _.updatePostType(data['post_data']['type']);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activityLevelIntToStr[data['user_data']
                                  ['activity_level']]! +
                              ' ' +
                              data['user_data']['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: -1,
                          ),
                        ),
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
  const QnaContentPreviewBuilder({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(
      builder: (_) {
        return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              var id = data['qna_data']['id'];
              _.getQna(id);
              _.getQnaCount(id);
              _.getQnaAnswers(id);
              _.updateQnaId(id);
              _.updateQnaType(data['qna_data']['type']);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activityLevelIntToStr[data['user_data']
                                  ['activity_level']]! +
                              ' ' +
                              data['user_data']['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: -1,
                          ),
                        ),
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
