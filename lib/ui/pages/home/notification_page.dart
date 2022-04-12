import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/core/controllers/notification_controller.dart';
import 'package:exon_app/ui/widgets/common/circle.dart';
import 'package:exon_app/ui/widgets/common/custom_refresh_footer.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/community/loading_blocks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (controller.notificationData.isEmpty && !controller.loading) {
        controller.setLoading(true);
        await controller.getNotifications();
        controller.setLoading(false);
      }
      controller.notificationData['list']
          .where((item) => item['link_id'] == null)
          .forEach((item) {
        controller.markNotificationAsReadNoUpdate(item['id']);
      });
    });

    void _onBackPressed() {
      Get.back();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<NotificationController>(builder: (_) {
          return Column(
            children: [
              NotificationHeader(
                onPressed: _onBackPressed,
                numNotifications: _.notificationData['unread'],
              ),
              Expanded(
                child: SmartRefresher(
                  controller: _.notificationRefreshController,
                  onRefresh: _.onNotificationRefresh,
                  onLoading: _.onNotificationLoadMore,
                  enablePullUp: true,
                  footer: const CustomRefreshFooter(),
                  header: const MaterialClassicHeader(
                    color: brightPrimaryColor,
                  ),
                  child: () {
                    if (_.loading) {
                      return const LoadingCommentBlock();
                    } else {
                      return ListView.separated(
                        controller: _.notificationListScrollController,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> _data =
                              _.notificationData['list'][index];
                          return NotificationContentBuilder(
                            data: _data,
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: lightGrayColor,
                        ),
                        itemCount: _.notificationData['list'].length,
                      );
                    }
                  }(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class NotificationContentBuilder extends GetView<NotificationController> {
  final Map<String, dynamic> data;
  const NotificationContentBuilder({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onTap() {
      if (data['type'] == 2) {
        CommunityController.to
            .onPostPageInit(data['link_id'], data['post_type']);
        Get.toNamed('/community/post');
        controller.markNotificationAsRead(data['id']);
      } else if (data['type'] == 3) {
        CommunityController.to
            .onQnaPageInit(data['link_id'], data['qna_solved']);
        Get.toNamed('/community/qna');
        controller.markNotificationAsRead(data['id']);
      }
    }

    void _onDeletePressed() async {
      bool success = await controller.deleteNotification(data['id']);

      if (success) {
        Get.back();
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text(
              '알림을 성공적으로 삭제했습니다',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            borderRadius: 10,
            margin: const EdgeInsets.only(left: 10, right: 10),
            duration: const Duration(seconds: 2),
            isDismissible: false,
            backgroundColor: darkSecondaryColor.withOpacity(0.8),
          ),
        );
      }
    }

    void _onLongPress() {
      Get.bottomSheet(
        CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: _onDeletePressed,
              child: const Text(
                '삭제',
                style: TextStyle(
                  color: cancelRedColor,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Get.back(),
            child: const Text(
              '취소',
              style: TextStyle(
                color: clearBlackColor,
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: _onTap,
      onLongPress: _onLongPress,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: !data['read']
              ? brightPrimaryColor.withOpacity(0.07)
              : Colors.transparent,
        ),
        child: SizedBox(
          height: 88,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Circle(
                    borderColor: brightPrimaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Center(
                        child: Builder(
                          builder: (context) {
                            if (data['title'].contains('⚡️')) {
                              int _endIndex = data['title'].indexOf(' 프로틴');
                              return FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  data['title'].substring(1, _endIndex) + 'P',
                                  style: const TextStyle(
                                    color: brightPrimaryColor,
                                    fontSize: 15,
                                  ),
                                ),
                              );
                            } else if (data['type'] == 2 || data['type'] == 3) {
                              return const ExonIconLogo(
                                color: brightPrimaryColor,
                                width: 15,
                                height: 15,
                              );
                            } else if (data['type'] == 4) {
                              return const Text(
                                '🎉',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              );
                            } else {
                              return const Icon(Icons.notifications_rounded);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                horizontalSpacer(15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(builder: (context) {
                      if (data['title'].contains('⚡️')) {
                        int _endIndex = data['title'].indexOf('프로틴') + 3;
                        return Text.rich(TextSpan(
                            text: data['title'].substring(0, _endIndex),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: brightPrimaryColor,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: data['title'].substring(_endIndex),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: deepGrayColor,
                                  fontSize: 13,
                                ),
                              ),
                            ]));
                      } else {
                        return Text(
                          data['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: deepGrayColor,
                            fontSize: 13,
                          ),
                        );
                      }
                    }),
                    Text(
                      data['body'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: deepGrayColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      data['created_at'],
                      style: const TextStyle(
                        color: deepGrayColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
