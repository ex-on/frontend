import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:exon_app/ui/widgets/community/saved_content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedPostQnasPage extends StatelessWidget {
  const SavedPostQnasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (CommunityController.to.savedList == null) {
        CommunityController.to.getSaved();
      }
    });

    return GetBuilder<CommunityController>(builder: (_) {
      if (_.loading) {
        return const LoadingIndicator();
      } else {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: ListView.separated(
            // controller: _.scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index == _.savedList!.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularLoadingIndicator(),
                  ),
                );
              }
              if (_.savedList![index]['post_data'] != null) {
                return PostContentPreviewBuilder(data: _.savedList![index]);
              } else if (_.savedList![index]['qna_data'] != null) {
                return QnaContentPreviewBuilder(data: _.savedList![index]);
              } else {
                return const CircularLoadingIndicator();
              }
              // return SavedContentPreviewBuilder(index: index);
            },
            separatorBuilder: (context, index) => const Divider(
              color: lightGrayColor,
              thickness: 0.5,
              height: 0.5,
            ),
            itemCount: (_.savedList == null) ? 0 : _.savedList!.length,
            // + (_.loading ? 1 : 0),
          ),
        );
      }
    });
  }
}
