import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentPreviewBuilder extends StatelessWidget {
  final int postType;
  final int index;
  const ContentPreviewBuilder(
      {Key? key, required this.postType, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(
      builder: (_) {
        return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              _.getPost(_.contentList[index]['post_data']['id']);
              _.getPostComments(_.contentList[index]['post_data']['id']);
              Get.toNamed('/community/post',
                  arguments: _.contentList[index]['post_data']['id']);
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
                          _.contentList[index]['post_data']['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: darkPrimaryColor,
                          ),
                        ),
                        Text(
                          _.contentList[index]['post_data']['creation_date'],
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
                      child: Text(
                        _.contentList[index]['post_data']['content'],
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 12,
                          color: deepGrayColor,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: deepGrayColor,
                              radius: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                _.contentList[index]['user_data']['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            LikeIcon(),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                _.contentList[index]['count']['count_likes']
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ),
                            horizontalSpacer(10),
                            CommentIcon(),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                _.contentList[index]['count']['count_comments']
                                    .toString(),
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
