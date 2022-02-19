import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/services/stats_api_service.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsController extends GetxController with SingleGetTickerProviderMixin {
  static StatsController to = Get.find<StatsController>();
  TabController? cumulativeStatsTabController;
  TabController? byPeriodStatsTabController;
  TextEditingController memoTextController = TextEditingController();
  int page = 1;
  Map<String, dynamic> selectedExerciseInfo = {};
  int currentCumulativeExerciseIndex = 0;
  int weeklyStatsTouchIndex = -1;
  int monthlyStatsPiTouchIndex = -1;
  int cumulativeExerciseStatsPiTouchIndex = -1;
  int monthlyStatsByWeekCategory = 0;
  bool loading = false;
  bool memoSubmitActivated = false;
  DateTime displayDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  Map<DateTime, dynamic> monthlyExerciseDates = {};
  Map<String, dynamic> dailyExerciseStatData = {};
  Map<String, dynamic> weeklyExerciseStatData = {};
  Map<String, dynamic> monthlyExerciseStatData = {};
  late TrackballBehavior monthlyStatsTrackballBehavior;
  late TrackballBehavior cumulativeTimeStatsTrackballBehavior;
  late ZoomPanBehavior cumulativeTimeStatsZoomPanBehavior;
  Map<String, dynamic> cumulativeTimeStatData = {};
  Map<String, dynamic> cumulativeExerciseStatData = {};
  Map<String, dynamic> exerciseStatData = {};

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
    cumulativeTimeStatsTrackballBehavior = TrackballBehavior(
      activationMode: ActivationMode.singleTap,
      enable: true,
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        int time = trackballDetails.point!.yValue;
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(trackballDetails.point!.xValue);
        return Container(
          width: 85,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xff7C8C97),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('yyyy년\nMM월 dd일').format(date),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Text(
                formatTimeToText(time),
                style: const TextStyle(
                  fontSize: 12,
                  color: lightBrightPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
    cumulativeTimeStatsZoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
    );
    getMonthlyExerciseDates(selectedDate);
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

  void updateSelectedDate(DateTime dateTime) {
    selectedDate = dateTime;
    update();

    getDailyExerciseStats();
    getWeeklyExerciseStats();
    getMonthlyExerciseStats();
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

  void updateCumulativeExerciseStatsPiTouchIndex(int val) {
    cumulativeExerciseStatsPiTouchIndex = val;
    update();
  }

  void updateSelectedExerciseInfo(Map<String, dynamic> info) {
    selectedExerciseInfo = info;
    update();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  Future<void> getMonthlyExerciseDates(DateTime month) async {
    var resData = await StatsApiService.getMonthlyExerciseDates(month);
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

  Future<void> getMonthlyExerciseStats() async {
    setLoading(true);
    DateTime previousMonthDate =
        DateTime(selectedDate.year, selectedDate.month - 1, 1);
    var resData = await StatsApiService.getMonthlyExerciseStats(
      selectedDate,
      previousMonthDate.numWeeksInMonth,
      previousMonthDate.firstDateOfWeek,
      selectedDate.numWeeksInMonth,
      selectedDate.firstDateOfMonth.firstDateOfWeek,
    );
    monthlyExerciseStatData = resData;
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

  Future<void> getCumulativeTimeStats() async {
    setLoading(true);
    var resData = await StatsApiService.getCumulativeTimeStats();
    cumulativeTimeStatData = resData;
    setLoading(false);
  }

  Future<void> getCumulativeExerciseStats() async {
    setLoading(true);
    var resData = await StatsApiService.getCumulativeExerciseStats();
    cumulativeExerciseStatData = resData;
    setLoading(false);
  }

  Future<void> getExerciseStats() async {
    setLoading(true);
    var resData =
        await StatsApiService.getExerciseStats(selectedExerciseInfo['id']);
    exerciseStatData = resData;
    setLoading(false);
  }
}
