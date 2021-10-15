import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddExcerciseController extends GetxController {
  static AddExcerciseController addExcerciseController = Get.find();
  TextEditingController searchExcerciseController = TextEditingController();
  int page = 0;
  int targetMuscle = 0;
  int excerciseMethod = 0;
  int numSets = 1;
  String selectedExcercise = '';
  List<List<TextEditingController>> inputSetControllers = [
    [TextEditingController(), TextEditingController()],
  ];

  void jumpToPage(int pageNum) {
    page = pageNum;
    update();
  }

  void targetMuscleSelectUpdate(int target) {
    targetMuscle = target;
    update();
  }

  void excerciseMethodSelectUpdate(int method) {
    excerciseMethod = method;
    update();
  }

  void excerciseSelectUpdate(String name) {
    selectedExcercise = name;
    update();
  }

  void addSet() {
    numSets++;
    inputSetControllers.add([TextEditingController(), TextEditingController()]);
    update();
  }

  void deleteSet(int setNum) {
    numSets--;
    inputSetControllers.removeAt(setNum - 1);
    update();
  }
}
