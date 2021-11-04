class DummyData {
  static Map<String, Map<String, dynamic>> excerciseInfoList = {
    '벤치프레스': {
      'name': '벤치프레스',
      'target_muscle': 1,
      'excercise_method': 3,
      'difficulty': 1,
      'recommended_time_min': 23,
      'info_text':
          '벤치프레스는 뭐뭐뭐하는 운동입니다. 어깨를 가슴에 붙이고 서서 바벨을 들면 됩니다.. 벤치프레스는 어렵지 않습니다. 벤치프레스벤치프레스는 누구나 쉽게 할 수 있습니다. 벤치프레스는 뭐뭐뭐하는 운동입니다. 어깨를 가슴에 붙이고 서서 바벨을 들면 됩니다.. 벤치프레스는 어렵지 않습니다. 벤치프레스벤치프레스는 누구나 쉽게 할 수 있습니다.',
    },
  };

  static List<Map<String, dynamic>> excerciseNameList = [
    {
      'name': '벤치프레스',
      'difficulty': 1,
    },
    {
      'name': '인클라인 벤치프레스',
      'difficulty': 2,
    },
    {
      'name': '머신 체스트프레스',
      'difficulty': 0,
    },
    {
      'name': '덤벨 체스트프레스',
      'difficulty': 2,
    },
    {
      'name': '인클라인 덤벨프레스',
      'difficulty': 2,
    },
    {
      'name': '머신 체스트플라이',
      'difficulty': 0,
    }
  ];

  static List<Map<String, dynamic>> dailyExercisePlanList = [
    {
      'exercise': {
        'name': '벤치프레스',
        'target_muscle': '가슴',
        'exercise_method': '바벨',
      },
      'num_sets': 5,
    }
  ];
}
