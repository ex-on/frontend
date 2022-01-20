import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:exon_app/core/services/exercise_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ExerciseBlockController extends GetxController
    with SingleGetTickerProviderMixin {
  static ExerciseBlockController to = Get.find();
  AnimationController? timerAnimationController;

  ConfettiController confettiControllerTop =
      ConfettiController(duration: const Duration(seconds: 1));
  ConfettiController confettiControllerLeft =
      ConfettiController(duration: const Duration(seconds: 1));
  ConfettiController confettiControllerRight =
      ConfettiController(duration: const Duration(seconds: 1));
  Timer? restStartHintCounter;
  Timer? totalExerciseTimeCounter;
  Timer? currentExerciseTimeCounter;
  Timer? restTimeCounter;
  RxInt totalExerciseTime = RxInt(0);
  RxInt currentExerciseTime = RxInt(0);
  RxInt restTime = RxInt(90);
  bool exercisePaused = false;
  bool recordingExerciseSet = false;
  bool inputSetRecordDone = false;
  bool resting = false;
  bool showRestStartHint = true;
  bool postLoading = false;
  List<dynamic>? exercisePlan;
  int restStartHintTime = 0;
  int currentSet = 1;
  int numSets = 1;
  int inputWeightType = 0;
  double inputWeightChangeValue = 1;
  List<int> inputTargetRepsList = [];
  List<TextEditingController>? inputSetValues = [
    TextEditingController(text: '0.0'),
    TextEditingController(text: '0'),
  ];
  FixedExtentScrollController recordRepsScrollController =
      FixedExtentScrollController();
  int recommendedRestTime = 90;
  Map<String, dynamic> exerciseData = {};
  Map<String, dynamic>? exerciseRecord;
  Map<String, dynamic>? postedExerciseRecord;

  @override
  void onInit() {
    super.onInit();
    for (int i = 1; i <= 100; i++) {
      inputTargetRepsList.add(i);
    }
  }

  @override
  void onClose() {
    recordRepsScrollController.dispose();
    if (timerAnimationController != null) {
      timerAnimationController!.dispose();
    }
    if (restStartHintCounter != null) {
      restStartHintCounter!.cancel();
    }
    confettiControllerTop.dispose();
    super.onClose();
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

  Timer _createTimer(RxInt time) {
    return Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (time < 0) {
          timer.cancel();
        } else {
          time--;
        }
      },
    );
  }

  void updateInputWeightType(int type) {
    inputWeightType = type;
    update();
  }

  void updateInputWeightChangeValue(double val) {
    inputWeightChangeValue = val;
    update();
  }

  void startExercise(int id, Map<String, dynamic> data) {
    Get.toNamed('/exercise_block');
    exerciseData = data;
    if (exercisePlan != null && exercisePlan != []) {
      numSets = exercisePlan!.length;
      totalExerciseTimeCounter = _createCounter(totalExerciseTime);
      currentExerciseTimeCounter = _createCounter(currentExerciseTime);
      inputSetValues![0].text =
          exercisePlan![currentSet - 1]['target_weight']!.toString();
      inputSetValues![1].text =
          exercisePlan![currentSet - 1]['target_reps']!.toString();
    }

    exerciseRecord = {
      'start_time': DateTime.now().toString(),
      'exercise_plan_weight_id': id,
      'exercise_id': data['id'],
      'sets': [],
    };

    exerciseRecord!['sets'].add(
      {
        'start_time': DateTime.now().toString(),
      },
    );

    update();
  }

  void startExerciseSetRecord() {
    recordingExerciseSet = true;
    update();
  }

  void onWeightRecordInputChanged(String value) {
    String val = (value == '') ? '0.0' : value;
    if (double.parse(val) > 500) {
      inputSetValues![0].text = '499';
    } else {
      inputSetValues![0].text = value;
      inputSetValues![0].selection = TextSelection.fromPosition(
          TextPosition(offset: inputSetValues![0].text.length));
    }
    update();
  }

  void subtractInputWeightRecord() {
    if (inputSetValues != null &&
        double.parse(inputSetValues![0].text) >= inputWeightChangeValue) {
      inputSetValues![0].text =
          (double.parse(inputSetValues![0].text) - inputWeightChangeValue)
              .toString();
      update();
    }
  }

  void addInputWeightRecord() {
    if (inputSetValues != null) {
      if (inputSetValues![0].text == '') {
        inputSetValues![0].text = '0.0';
      }
      inputSetValues![0].text =
          (double.parse(inputSetValues![0].text) + inputWeightChangeValue)
              .toString();
      update();
    }
  }

  void updateInputReps(int value) {
    if (inputSetValues != null) {
      inputSetValues![1].text = inputTargetRepsList[value].toString();

      update();
    }
  }

  void completeSet() {
    exercisePaused = true;
    currentExerciseTimeCounter!.cancel();
    exerciseRecord!['sets'][currentSet - 1]['end_time'] =
        DateTime.now().toString();
    update();
  }

  void startRest() {
    restTime.value = recommendedRestTime;
    timerAnimationController = AnimationController(
      vsync: this,
      value: resting ? restTime.value / recommendedRestTime : 0.0,
      duration: Duration(seconds: recommendedRestTime),
    );
    timerAnimationController!.reverse(from: 1.0);
    restStartHintCounter = Timer.periodic(
      const Duration(milliseconds: 300),
      (timer) {
        if (restStartHintTime < 0) {
          timer.cancel();
        } else {
          restStartHintTime++;
        }
        update();
      },
    );

    resting = true;
    restTimeCounter = _createTimer(restTime);

    update();
  }

  void checkEndRest() {
    if (resting && restTime.value <= 0) {
      endRest();
      startNextSet();
    }
  }

  void endRest() {
    if (restTimeCounter != null) {
      restTimeCounter!.cancel();
      timerAnimationController!.removeListener(checkEndRest);
    }
    resting = false;
    update();
  }

  void hideRestStartHint() {
    showRestStartHint = false;
    update();
  }

  void subtractRestTime() {
    restTime -= 10;
    timerAnimationController!.value = restTime.value / recommendedRestTime;
    timerAnimationController!.reverse();
    update();
  }

  void addRestTime() {
    restTime += 10;
    timerAnimationController!.value = restTime.value / recommendedRestTime;
    timerAnimationController!.reverse();
    update();
  }

  void updateInputSetRecordDone(bool val) {
    inputSetRecordDone = val;
    update();
  }

  void completeExerciseSetRecord() {
    exercisePaused = true;
    recordingExerciseSet = false;
    exerciseRecord!['sets'][currentSet - 1]['record_weight'] =
        inputSetValues![0].text;
    exerciseRecord!['sets'][currentSet - 1]['record_reps'] =
        inputSetValues![1].text;
    startRest();
    currentSet++;
    update();
  }

  void startNextSet() {
    exercisePaused = !exercisePaused;
    inputSetRecordDone = false;
    currentExerciseTimeCounter = _createCounter(currentExerciseTime);

    inputSetValues![0].text =
        exercisePlan![currentSet - 1]['target_weight']!.toString();
    inputSetValues![1].text =
        exercisePlan![currentSet - 1]['target_reps']!.toString();

    exerciseRecord!['sets'].add({
      'start_time': DateTime.now().toString(),
    });

    update();
  }

  void endExercise() async {
    Get.offNamed('/exercise_summary');
    exerciseRecord!['sets'][currentSet - 1]['record_weight'] =
        inputSetValues![0].text;
    exerciseRecord!['sets'][currentSet - 1]['record_reps'] =
        inputSetValues![1].text;
    exerciseRecord!.addAll({
      'exercise_time': currentExerciseTime.value,
      'total_exercise_time': totalExerciseTime.value,
      'end_time': DateTime.now().toString(),
    });
    print(exerciseRecord!);
    int recordWeightId =
        await ExerciseApiService.postExerciseRecordWeight(exerciseRecord!);
    getExerciseRecordWeight(recordWeightId);
    reset();
  }

  void reset() {
    currentSet = 1;
    inputSetValues = null;
    exercisePaused = false;
    recordingExerciseSet = false;
    resting = false;
    showRestStartHint = true;
    inputSetValues = [
      TextEditingController(text: '0.0'),
      TextEditingController(text: '0'),
    ];

    totalExerciseTimeCounter!.cancel();
    currentExerciseTimeCounter!.cancel();
    if (restTimeCounter != null) {
      restTimeCounter!.cancel();
    }
    totalExerciseTime.value = 0;
    currentExerciseTime.value = 0;
    restTime.value = 0;
    numSets = 1;
    update();
  }

  void setPostLoading(bool val) {
    postLoading = val;
    update();
  }

  Future<void> getExercisePlanWeightSets(int id) async {
    var res = await ExerciseApiService.getExercisePlanWeightSets(id);
    exercisePlan = res;
    update();
  }

  Future<void> getExerciseRecordWeight(int id) async {
    setPostLoading(true);
    var res = await ExerciseApiService.getExerciseRecordWeight(id);
    postedExerciseRecord = res;
    update();
    setPostLoading(false);
  }
}
