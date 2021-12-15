import 'package:exon_app/core/services/api_service.dart';
import 'package:intl/intl.dart';

class ExerciseApiService extends ApiService {
  static Future<dynamic> getExerciseList() async {
    String path = '/exercise/list';

    try {
      var res = await ApiService.get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }
  static Future<dynamic> postExercisePlanWeight(
      int exerciseId, List setData) async {
    String path = '/exercise/post_exercise_plan_weight';

    List<Map> sets = [];

    for (int i = 0; i < setData.length; i++) {
      Map<String, dynamic> data = {
        'set_num': i + 1,
        'target_weight': double.parse((setData[i][0].text)),
        'target_reps': int.parse((setData[i][0].text)),
      };
      sets.add(data);
    }

    Map<String, dynamic> data = {
      'exercise_id': exerciseId,
      'sets': sets,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getExercisePlanDate(DateTime dateTime) async {
    String path = '/exercise/plan_weight_date';

    Map<String, dynamic> parameters = {
      'date': DateFormat('yyyy-MM-dd').format(dateTime),
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getExercisePlanWeightSets(
      int exercisePlanWeightId) async {
    String path = '/exercise/plan_weight_sets';

    Map<String, dynamic> parameters = {
      'exercise_plan_weight_id': exercisePlanWeightId,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }
}
