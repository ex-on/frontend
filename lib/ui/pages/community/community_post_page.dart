import 'dart:ffi';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityPostPage extends GetView<CommunityController> {
  const CommunityPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int postId = Get.arguments;

    void _onBackPressed() {
      Get.back();
    }

    void _onLikePressed() {
      
    }

    void _onSavePressed() {}

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Column(
        children: [
          Header(
            color: Colors.white,
            onPressed: _onBackPressed,
            title: (postCategoryIntToStr[controller.postCategory.value] ?? '') +
                ' 게시판',
          ),
          Container(
            width: context.width,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Material(
                                    type: MaterialType.transparency,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
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
                                    _.postContent['post_count']['count_likes']
                                        .toString(),
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
                                    _.postContent['post_count']
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
                            Row(
                              children: [
                                const BookmarkIcon(),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 12),
                                  child: Text(
                                    _.postContent['post_count']['count_saved']
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
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
