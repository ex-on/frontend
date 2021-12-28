import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsController extends GetxController with SingleGetTickerProviderMixin {
  static StatsController to = Get.find<StatsController>();
  TabController? cumulativeStatsTabController;
  TabController? byPeriodStatsTabController;
  int page = 0;
  int currentCumulativeExerciseIndex = 0;
  DateTime selectedDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    cumulativeStatsTabController = TabController(length: 2, vsync: this);
    byPeriodStatsTabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    if (cumulativeStatsTabController != null) {
      cumulativeStatsTabController!.dispose();
    }
    if (byPeriodStatsTabController != null) {
      byPeriodStatsTabController!.dispose();
    }
    super.onClose();
  }

  void jumpToPage(int val) {
    page = val;
    print(val);
    update();
  }

  void updateCurrentCumulativeExerciseIndex(int index) {
    currentCumulativeExerciseIndex = index;
    update();
  }

  void updateSelectedDate(DateTime dateTime) {
    selectedDate = dateTime;
    update();
  }
}
