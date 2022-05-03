import 'dart:developer';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkedPostsListPage extends GetView<CommunityController> {
  const BookmarkedPostsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.bookmarkedPostsList.isEmpty) {
        controller.bookmarkedPostsRefreshController.requestRefresh();
      }
    });

    return GetBuilder<CommunityController>(
      builder: (_) {
        print(_.postRefreshController.isRefresh);
        inspect(_.postRefreshController.headerStatus);
        return SmartRefresher(
          controller: _.bookmarkedPostsRefreshController,
          onRefresh: _.onBookmarkedPostsRefresh,
          header: const CustomRefreshHeader(),
          child: (_.bookmarkedPostsList.isEmpty &&
                  !_.loading)
              ? const Center(
                  child: Text('북마크가 없습니다'),
                )
              : ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return PostContentPreviewBuilder(
                        displayType: true, data: _.bookmarkedPostsList[index]);
                  },
                  separatorBuilder: (context, index) => const Divider(
                        color: lightGrayColor,
                        thickness: 0.5,
                        height: 0.5,
                      ),
                  itemCount: _.bookmarkedPostsList.length),
        );
      },
    );
  }
}
