import 'dart:async';

import 'package:exon_app/core/services/exercise_api_service.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  static HomeController to = Get.find();
  DateTime currentDateTime = DateTime.now();
  DateTime currentDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  Timer? currentTimeCounter;
  int totalExerciseTime = 0;
  bool loading = false;
  String weekDay = '';
  String currentMD = '';
  List<dynamic> todayExercisePlanList = [];
  List<dynamic> todayExerciseRecordList = [];
  ColorTheme theme = ColorTheme.day;

  @override
  void onInit() {
    if (currentDateTime.hour < 18 && currentDateTime.hour > 5) {
      theme = ColorTheme.day;
    } else {
      theme = ColorTheme.night;
    }
    currentMD = DateFormat.Md().format(currentDateTime);
    weekDay = DateFormat.E('ko_KR').format(currentDateTime);
    Future.delayed(Duration.zero, () => getTodayExerciseStatus());
    currentTimeCounter = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        DateTime previousTime = currentDateTime;
        currentDateTime = currentDateTime.add(const Duration(seconds: 1));
        if (previousTime.day != currentDateTime.day) {
          getTodayExerciseStatus();
          currentDay = currentDateTime;
        }
        if (currentDateTime.hour < 18 && currentDateTime.hour > 5) {
          if (theme == ColorTheme.night) {
            theme = ColorTheme.day;
          }
        } else {
          if (theme == ColorTheme.day) {
            theme = ColorTheme.night;
          }
        }
      },
    );
    update();
    super.onInit();
  }

  @override
  void onClose() {
    if (currentTimeCounter != null) {
      currentTimeCounter!.cancel();
    }
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void updateSelectedDay(DateTime day) {
    selectedDay = day;
    update();
    getDailyExerciseStatus();
  }

  Future<void> getTodayExerciseStatus() async {
    setLoading(true);
    DateTime now = DateTime.now();

    var res = await ExerciseApiService.getExerciseStatusDate(now);
    if (res != null) {
      todayExercisePlanList = res['plans'];
      todayExerciseRecordList = res['records'];
      totalExerciseTime = res['total_exercise_time'];
    }
    update();
    setLoading(false);
  }

  Future<void> getDailyExerciseStatus() async {
    setLoading(true);
    var res = await ExerciseApiService.getExerciseStatusDate(selectedDay);
    if (res != null) {
      todayExercisePlanList = res['plans'];
      todayExerciseRecordList = res['records'];
    }
    update();
    setLoading(false);
  }
}
