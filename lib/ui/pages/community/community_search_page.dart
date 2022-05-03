import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_search_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunitySearchPage extends GetView<CommunitySearchController> {
  const CommunitySearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.searchTextController.text == '') {
        FocusScope.of(context).requestFocus(controller.searchFieldFocus);
      }
    });

    void _onCancelPressed() {
      controller.searchFieldFocus.unfocus();
      controller.reset();
      Get.back();
    }

    void _onFieldSubmitted(String inputText) {
      controller.searchFieldFocus.unfocus();
      controller.search();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchHeader(
        focusNode: controller.searchFieldFocus,
        controller: controller.searchTextController,
        onFieldSubmitted: _onFieldSubmitted,
        onCancelPressed: _onCancelPressed,
      ),
      body: SafeArea(
        child: GetBuilder<CommunitySearchController>(builder: (_) {
          if (_.loading) {
            return const LoadingIndicator(
              icon: true,
            );
          }
          if (_.searchResultList == null) {
            return SizedBox(
              height: context.height - 56,
              width: context.width,
              child: Column(
                children: [
                  verticalSpacer(100),
                  const SearchCharacter(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      searchCategoryIntToStr[_.searchCategory]! + '의 글을 검색해보세요',
                      style: const TextStyle(
                        color: deepGrayColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (_.searchResultList!.isEmpty) {
            return SizedBox(
              height: context.height - 56,
              width: context.width,
              child: Column(
                children: [
                  verticalSpacer(100),
                  const BlankSearchCharacter(),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '검색 결과가 없습니다',
                      style: TextStyle(
                        color: deepGrayColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) {
                if (_.searchCategory < 4) {
                  return PostContentPreviewBuilder(
                      displayType: true, data: _.searchResultList![index]);
                } else {
                  return QnaContentPreviewBuilder(
                      displaySolved: true, data: _.searchResultList![index]);
                }
              },
              separatorBuilder: (context, index) => const Divider(
                color: lightGrayColor,
                thickness: 0.5,
                height: 0.5,
              ),
              itemCount: _.searchResultList!.length,
            );
          }
        }),
      ),
    );
  }
}
