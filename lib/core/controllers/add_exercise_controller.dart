import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/services/exercise_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExerciseController extends GetxController {
  static AddExerciseController to = Get.find();
  TextEditingController searchExerciseController = TextEditingController();
  List<List<TextEditingController>> inputSetControllerList = [
    [TextEditingController(text: '0.0'), TextEditingController(text: '0')]
  ];
  FixedExtentScrollController targetRepsScrollController =
      FixedExtentScrollController();
  int page = 0;
  int targetMuscle = 0;
  int exerciseMethod = 0;
  int numSets = 1;
  int? inputSetNum;
  int inputWeightType = 0;
  double inputWeightChangeValue = 1;
  bool loading = false;
  bool inputSetDataNotNull = false;
  Map<String, dynamic> selectedExerciseInfo = {};
  List<int> inputTargetRepsList = [];
  List<dynamic> exerciseDataList = [];
  List<dynamic> selectedExerciseDataList = [];

  @override
  void onInit() {
    super.onInit();
    for (int i = 1; i <= 100; i++) {
      inputTargetRepsList.add(i);
    }
  }

  @override
  void onClose() {
    targetRepsScrollController.dispose();
    super.dispose();
  }

  void jumpToPage(int pageNum) {
    page = pageNum;
    update();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void targetMuscleSelectUpdate(int target) {
    targetMuscle = target;
    update();
    updateCurrentExerciseDataList();
  }

  void excerciseMethodSelectUpdate(int method) {
    exerciseMethod = method;
    update();
    updateCurrentExerciseDataList();
  }

  void updateSelectedExercise(int index) {
    selectedExerciseInfo = {
      'id': selectedExerciseDataList[index]['id'],
      'name': selectedExerciseDataList[index]['name'],
      'exercise_method': selectedExerciseDataList[index]['exercise_method'],
      'target_muscle': selectedExerciseDataList[index]['target_muscle'],
    };
    inputSetNum = 1;
    update();
  }

  void addSet() {
    numSets++;
    inputSetControllerList.add([
      TextEditingController(
        text: inputSetControllerList.last[0].text,
      ),
      TextEditingController(
        text: inputSetControllerList.last[1].text,
      ),
    ]);
    update();
  }

  void deleteSet(int setNum) {
    if (inputSetNum != null) {
      if (inputSetNum! == setNum) {
        inputSetNum = null;
        update();
      } else if (inputSetNum! > setNum) {
        inputSetNum = inputSetNum! - 1;
        update();
      }
    }
    numSets--;
    inputSetControllerList.removeAt(setNum - 1);
    update();
  }

  void updateInputSetNum(int? setNum) {
    inputSetNum = setNum;
    if (inputSetNum != null) {
      targetRepsScrollController.jumpToItem(
          int.parse(inputSetControllerList[inputSetNum! - 1][1].text) - 1);
    }
    update();
  }

  void updateInputWeightType(int type) {
    inputWeightType = type;
    update();
  }

  void updateInputWeightChangeValue(double val) {
    inputWeightChangeValue = val;
    update();
  }

  void subtractInputWeight() {
    if (inputSetNum != null &&
        double.parse(inputSetControllerList[inputSetNum! - 1][0].text) >=
            inputWeightChangeValue) {
      inputSetControllerList[inputSetNum! - 1][0].text =
          (double.parse(inputSetControllerList[inputSetNum! - 1][0].text) -
                  inputWeightChangeValue)
              .toString();
      update();
    }
  }

  void addInputWeight() {
    if (inputSetNum != null) {
      if (inputSetControllerList[inputSetNum! - 1][0].text == '') {
        inputSetControllerList[inputSetNum! - 1][0].text = '0.0';
      }
      inputSetControllerList[inputSetNum! - 1][0].text =
          (double.parse(inputSetControllerList[inputSetNum! - 1][0].text) +
                  inputWeightChangeValue)
              .toString();
      update();
    }
  }

  void onWeightInputChanged(String value) {
    String val = (value == '') ? '0.0' : value;
    if (double.parse(val) > 500) {
      inputSetControllerList[inputSetNum! - 1][0].text = '499';
    } else {
      inputSetControllerList[inputSetNum! - 1][0].text = value;
      inputSetControllerList[inputSetNum! - 1][0].selection =
          TextSelection.fromPosition(TextPosition(
              offset: inputSetControllerList[inputSetNum! - 1][0].text.length));
    }
    update();
  }

  void updateInputReps(int value) {
    if (inputSetNum != null) {
      inputSetControllerList[inputSetNum! - 1][1].text =
          inputTargetRepsList[value].toString();

      update();
    }
  }

  dynamic getCurrentSetInputWeight() {
    if (inputSetNum != null) {
      return inputSetControllerList[inputSetNum! - 1][0].text;
    }
  }

  dynamic getCurrentSetInputReps() {
    if (inputSetNum != null) {
      return inputSetControllerList[inputSetNum! - 1][1].text;
    }
  }

  void resetExerciseDetails() {
    inputSetControllerList = [
      [TextEditingController(text: '0.0'), TextEditingController(text: '0')],
    ];

    numSets = 1;
    update();
  }

  void resetExerciseSelect() {
    targetMuscle = 0;
    exerciseMethod = 0;
    selectedExerciseDataList = [];
    // update();
  }

  Future<void> getExerciseList() async {
    if (exerciseDataList.isEmpty) {
      setLoading(true);
      var res = await ExerciseApiService.getExerciseList();
      print(res);
      exerciseDataList = res;
      update();
      setLoading(false);
    }
  }

  void updateCurrentExerciseDataList() {
    List<dynamic> dataList = exerciseDataList.toList();
    dataList.retainWhere((element) {
      var data = element as Map;
      return ((data['exercise_method'] == exerciseMethod) ||
              exerciseMethod == 0) &&
          ((data['target_muscle'] == targetMuscle) || targetMuscle == 0);
    });
    selectedExerciseDataList = dataList;
    update();
  }

  void postExerciseWeightPlan() async {
    await ExerciseApiService.postExercisePlanWeight(
        selectedExerciseInfo['id'], inputSetControllerList);
    HomeController.to.getTodayExerciseStatus();
  }
}
