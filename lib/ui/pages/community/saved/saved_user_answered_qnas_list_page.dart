import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SavedUserAnsweredQnasListPage extends GetView<CommunityController> {
  const SavedUserAnsweredQnasListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.savedUserAnsweredQnasList.isEmpty) {
        controller.savedUserAnsweredQnasRefreshController.requestRefresh();
      }
    });

    return GetBuilder<CommunityController>(
      builder: (_) {
        return SmartRefresher(
          controller: _.savedUserAnsweredQnasRefreshController,
          onRefresh: _.onSavedUserAnsweredQnasRefresh,
          header: const CustomRefreshHeader(),
          child: (_.savedUserAnsweredQnasList.isEmpty && !_.loading)
              ? const Center(
                  child: Text('답변한 질문이 없습니다'),
                )
              : ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return QnaAnswerContentPreviewBuilder(
                        displaySolved: true,
                        data: _.savedUserAnsweredQnasList[index]);
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: lightGrayColor,
                    thickness: 0.5,
                    height: 0.5,
                  ),
                  itemCount: _.savedUserAnsweredQnasList.length,
                ),
        );
      },
    );
  }
}
