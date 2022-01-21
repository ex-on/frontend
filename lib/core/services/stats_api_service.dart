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
}
