import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityPostListPage extends StatelessWidget {
  const CommunityPostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<CommunityController>(CommunityController());

    controller.listPage.listen((val) {
      controller.listPageCallback(val);
    });

    void _onBackPressed() {
      controller.resetContent();
      Get.back();
      controller.callback(controller.postCategory.value);
    }

    return Scaffold(
      body: Column(
        children: [
          Header(
            onPressed: _onBackPressed,
            title: (postCategoryIntToStr[controller.postCategory.value] ?? '') +
                ' 게시판',
          ),
          Expanded(
            child: GetBuilder<CommunityController>(builder: (_) {
              if (_.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: brightPrimaryColor),
                );
              } else {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  controller: _.scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return ContentPreviewBuilder(postType: 0, index: index);
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: lightGrayColor,
                    thickness: 0.5,
                    height: 0.5,
                  ),
                  itemCount: _.contentList.length,
                );
              }
            }),
          ),
          GetBuilder<CommunityController>(
            builder: (_) {
              if (_.listPageLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(color: brightPrimaryColor),
                  ),
                );
              } else {
                return horizontalSpacer(0);
              }
            },
          ),
        ],
      ),
    );
  }
}
