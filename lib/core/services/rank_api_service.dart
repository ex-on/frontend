import 'package:exon_app/core/services/api_service.dart';

class RankApiService extends ApiService {
  static Future<dynamic> getProteinRank() async {
    String path = '/user/rank/protein';

    Map<String, dynamic> parameters = {};

    try {
      var res = await ApiService.get(path, parameters);

      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getCardioRank(int month) async {
    String path = '/user/rank/cardio';

    Map<String, dynamic> parameters = {
      'month': month,
    };

    try {
      var res = await ApiService.get(path, parameters);

      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getWeightRank(int month) async {
    String path = '/user/rank/weight';

    Map<String, dynamic> parameters = {
      'month': month,
    };

    try {
      var res = await ApiService.get(path, parameters);

      return res.data;
    } catch (e) {
      print(e);
    }
  }
}
