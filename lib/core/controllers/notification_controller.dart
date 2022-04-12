import 'dart:developer';

import 'package:exon_app/core/services/notification_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationController extends GetxController {
  static NotificationController to = Get.find<NotificationController>();
  RefreshController notificationRefreshController = RefreshController();
  ScrollController notificationListScrollController = ScrollController();
  RxInt notificationListStartIndex = 0.obs;
  Map<String, dynamic> notificationData = {};
  bool loading = false;
  bool listPageLoading = false;

  @override
  void onInit() {
    super.onInit();
    notificationListScrollController.addListener(onNotificationListScroll);
  }

  @override
  void onClose() {
    notificationListScrollController.removeListener(onNotificationListScroll);
    notificationListScrollController.dispose();
  }

  void onNotificationListScroll() {
    if (notificationListScrollController.position.extentAfter < 300 &&
        !listPageLoading) {
      notificationListStartIndex.value = notificationData['list'].length;
    }
    update();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void onNotificationRefresh() async {
    notificationListStartIndex.value = 0;
    await getNotifications();
    notificationRefreshController.refreshCompleted();
  }

  void onNotificationLoadMore() async {
    await getNotifications();
    notificationRefreshController.loadComplete();
  }

  Future<void> refreshNotifications() async {
    setLoading(true);
    notificationListStartIndex.value = 0;
    await getNotifications();
    setLoading(false);
  }

  Future<void> getNotifications() async {
    var res = await NotificationApiService.getNotifications(
        notificationListStartIndex.value);
    try {
      if (notificationListStartIndex.value == 0) {
        notificationData = res;
      } else {
        inspect(res);
        notificationData['list'] = [
          ...notificationData['list'],
          ...res['list']
        ];
        notificationData['unread'] = res['unread'];
      }
    } catch (e) {}
    update();
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    bool isRead = notificationData['list']
        .firstWhere((e) => e['id'] == notificationId)['read'];
    if (!isRead) {
      var res =
          await NotificationApiService.markNotificationAsRead(notificationId);
      notificationData['list']
          .firstWhere((e) => e['id'] == notificationId)['read'] = true;
      notificationData['unread'] -= 1;
      update();
    }
  }

  Future<void> markNotificationAsReadNoUpdate(int notificationId) async {
    bool isRead = notificationData['list']
        .firstWhere((e) => e['id'] == notificationId)['read'];
    if (!isRead) {
      var res =
          await NotificationApiService.markNotificationAsRead(notificationId);
      notificationData['list']
          .firstWhere((e) => e['id'] == notificationId)['read'] = true;
      notificationData['unread'] -= 1;
    }
  }

  Future<bool> deleteNotification(int notificationId) async {
    notificationData['list'] = notificationData['list']
        .where((item) => item['id'] != notificationId)
        .toList();
    update();
    var res = await NotificationApiService.deleteNotification(notificationId);

    return res.statusCode == 200;
  }
}
