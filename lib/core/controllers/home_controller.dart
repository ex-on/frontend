import 'dart:async';

import 'package:exon_app/core/controllers/connection_controller.dart';
import 'package:exon_app/core/services/exercise_api_service.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  static HomeController to = Get.find();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  DateTime currentDateTime = DateTime.now();
  DateTime currentDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  Timer? currentTimeCounter;
  int totalExerciseTime = 0;
  String weekDay = '';
  String currentMD = '';
  bool refreshModeWeek = true;
  List<dynamic> indexDayExercisePlanList = [];
  List<dynamic> indexDayExerciseRecordList = [];
  Map<String, dynamic> weekExerciseStatus = {};
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
    Future.delayed(Duration.zero, () => refreshController.requestRefresh());
    currentTimeCounter = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        DateTime previousTime = currentDateTime;
        currentDateTime = currentDateTime.add(const Duration(seconds: 1));
        if (previousTime.day != currentDateTime.day) {
          currentDay = currentDateTime;
          updateRefreshModeWeek(false);
          refreshController.requestRefresh();
          updateRefreshModeWeek(true);
          updateSelectedDay(currentDay);
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

  void updateRefreshModeWeek(bool week) {
    refreshModeWeek = week;
  }

  void onRefresh() async {
    if (refreshModeWeek) {
      await getWeekExerciseStatus();
    } else {
      await getTodayExerciseStatus();
    }
    refreshController.refreshCompleted();
  }

  void updateSelectedDay(DateTime day) {
    selectedDay = day;
    indexDayExercisePlanList =
        weekExerciseStatus[DateFormat('yyyy/MM/dd').format(day)]['plans'];
    indexDayExerciseRecordList =
        weekExerciseStatus[DateFormat('yyyy/MM/dd').format(day)]['records'];
    update();
  }

  Future<void> getTodayExerciseStatus() async {
    ConnectionController.to.updateRefreshCategory(3);
    DateTime now = DateTime.now();

    var res = await ExerciseApiService.getExerciseStatusDate(now);
    if (res != null) {
      weekExerciseStatus[DateFormat('yyyy/MM/dd').format(currentDay)] = {
        'plans': res['plans'],
        'records': res['records'],
      };
      indexDayExercisePlanList = res['plans'];
      indexDayExerciseRecordList = res['records'];
      totalExerciseTime = res['total_exercise_time'];
    }
    update();
  }

  Future<void> getWeekExerciseStatus() async {
    ConnectionController.to.updateRefreshCategory(3);
    var res = await ExerciseApiService.getExerciseStatusWeek(selectedDay);
    if (res != null) {
      weekExerciseStatus = res;
      totalExerciseTime = res[DateFormat('yyyy/MM/dd').format(currentDay)]
          ['total_exercise_time'];
      indexDayExercisePlanList =
          weekExerciseStatus[DateFormat('yyyy/MM/dd').format(currentDay)]
              ['plans'];
      indexDayExerciseRecordList =
          weekExerciseStatus[DateFormat('yyyy/MM/dd').format(currentDay)]
              ['records'];
    }
    update();
  }
}
