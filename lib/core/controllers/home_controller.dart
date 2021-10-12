import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController homeController = Get.find();
  TextEditingController searchExcerciseController = TextEditingController();
  final totalExcerciseTime =
      const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  int page = 0;
  int targetMuscle = 0;
  int excerciseMethod = 0;

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
}
