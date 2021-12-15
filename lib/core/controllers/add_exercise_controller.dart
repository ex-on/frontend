import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/services/api_service.dart';
import 'package:exon_app/core/services/exercise_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddExerciseController extends GetxController {
  static AddExerciseController to = Get.find();
  TextEditingController searchExerciseController = TextEditingController();
  List<List<TextEditingController>> inputSetControllerList = [
    [TextEditingController(), TextEditingController()]
  ];
  int page = 0;
  int targetMuscle = 0;
  int exerciseMethod = 0;
  int numSets = 1;
  int inputSetNum = 0;
  bool loading = false;
  bool inputSetDataNotNull = false;
  Map<String, dynamic> selectedExerciseInfo = {};
  List<dynamic> exerciseDataList = [];
  List<dynamic> selectedExerciseDataList = [];

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
    update();
  }

  void updateInputSetDataNotNull() {
    bool val = inputSetControllerList.every(
        (element) => element[0].text.isNotEmpty && element[1].text.isNotEmpty);
    inputSetDataNotNull = val;
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
    print(inputSetControllerList.length);
    update();
  }

  void deleteSet(int setNum) {
    numSets--;
    inputSetControllerList.removeAt(setNum - 1);
    update();
  }

  void updateInputSetNum(int setNum) {
    inputSetNum = setNum;
    update();
  }

  void resetExerciseDetails() {
    inputSetControllerList = [
      [TextEditingController(), TextEditingController()],
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
    print(exerciseDataList.length);
    if (exerciseDataList.isEmpty) {
      setLoading(true);
      var res = await ExerciseApiService.getExerciseList();
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
    HomeController.to.getTodayExercisePlans();
  }
}
