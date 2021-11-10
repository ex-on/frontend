import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddExerciseController extends GetxController {
  static AddExerciseController to = Get.find();
  TextEditingController searchExerciseController = TextEditingController();
  int page = 0;
  int targetMuscle = 0;
  int exerciseMethod = 0;
  int numSets = 0;
  int inputSetNum = 0;
  String selectedExercise = '';
  bool isAddingNewSet = false;
  bool addedNewSet = false;
  List<int> currentInputSetValues = [0, 0];
  List<List<int>> inputSetValues = [];

  void jumpToPage(int pageNum) {
    page = pageNum;
    update();
  }

  void targetMuscleSelectUpdate(int target) {
    targetMuscle = target;
    update();
  }

  void excerciseMethodSelectUpdate(int method) {
    exerciseMethod = method;
    update();
  }

  void excerciseSelectUpdate(String name) {
    selectedExercise = name;
    update();
  }

  void addSet() {
    isAddingNewSet = true;
    numSets++;
    if (numSets == 1) {
      inputSetValues.add([0, 0]);
    } else {
      inputSetValues.add(inputSetValues.last);
    }
    update();
  }

  void deleteSet(int setNum) {
    isAddingNewSet = false;
    numSets--;
    inputSetValues.removeAt(setNum - 1);
    update();
  }

  void confirmNewSet() {
    isAddingNewSet = false;
    addedNewSet = true;
    update();
  }

  void resetAddedNewSet() {
    addedNewSet = false;
    update();
  }

  void updateInputSetNum(int setNum) {
    inputSetNum = setNum;
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
    inputSetValues[inputSetNum - 1] = [
      currentInputSetValues[0],
      currentInputSetValues[1]
    ];
    update();
  }

  void reset() {
    currentInputSetValues = [0, 0];
    inputSetValues = [
      [0, 0]
    ];
    numSets = 1;
    update();
  }

  FixedExtentScrollController getWeightController(int setNum) {
    int item = inputSetValues[setNum - 1][0] - 1;
    return FixedExtentScrollController(initialItem: item);
  }

  FixedExtentScrollController getRepsController(int setNum) {
    var item = inputSetValues[setNum - 1][1] - 1;
    return FixedExtentScrollController(initialItem: item);
  }
}
