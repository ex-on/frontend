import 'package:exon_app/core/services/stats_api_service.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsController extends GetxController with SingleGetTickerProviderMixin {
  static StatsController to = Get.find<StatsController>();
  TabController? cumulativeStatsTabController;
  TabController? byPeriodStatsTabController;
  TextEditingController memoTextController = TextEditingController();
  int page = 1;
  int currentCumulativeExerciseIndex = 0;
  int weeklyStatsTouchIndex = -1;
  int monthlyStatsPiTouchIndex = -1;
  int monthlyStatsByWeekCategory = 0;
  bool loading = false;
  bool memoSubmitActivated = false;
  DateTime dailyStatsSelectedDate = DateTime.now();
  DateTime weeklyStatsSelectedDate = DateTime.now();
  DateTime monthlyStatsSelectedDate = DateTime.now();
  Map<DateTime, dynamic> dailyStatsMonthlyExerciseDates = {};
  Map<DateTime, dynamic> weeklyStatsMonthlyExerciseDates = {};
  Map<DateTime, dynamic> monthlyStatsMonthlyExerciseDates = {};
  Map<String, dynamic> dailyExerciseStatData = {};
  Map<String, dynamic> weeklyExerciseStatData = {};
  Map<String, dynamic> monthlyExerciseStatData = {};
  late TrackballBehavior monthlyStatsTrackballBehavior;

  @override
  void onInit() {
    super.onInit();
    cumulativeStatsTabController = TabController(length: 2, vsync: this);
    byPeriodStatsTabController = TabController(length: 3, vsync: this);
    monthlyStatsTrackballBehavior = TrackballBehavior(
      activationMode: ActivationMode.singleTap,
      enable: true,
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        color: Color(0xff7C8C97),
      ),
    );
    getDailyStatsMonthlyExerciseDates(dailyStatsSelectedDate);
    getWeeklyStatsMonthlyExerciseDates(weeklyStatsSelectedDate);
    getMonthlyStatsMonthlyExerciseDates(monthlyStatsSelectedDate);
    getDailyExerciseStats();
    getWeeklyExerciseStats();
    getMonthlyExerciseStats();
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
    dailyStatsSelectedDate = dateTime;
    update();
    getDailyExerciseStats();
  }

  void updateWeeklyStatsSelectedDate(DateTime dateTime) {
    weeklyStatsSelectedDate = dateTime;
    update();
    getWeeklyExerciseStats();
  }

  void updateMonthlyStatsSelectedDate(DateTime dateTime) {
    monthlyStatsSelectedDate = dateTime;
    update();
  }

  void updateMonthlyStatsByWeekCategory(int val) {
    monthlyStatsByWeekCategory = val;
    update();
  }

  void updateWeeklyStatsTouchIndex(int val) {
    weeklyStatsTouchIndex = val;
    update();
  }

  void updateMonthlyStatsPiTouchIndex(int val) {
    monthlyStatsPiTouchIndex = val;
    update();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  Future<void> getDailyStatsMonthlyExerciseDates(DateTime month) async {
    var resData = await StatsApiService.getMonthlyExerciseDates(month);
    for (var data in resData) {
      if (dailyStatsMonthlyExerciseDates[
              dateTimeToDate(DateTime.parse(data[0]))] ==
          null) {
        dailyStatsMonthlyExerciseDates[
            dateTimeToDate(DateTime.parse(data[0]))] = [data[1]];
      } else {
        if (!dailyStatsMonthlyExerciseDates[
                dateTimeToDate(DateTime.parse(data[0]))]
            .contains(data[1])) {
          dailyStatsMonthlyExerciseDates[
                  dateTimeToDate(DateTime.parse(data[0]))]
              .add(data[1]);
        }
      }
    }
  }

  Future<void> getWeeklyStatsMonthlyExerciseDates(DateTime month) async {
    var resData = await StatsApiService.getMonthlyExerciseDates(month);
    for (var data in resData) {
      if (weeklyStatsMonthlyExerciseDates[
              dateTimeToDate(DateTime.parse(data[0]))] ==
          null) {
        weeklyStatsMonthlyExerciseDates[
            dateTimeToDate(DateTime.parse(data[0]))] = [data[1]];
      } else {
        if (!weeklyStatsMonthlyExerciseDates[
                dateTimeToDate(DateTime.parse(data[0]))]
            .contains(data[1])) {
          weeklyStatsMonthlyExerciseDates[
                  dateTimeToDate(DateTime.parse(data[0]))]
              .add(data[1]);
        }
      }
    }
  }

  Future<void> getMonthlyStatsMonthlyExerciseDates(DateTime month) async {
    var resData = await StatsApiService.getMonthlyExerciseDates(month);
    for (var data in resData) {
      if (monthlyStatsMonthlyExerciseDates[
              dateTimeToDate(DateTime.parse(data[0]))] ==
          null) {
        monthlyStatsMonthlyExerciseDates[
            dateTimeToDate(DateTime.parse(data[0]))] = [data[1]];
      } else {
        if (!monthlyStatsMonthlyExerciseDates[
                dateTimeToDate(DateTime.parse(data[0]))]
            .contains(data[1])) {
          monthlyStatsMonthlyExerciseDates[
                  dateTimeToDate(DateTime.parse(data[0]))]
              .add(data[1]);
        }
      }
    }
  }

  Future<void> getDailyExerciseStats() async {
    setLoading(true);
    var resData =
        await StatsApiService.getDailyExerciseStats(dailyStatsSelectedDate);
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
        weeklyStatsSelectedDate.firstDateOfWeek);
    weeklyExerciseStatData = resData;
    setLoading(false);
  }

  Future<void> getMonthlyExerciseStats() async {
    setLoading(true);
    DateTime previousMonthDate = DateTime(
        monthlyStatsSelectedDate.year, monthlyStatsSelectedDate.month - 1, 1);
    var resData = await StatsApiService.getMonthlyExerciseStats(
      monthlyStatsSelectedDate,
      previousMonthDate.numWeeksInMonth,
      previousMonthDate.firstDateOfWeek,
      monthlyStatsSelectedDate.numWeeksInMonth,
      monthlyStatsSelectedDate.firstDateOfMonth.firstDateOfWeek,
    );
    monthlyExerciseStatData = resData;
    setLoading(false);
  }

  Future<void> postDailyStatsMemo() async {
    setLoading(true);
    if (memoTextController.text != '') {
      var resData = await StatsApiService.postDailyStatsMemo(
          memoTextController.text, dailyStatsSelectedDate);
      memoTextController.clear();
    }
    getDailyExerciseStats();
    setLoading(false);
  }
}
