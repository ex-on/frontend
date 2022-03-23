import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SavedUserCommentedPostsListPage extends GetView<CommunityController> {
  const SavedUserCommentedPostsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.savedUserCommentedPostsList.isEmpty) {
        controller.savedUserCommentedPostsRefreshController.requestRefresh();
      }
    });

    return GetBuilder<CommunityController>(
      builder: (_) {
        return SmartRefresher(
          controller: _.savedUserCommentedPostsRefreshController,
          onRefresh: _.onSavedUserCommentedPostsRefresh,
          header: const CustomRefreshHeader(),
          child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return PostCommentContentPreviewBuilder(
                    displayType: true,
                    data: _.savedUserCommentedPostsList[index]);
              },
              separatorBuilder: (context, index) => const Divider(
                    color: lightGrayColor,
                    thickness: 0.5,
                    height: 0.5,
                  ),
              itemCount: _.savedUserCommentedPostsList.length),
        );
      },
    );
  }
}
