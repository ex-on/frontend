import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/services/exercise_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExercisePlanController extends GetxController
    with GetTickerProviderStateMixin {
  static ExercisePlanController to = Get.find();
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
  RefreshController exercisePlansRefreshController = RefreshController();
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
  int selectedPlanId = 0;
  bool loading = false;
  bool inputSetDataNotNull = false;
  bool isUpdate = false;
  Map<String, dynamic> selectedExerciseInfo = {};
  Map<String, dynamic> previousExercisePlan = {};
  List<int> inputTargetRepsList = [];
  List<dynamic> exerciseDataListWeight = [];
  List<dynamic> exerciseDataListCardio = [];
  List<dynamic> selectedExerciseDataList = [];
  List<dynamic> dailyExercisePlans = [];
  List<dynamic> dailyExerciseRecords = [];

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

  void onExercisePlansRefresh() async {
    await getDailyExercisePlans();
    exercisePlansRefreshController.refreshCompleted();
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

  void setIsUpdate(bool val) {
    isUpdate = val;
    update();
  }

  void initializeExerciseUpdate(int index) {
    isUpdate = true;
    selectedExerciseInfo = {
      'id': dailyExercisePlans[index]['exercise_data']['id'],
      'name': dailyExercisePlans[index]['exercise_data']['name'],
      'exercise_method': dailyExercisePlans[index]['exercise_data']
          ['exercise_method'],
      'target_muscle': dailyExercisePlans[index]['exercise_data']
          ['target_muscle'],
    };
    selectedPlanId = dailyExercisePlans[index]['plan_data']['id'];
    exerciseType = dailyExercisePlans[index]['exercise_data']['type'];
    previousExercisePlan = dailyExercisePlans[index]['plan_data'];
    print(previousExercisePlan);
    if (dailyExercisePlans[index]['exercise_data']['type'] == 0) {
      inputSetNum = null;
      List<dynamic> setData = dailyExercisePlans[index]['plan_data']['sets'];
      if (setData.isNotEmpty) {
        inputSetControllerList = [];
        numSets = 0;
        for (int i = 0; i < setData.length; i++) {
          numSets++;
          inputSetControllerList.add(
            [
              TextEditingController(
                  text: setData[i]['target_weight'].toString()),
              TextEditingController(text: setData[i]['target_reps'].toString()),
            ],
          );
        }
      }
    } else {
      if (dailyExercisePlans[index]['plan_data']['target_distance'] != null) {
        targetDistanceTextController.text = dailyExercisePlans[index]
                ['plan_data']['target_distance']
            .toString();
      }
      if (dailyExercisePlans[index]['plan_data']['target_duration'] != null) {
        int _duration =
            dailyExercisePlans[index]['plan_data']['target_duration'];
        inputCardioHour = _duration ~/ 3600;
        inputCardioMin = (_duration % 3600) ~/ 60;
        Future.delayed(const Duration(milliseconds: 100), () {
          targetHourScrollController.jumpTo(60 * inputCardioHour.toDouble());
          targetMinScrollController.jumpTo(60 * inputCardioMin.toDouble());
        });
      }
    }
  }

  void resetExerciseWeightDetails() {
    inputSetControllerList = [
      [TextEditingController(text: '0.0'), TextEditingController(text: '0')],
    ];
    numSets = 1;
    update();
  }

  void resetExerciseCardioDetails() {
    targetDistanceTextController.text = '0.0';
    inputCardioHour = 0;
    inputCardioMin = 0;
    cardioPlanInputTabController.index = 0;
    update();
  }

  void resetExerciseSelect() {
    targetMuscle = 0;
    exerciseMethod = 0;
    cardioMethod = 0;
    exerciseType = 0;
    searchExerciseTextController.clear();
    updateCurrentExerciseDataList();
  }

  void resetExerciseUpdate() {
    isUpdate = false;
    selectedExerciseInfo = {};
    exerciseType = 0;
    update();
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

  void loadRecentExercisePlan() async {
    setLoading(true);
    var data = await ExerciseApiService.loadRecentExercisePlan(
        selectedExerciseInfo['id']);
    if (exerciseType == 0) {
      List<dynamic> setData = data['sets'];
      if (setData.isNotEmpty) {
        inputSetControllerList = [];
        numSets = 0;
        for (int i = 0; i < setData.length; i++) {
          numSets++;
          inputSetControllerList.add(
            [
              TextEditingController(
                  text: setData[i]['target_weight'].toString()),
              TextEditingController(text: setData[i]['target_reps'].toString()),
            ],
          );
        }
      } else {
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text(
              '운동한 기록이 없습니다',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            borderRadius: 10,
            margin: const EdgeInsets.only(left: 10, right: 10),
            duration: const Duration(seconds: 2),
            isDismissible: false,
            backgroundColor: darkSecondaryColor.withOpacity(0.8),
          ),
        );
      }
    } else {
      if (data['target_duration'] != null) {
        int _duration = data['target_duration'];
        inputCardioHour = _duration ~/ 3600;
        inputCardioMin = (_duration % 3600) ~/ 60;
        targetHourScrollController.jumpTo(60 * inputCardioHour.toDouble());
        targetMinScrollController.jumpTo(60 * inputCardioMin.toDouble());
      }
      if (data['target_distance'] != null) {
        targetDistanceTextController.text = data['target_distance'].toString();
      }
      if (data['target_distance'] == null && data['target_duration'] == null) {
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text(
              '운동한 기록이 없습니다',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            borderRadius: 10,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
            duration: const Duration(seconds: 2),
            isDismissible: false,
            backgroundColor: darkSecondaryColor.withOpacity(0.8),
          ),
        );
      }
      update();
    }
    setLoading(false);
  }

  void postExerciseWeightPlan() async {
    await ExerciseApiService.postExercisePlanWeight(
        selectedExerciseInfo['id'], inputSetControllerList);
    resetExerciseSelect();
    resetExerciseWeightDetails();
    HomeController.to.getTodayExerciseStatus();
    getDailyExercisePlans();
    Get.showSnackbar(
      GetSnackBar(
        messageText: const Text(
          '운동 계획이 성공적으로 추가되었습니다',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        borderRadius: 10,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
        duration: const Duration(seconds: 2),
        isDismissible: false,
        backgroundColor: darkSecondaryColor.withOpacity(0.8),
      ),
    );
  }

  void postExerciseCardioPlan() async {
    double? _targetDistance;
    int? _targetDuration;
    if (targetDistanceTextController.text.isNotEmpty
        ? double.parse(targetDistanceTextController.text) > 0
        : false) {
      _targetDistance = double.parse(targetDistanceTextController.text);
    }
    if (inputCardioHour != 0 || inputCardioMin != 0) {
      _targetDuration = inputCardioHour * 3600 + inputCardioMin * 60;
    }
    await ExerciseApiService.postExercisePlanCardio(
        selectedExerciseInfo['id'], _targetDistance, _targetDuration);
    resetExerciseSelect();
    resetExerciseCardioDetails();
    HomeController.to.getTodayExerciseStatus();
    getDailyExercisePlans();
    Get.showSnackbar(
      GetSnackBar(
        messageText: const Text(
          '운동 계획이 성공적으로 추가되었습니다',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        borderRadius: 10,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
        duration: const Duration(seconds: 2),
        isDismissible: false,
        backgroundColor: darkSecondaryColor.withOpacity(0.8),
      ),
    );
  }

  Future<void> getDailyExercisePlans() async {
    var res = await ExerciseApiService.getExerciseDetailsList();
    dailyExercisePlans = res['plans'];
    dailyExerciseRecords = res['records'];
    update();
  }

  Future<void> updateExercisePlanWeight() async {
    var res = await ExerciseApiService.updateExercisePlanWeight(
        selectedPlanId, inputSetControllerList);
    resetExerciseWeightDetails();
    HomeController.to.getTodayExerciseStatus();
    getDailyExercisePlans();

    if (res == 200) {
      Get.showSnackbar(
        GetSnackBar(
          messageText: const Text(
            '운동 계획이 성공적으로 수정되었습니다',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          borderRadius: 10,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
          duration: const Duration(seconds: 2),
          isDismissible: false,
          backgroundColor: darkSecondaryColor.withOpacity(0.8),
        ),
      );
    }
  }

  Future<void> updateExercisePlanCardio() async {
    double? _targetDistance;
    int? _targetDuration;
    if (targetDistanceTextController.text.isNotEmpty
        ? double.parse(targetDistanceTextController.text) > 0
        : false) {
      _targetDistance = double.parse(targetDistanceTextController.text);
    }
    if (inputCardioHour != 0 || inputCardioMin != 0) {
      _targetDuration = inputCardioHour * 3600 + inputCardioMin * 60;
    }
    var res = await ExerciseApiService.updateExercisePlanCardio(
        selectedPlanId, _targetDistance, _targetDuration);
    resetExerciseCardioDetails();
    getDailyExercisePlans();
    HomeController.to.getTodayExerciseStatus();
    if (res == 200) {
      Get.showSnackbar(
        GetSnackBar(
          messageText: const Text(
            '운동 계획이 성공적으로 수정되었습니다',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          borderRadius: 10,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
          duration: const Duration(seconds: 2),
          isDismissible: false,
          backgroundColor: darkSecondaryColor.withOpacity(0.8),
        ),
      );
    }
  }

  Future<void> deleteExercisePlan(int index) async {
    var res = await ExerciseApiService.deleteExercisePlan(
        dailyExercisePlans[index]['plan_data']['id'],
        dailyExercisePlans[index]['exercise_data']['type']);

    await getDailyExercisePlans();

    if (res == 200) {
      HomeController.to.getTodayExerciseStatus();
      Get.showSnackbar(
        GetSnackBar(
          messageText: const Text(
            '운동 계획이 성공적으로 삭제되었습니다',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          borderRadius: 10,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
          duration: const Duration(seconds: 2),
          isDismissible: false,
          backgroundColor: darkSecondaryColor.withOpacity(0.8),
        ),
      );
    }
  }
}
