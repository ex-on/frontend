import 'dart:async';

import 'package:exon_app/core/services/exercise_api_service.dart';
import 'package:exon_app/dummy_data_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ExerciseBlockController extends GetxController {
  static ExerciseBlockController to = Get.find();
  Timer? totalExerciseTimeCounter;
  Timer? currentExerciseTimeCounter;
  Timer? totalRestTimeCounter;
  RxInt totalExerciseTime = RxInt(0);
  RxInt currentExerciseTime = RxInt(0);
  RxInt totalRestTime = RxInt(0);
  bool exercisePaused = false;
  List<dynamic>? exercisePlan;
  int currentSet = 1;
  int numSets = 1;
  List<dynamic> currentInputSetValues = [0, 0];
  List<dynamic>? inputSetValues;
  String? exerciseName;
  int? recommendedRestTime;
  Map<String, dynamic>? exerciseRecord;

  @override
  void onInit() async {
    super.onInit();
  }

  Timer _createCounter(RxInt time) {
    return Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (time < 0) {
          timer.cancel();
        } else {
          time++;
        }
      },
    );
  }

  void startExercise(int id, String exerciseName) {
    Get.toNamed('/exercise_block');
    exerciseName = exerciseName;
    recommendedRestTime = 30;
    if (exercisePlan != null && exercisePlan != {}) {
      numSets = exercisePlan!.length;
      totalExerciseTimeCounter = _createCounter(totalExerciseTime);
      currentExerciseTimeCounter = _createCounter(currentExerciseTime);
      currentInputSetValues = [
        exercisePlan![currentSet - 1]['target_weight']!,
        exercisePlan![currentSet - 1]['target_reps']!
      ];
      inputSetValues = [
        exercisePlan![currentSet - 1]['target_weight']!,
        exercisePlan![currentSet - 1]['target_reps']!
      ];
    }

    exerciseRecord = {
      'exercise_plan_id': id,
      'sets': [],
    };
    update();
  }

  void endExercise() {
    exerciseRecord!.addAll({
      'total_rest_time': totalRestTime,
      'exercise_time': currentExerciseTime,
    });
    DummyDataController.to.addDailyExerciseRecord(exerciseRecord!);
    print(exerciseRecord);
    reset();
  }

  void startRest() {
    currentExerciseTimeCounter!.cancel();
    totalRestTimeCounter = _createCounter(totalRestTime);
    exerciseRecord!['sets'].add(
      {
        'record_weight': inputSetValues![0],
        'record_reps': inputSetValues![1],
      },
    );
    update();
  }

  void startNextSet() {
    exercisePaused = !exercisePaused;
    currentExerciseTimeCounter = _createCounter(currentExerciseTime);
    totalRestTimeCounter!.cancel();
    currentInputSetValues = [
      exercisePlan![currentSet - 1]['target_weight']!,
      exercisePlan![currentSet - 1]['target_reps']!
    ];
    inputSetValues = [
      exercisePlan![currentSet - 1]['target_weight']!,
      exercisePlan![currentSet - 1]['target_reps']!
    ];
    update();
  }

  void updateCurrentInputSetWeight(int weight) {
    currentInputSetValues[0] = weight;
    update();
  }

  void updateCurrentInputSetReps(int reps) {
    currentInputSetValues[1] = reps;
    update();
  }

  void updateInputSetValues() {
    inputSetValues = [currentInputSetValues[0], currentInputSetValues[1]];
    update();
  }

  void completeExerciseSet() {
    exercisePaused = !exercisePaused;
    startRest();
    currentSet++;
    print(inputSetValues);
    update();
  }

  void reset() {
    currentSet = 1;
    currentInputSetValues = [0, 0];
    inputSetValues = null;
    exercisePaused = false;
    totalExerciseTimeCounter!.cancel();
    currentExerciseTimeCounter!.cancel();
    if (totalRestTimeCounter != null) {
      totalRestTimeCounter!.cancel();
    }
    totalExerciseTime.value = 0;
    currentExerciseTime.value = 0;
    totalRestTime.value = 0;
    numSets = 1;
    update();
  }

  Future<void> getExercisePlanWeightSets(int id) async {
    var res = await ExerciseApiService.getExercisePlanWeightSets(id);
    exercisePlan = res;
    update();
  }

  FixedExtentScrollController getWeightController(int setNum) {
    var item = exercisePlan![setNum - 1]['target_weight']!.toInt() - 1;
    return FixedExtentScrollController(initialItem: item);
  }

  FixedExtentScrollController getRepsController(int setNum) {
    var item = exercisePlan![setNum - 1]['target_reps']! - 1;
    return FixedExtentScrollController(initialItem: item);
  }
}
