import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/core/controllers/community_search_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/custom_refresh_footer.dart';
import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/content_preview_builder.dart';
import 'package:exon_app/ui/widgets/community/floating_write_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class QnaListPage extends StatelessWidget {
  const QnaListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<CommunityController>(CommunityController());

    Future.delayed(Duration.zero, () {
      if (controller.qnaContentList.isEmpty || controller.qnaListInitialLoad) {
        controller.qnaListRefreshController.requestRefresh();
        controller.setQnaListInitialLoad(false);
      }
    });

    void _onBackPressed() {
      controller.resetPostContent();
      controller.qnaCategoryRefreshController.requestRefresh();
      Get.back();
    }

    void _onWritePressed() {
      controller.resetQnaWrite();
      Get.toNamed('community/qna/write');
    }

    void _onScrollUpPressed() {
      controller.qnaListScrollController.animateTo(0,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    }

    void _onSearchPressed() {
      late int _searchCategory;
      switch (controller.postCategory.value) {
        case 1:
          _searchCategory = 6;
          break;
        case 2:
          _searchCategory = 7;
          break;
        default:
          _searchCategory = 5;
          break;
      }
      CommunitySearchController.to.updateSearchCategory(_searchCategory);
      Get.toNamed('/community/search');
    }

    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CommunityController>(
          builder: (_) {
            return Column(
              children: [
                Header(
                  onPressed: _onBackPressed,
                  title: (qnaCategoryIntToStr[controller.qnaCategory.value] ??
                          '') +
                      ' Q&A',
                  actions: [
                    IconButton(
                      splashRadius: 20,
                      icon: const Icon(
                        Icons.search_rounded,
                        color: darkPrimaryColor,
                        size: 30,
                      ),
                      onPressed: _onSearchPressed,
                    ),
                  ],
                ),
                Expanded(
                  child: GetBuilder<CommunityController>(
                    builder: (_) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SmartRefresher(
                            controller: _.qnaListRefreshController,
                            onRefresh: _.onQnaListRefresh,
                            onLoading: _.onQnaListLoadMore,
                            enablePullUp: true,
                            header: const CustomRefreshHeader(),
                            footer: const CustomRefreshFooter(),
                            child: ListView.separated(
                              physics: const ClampingScrollPhysics(),
                              controller: _.qnaListScrollController,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return QnaContentPreviewBuilder(
                                    displaySolved: _.qnaCategory.value == 0,
                                    data: _.qnaContentList[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: lightGrayColor,
                                thickness: 0.5,
                                height: 0.5,
                              ),
                              itemCount: _.qnaContentList.length,
                            ),
                          ),
                          Positioned(
                            child: FloatingWriteButton(
                              onPressed: _onWritePressed,
                            ),
                            bottom:
                                // 35 + context.mediaQueryPadding.bottom + 88,
                                50,
                            right: 35,
                          ),
                          Positioned(
                            bottom: 50,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linearToEaseOut,
                                  alignment: Alignment.center,
                                  transformAlignment: Alignment.center,
                                  width: _.showScrollToTopButton ? 40 : 0,
                                  height: _.showScrollToTopButton ? 40 : 0,
                                  child: FloatingIconButton(
                                    heroTag: 'scroll_up',
                                    backgroundColor: Colors.white,
                                    onPressed: _onScrollUpPressed,
                                    icon: const ScrollUpIcon(
                                        color: lightGrayColor),
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
