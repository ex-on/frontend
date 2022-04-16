import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/services/exercise_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExerciseController extends GetxController
    with GetTickerProviderStateMixin {
  static AddExerciseController to = Get.find();
  TextEditingController searchExerciseTextController = TextEditingController();
  late TabController cardioPlanInputTabController;
  List<List<TextEditingController>> inputSetControllerList = [
    [TextEditingController(text: '0.0'), TextEditingController(text: '0')]
  ];
  TextEditingController targetDistanceTextController =
      TextEditingController(text: '0.0');
  late FixedExtentScrollController targetRepsScrollController;
  late FixedExtentScrollController targetHourScrollController;
  late FixedExtentScrollController targetMinScrollController;
  int page = 0;
  int exerciseType = 0;
  int targetMuscle = 0;
  int exerciseMethod = 0;
  int cardioMethod = 0;
  int numSets = 1;
  int? inputSetNum;
  int inputWeightType = 0;
  double inputWeightChangeValue = 1;
  int inputCardioHour = 0;
  int inputCardioMin = 0;
  double inputDistanceChangeValue = 1;
  bool loading = false;
  bool inputSetDataNotNull = false;
  Map<String, dynamic> selectedExerciseInfo = {};
  List<int> inputTargetRepsList = [];
  List<dynamic> exerciseDataListWeight = [];
  List<dynamic> exerciseDataListCardio = [];
  List<dynamic> selectedExerciseDataList = [];

  @override
  void onInit() {
    super.onInit();
    for (int i = 1; i <= 100; i++) {
      inputTargetRepsList.add(i);
    }
    cardioPlanInputTabController = TabController(length: 2, vsync: this);
    cardioPlanInputTabController.addListener(() {
      update();
    });
    targetRepsScrollController = FixedExtentScrollController();
    targetHourScrollController = FixedExtentScrollController();
    targetMinScrollController = FixedExtentScrollController();
  }

  @override
  void onClose() {
    cardioPlanInputTabController.dispose();
    targetRepsScrollController.dispose();
    targetHourScrollController.dispose();
    targetMinScrollController.dispose();
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

  void changeExerciseType() {
    if (exerciseType == 0) {
      exerciseType = 1;
    } else {
      exerciseType = 0;
    }
    updateCurrentExerciseDataList();
    update();
  }

  void targetMuscleSelectUpdate(int target) {
    targetMuscle = target;
    update();
    updateCurrentExerciseDataList();
  }

  void exerciseMethodSelectUpdate(int method) {
    exerciseMethod = method;
    update();
    updateCurrentExerciseDataList();
  }

  void cardioMethodSelectUpdate(int method) {
    cardioMethod = method;
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

  void updateInputCardioHour(int hour) {
    inputCardioHour = hour;
    update();
  }

  void updateInputCardioMin(int min) {
    inputCardioMin = min;
    update();
  }

  void updateInputDistanceChangeValue(double val) {
    inputDistanceChangeValue = val;
    update();
  }

  void onDistanceInputChanged(String value) {
    String val = (value == '') ? '0.0' : value;
    if (double.parse(val) > 50) {
      targetDistanceTextController.text = '49';
    } else {
      targetDistanceTextController.text = value;
      targetDistanceTextController.selection = TextSelection.fromPosition(
          TextPosition(offset: targetDistanceTextController.text.length));
    }
    update();
  }

  void subtractDistance() {
    if (double.parse(targetDistanceTextController.text) >=
        inputDistanceChangeValue) {
      targetDistanceTextController.text =
          (double.parse(targetDistanceTextController.text) -
                  inputDistanceChangeValue)
              .toString();
    }
    update();
  }

  void addDistance() {
    if (targetDistanceTextController.text.isEmpty) {
      targetDistanceTextController.text = inputDistanceChangeValue.toString();
    } else {
      targetDistanceTextController.text =
          (double.parse(targetDistanceTextController.text) +
                  inputDistanceChangeValue)
              .toString();
    }
    update();
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
    cardioMethod = 0;
    searchExerciseTextController.clear();
    updateCurrentExerciseDataList();
  }

  Future<void> getExerciseList() async {
    if (exerciseDataListWeight.isEmpty) {
      setLoading(true);
      var res = await ExerciseApiService.getExerciseList();
      exerciseDataListWeight = res['weight'];
      exerciseDataListCardio = res['cardio'];
      update();
      setLoading(false);
    }
  }

  void updateCurrentExerciseDataList() {
    String _keyword = searchExerciseTextController.text;
    if (exerciseType == 0) {
      List<dynamic> dataList = exerciseDataListWeight.toList();
      dataList.retainWhere((element) {
        var data = element as Map;
        return ((data['exercise_method'] == exerciseMethod) ||
                exerciseMethod == 0) &&
            ((data['target_muscle'] == targetMuscle) || targetMuscle == 0) &&
            data['name'].contains(_keyword);
      });
      selectedExerciseDataList = dataList;
    } else {
      List<dynamic> dataList = exerciseDataListCardio.toList();
      dataList.retainWhere((element) {
        var data = element as Map;
        return ((data['exercise_method'] == cardioMethod) ||
                cardioMethod == 0) &&
            data['name'].contains(_keyword);
      });
      selectedExerciseDataList = dataList;
    }
  }

  void onExerciseSearchFieldChanged(String keyword) {
    if (exerciseType == 0) {
      List<dynamic> dataList = exerciseDataListWeight.toList();
      dataList.retainWhere((element) {
        var data = element as Map;
        return ((data['exercise_method'] == exerciseMethod) ||
                exerciseMethod == 0) &&
            ((data['target_muscle'] == targetMuscle) || targetMuscle == 0) &&
            data['name'].contains(keyword);
      });
      selectedExerciseDataList = dataList;
    } else {
      List<dynamic> dataList = exerciseDataListCardio.toList();
      dataList.retainWhere((element) {
        var data = element as Map;
        return ((data['exercise_method'] == cardioMethod) ||
                cardioMethod == 0) &&
            data['name'].contains(keyword);
      });
      selectedExerciseDataList = dataList;
    }
    update();
  }

  void postExerciseWeightPlan() async {
    await ExerciseApiService.postExercisePlanWeight(
        selectedExerciseInfo['id'], inputSetControllerList);
    HomeController.to.getTodayExerciseStatus();
  }

  void postExerciseCardioPlan() async {
    double? _targetDistance;
    int? _targetDuration;
    if (targetDistanceTextController.text.isNotEmpty
        ? double.parse(targetDistanceTextController.text) > 0
        : false) {
      _targetDistance = double.parse(targetDistanceTextController.text);
    }
    print('called');
    if (inputCardioHour != 0 || inputCardioMin != 0) {
      _targetDuration = inputCardioHour * 3600 + inputCardioMin * 60;
    }
    await ExerciseApiService.postExercisePlanCardio(
        selectedExerciseInfo['id'], _targetDistance, _targetDuration);
    HomeController.to.getTodayExerciseStatus();
  }
}
