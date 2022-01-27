import 'package:exon_app/core/services/stats_api_service.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsController extends GetxController with SingleGetTickerProviderMixin {
  static StatsController to = Get.find<StatsController>();
  TabController? cumulativeStatsTabController;
  TabController? byPeriodStatsTabController;
  TextEditingController memoTextController = TextEditingController();
  int page = 1;
  int currentCumulativeExerciseIndex = 0;
  int weeklyStatsTouchIndex = -1;
  bool loading = false;
  bool memoSubmitActivated = false;
  DateTime selectedDate = DateTime.now();
  Map<DateTime, dynamic> monthlyExerciseDates = {};
  Map<String, dynamic> dailyExerciseStatData = {};
  Map<String, dynamic> weeklyExerciseStatData = {};

  @override
  void onInit() {
    super.onInit();
    cumulativeStatsTabController = TabController(length: 2, vsync: this);
    byPeriodStatsTabController = TabController(length: 3, vsync: this);
    getMonthlyExerciseDates();
    getDailyExerciseStats();
    getWeeklyExerciseStats();
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
    update();
  }

  void updateCurrentCumulativeExerciseIndex(int index) {
    currentCumulativeExerciseIndex = index;
    update();
  }

  void updateDailyStatsSelectedDate(DateTime dateTime) {
    selectedDate = dateTime;
    update();
    getDailyExerciseStats();
  }

  void updateWeeklyStatsSelectedDate(DateTime dateTime) {
    selectedDate = dateTime;
    update();
    getWeeklyExerciseStats();
  }

  void updateWeeklyStatsTouchIndex(int val) {
    weeklyStatsTouchIndex = val;
    update();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  Future<void> getMonthlyExerciseDates() async {
    setLoading(true);
    var resData = await StatsApiService.getMonthlyExerciseDates(selectedDate);
    for (var data in resData) {
      if (monthlyExerciseDates[dateTimeToDate(DateTime.parse(data[0]))] ==
          null) {
        monthlyExerciseDates[dateTimeToDate(DateTime.parse(data[0]))] = [
          data[1]
        ];
      } else {
        if (!monthlyExerciseDates[dateTimeToDate(DateTime.parse(data[0]))]
            .contains(data[1])) {
          monthlyExerciseDates[dateTimeToDate(DateTime.parse(data[0]))]
              .add(data[1]);
        }
      }
    }
    print(monthlyExerciseDates);
    setLoading(false);
  }

  Future<void> getDailyExerciseStats() async {
    setLoading(true);
    var resData = await StatsApiService.getDailyExerciseStats(selectedDate);
    dailyExerciseStatData = resData;
    if (dailyExerciseStatData.isNotEmpty) {
      if (dailyExerciseStatData['stats']['memo'] != '') {
        memoTextController.text = dailyExerciseStatData['stats']['memo'];
        update();
      }
    }
    setLoading(false);
  }

  Future<void> getWeeklyExerciseStats() async {
    setLoading(true);
    var resData = await StatsApiService.getWeeklyExerciseStats(
        selectedDate.firstDateOfWeek);
    weeklyExerciseStatData = resData;
    setLoading(false);
  }

  Future<void> postDailyStatsMemo() async {
    setLoading(true);
    if (memoTextController.text != '') {
      var resData = await StatsApiService.postDailyStatsMemo(
          memoTextController.text, selectedDate);
      memoTextController.clear();
    }
    getDailyExerciseStats();
    setLoading(false);
  }
}
