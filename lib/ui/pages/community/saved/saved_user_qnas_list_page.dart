import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SavedUserQnasListPage extends GetView<CommunityController> {
  const SavedUserQnasListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.savedUserQnasList.isEmpty) {
        controller.savedUserQnasRefreshController.requestRefresh();
      }
    });

    return GetBuilder<CommunityController>(
      builder: (_) {
        return SmartRefresher(
          controller: _.savedUserQnasRefreshController,
          onRefresh: _.onSavedUserQnasRefresh,
          header: const CustomRefreshHeader(),
          child: ListView.separated(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return QnaContentPreviewBuilder(
                  displaySolved: true, data: _.savedUserQnasList[index]);
            },
            separatorBuilder: (context, index) => const Divider(
              color: lightGrayColor,
              thickness: 0.5,
              height: 0.5,
            ),
            itemCount: _.savedUserQnasList.length,
          ),
        );
      },
    );
  }
}
