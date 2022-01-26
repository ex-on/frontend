import 'package:exon_app/core/services/api_service.dart';
import 'package:intl/intl.dart';

class StatsApiService extends ApiService {
  static Future<dynamic> getDailyExerciseStats(DateTime day) async {
    String path = '/stats/daily';

    Map<String, dynamic> parameters = {
      'day': DateFormat('yyyy/MM/dd').format(day),
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getMonthlyExerciseDates(DateTime month) async {
    String path = '/stats/monthly_date';

    Map<String, dynamic> parameters = {
      'month': DateFormat('yyyy/MM').format(month),
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> postDailyStatsMemo(String memo, DateTime date) async {
    String path = '/stats/daily_memo';

    Map<String, dynamic> data = {
      'memo': memo,
      'date': DateFormat('yyyy/MM/dd').format(date),
    };

    try {
      var res = await ApiService.post(path, data);
      return res;
    } catch (e) {
      print(e);
    }
  }
}
