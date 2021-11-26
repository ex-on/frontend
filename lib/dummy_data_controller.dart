import 'package:exon_app/helpers/transformers.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class DummyDataController extends GetxController {
  static DummyDataController to = Get.find();
  Map<String, Map<String, dynamic>> exerciseInfoList = {
    '벤치프레스': {
      'id': 1,
      'name': '벤치프레스',
      'target_muscle': 1,
      'exercise_method': 3,
      'difficulty': 1,
      'recommended_time_min': 23,
      'recommended_rest_time': 90, // 추가됨
      'info_text':
          '벤치프레스는 뭐뭐뭐하는 운동입니다. 어깨를 가슴에 붙이고 서서 바벨을 들면 됩니다.. 벤치프레스는 어렵지 않습니다. 벤치프레스벤치프레스는 누구나 쉽게 할 수 있습니다. 벤치프레스는 뭐뭐뭐하는 운동입니다. 어깨를 가슴에 붙이고 서서 바벨을 들면 됩니다.. 벤치프레스는 어렵지 않습니다. 벤치프레스벤치프레스는 누구나 쉽게 할 수 있습니다.',
    },
  };

  List<Map<String, dynamic>> excerciseNameList = [
    {
      'name': '벤치프레스',
      'target_muscle': 1,
      'exercise_method': 3,
    },
    {
      'name': '인클라인 벤치프레스',
      'target_muscle': 1,
      'exercise_method': 3,
    },
    {
      'name': '머신 체스트프레스',
      'target_muscle': 1,
      'exercise_method': 1,
    },
    {
      'name': '덤벨 체스트프레스',
      'target_muscle': 1,
      'exercise_method': 2,
    },
    {
      'name': '인클라인 덤벨프레스',
      'target_muscle': 1,
      'exercise_method': 2,
    },
    {
      'name': '머신 체스트플라이',
      'target_muscle': 1,
      'exercise_method': 1,
    }
  ];

  List<Map<String, dynamic>> dailyExercisePlanList = [];

  List<Map<String, dynamic>> dailyExercisePlanDetailsList = [];

  void addDailyExercisePlan(
      String selectedExercise, List<List<int>> setValues) {
    dailyExercisePlanDetailsList.add(
      {
        'exercise_id': exerciseNameToId[selectedExercise],
        'sets': List.generate(
          setValues.length,
          (index) => {
            'target_weight': setValues[index][0],
            'target_reps': setValues[index][1],
          },
        )
      },
    );
    dailyExercisePlanList.add(
      {
        'exercise_id': exerciseNameToId[selectedExercise],
        'num_sets': setValues.length,
      },
    );
    update();
  }

  List<Map<String, dynamic>> dailyExerciseRecordList = [];

  void addDailyExerciseRecord(Map<String, dynamic> data) {
    dailyExerciseRecordList.add(data);
  }

  List<String> usernameList = [
    'exon_official',
    'exon',
    
  ];

  
}
