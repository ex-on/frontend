import 'package:exon_app/core/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:exon_app/helpers/utils.dart';

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
      Map<String, dynamic> setDataMap = {
        'set_num': i + 1,
        'target_weight': double.parse((setData[i][0].text)),
        'target_reps': int.parse((setData[i][1].text)),
      };
      sets.add(setDataMap);
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

  static Future<dynamic> postExercisePlanCardio(
      int exerciseId, double? targetDistance, int? targetDuration) async {
    String path = '/exercise/post_exercise_plan_cardio';

    Map<String, dynamic> data = {
      'exercise_id': exerciseId,
      'target_distance': targetDistance,
      'target_duration': targetDuration,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getExerciseStatusWeek(DateTime dateTime) async {
    String path = '/exercise/status_week';

    Map<String, dynamic> parameters = {
      'first_date': DateFormat('yyyy-MM-dd').format(dateTime.firstDateOfWeek),
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getExerciseStatusDate(DateTime dateTime) async {
    String path = '/exercise/status_date';

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

  static Future<dynamic> postExerciseRecordWeight(
      Map<String, dynamic> recordData) async {
    String path = '/exercise/record_weight';

    try {
      var res = await ApiService.post(path, recordData);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getExerciseRecordWeight(int id) async {
    String path = '/exercise/record_weight';

    Map<String, dynamic> parameters = {
      'id': id,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> postExerciseRecordCardio(
      Map<String, dynamic> recordData) async {
    String path = '/exercise/record_cardio';

    try {
      var res = await ApiService.post(path, recordData);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getExerciseRecordCardio(int id) async {
    String path = '/exercise/record_cardio';

    Map<String, dynamic> parameters = {
      'id': id,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> loadRecentExercisePlan(int id) async {
    String path = '/exercise/recent';

    Map<String, dynamic> parameters = {
      'id': id,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }
}
