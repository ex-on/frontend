import 'package:exon_app/core/services/api_service.dart';

class NotificationApiService extends ApiService {
  static Future<dynamic> getNotifications(int startIndex) async {
    String path = '/notification/list';

    Map<String, dynamic> parameters = {
      'start_index': startIndex,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> markNotificationAsRead(int notificationId) async {
    String path = '/notification/read';

    Map<String, dynamic> data = {
      'id': notificationId,
    };

    try {
      var res = await ApiService.post(path, data);
      return res;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> deleteNotification(int notificationId) async {
    String path = '/notification/delete';

    Map<String, dynamic> data = {
      'id': notificationId,
    };

    try {
      var res = await ApiService.post(path, data);
      return res;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> getUserNotiSettings() async {
    String path = '/notification/settings';

    Map<String, dynamic> parameters = {};

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> postUserNotiSettings(
      int toggleIndex, bool value) async {
    String path = '/notification/settings';

    Map<String, dynamic> data = {
      'toggle_index': toggleIndex,
      'value': value,
    };

    try {
      var res = await ApiService.post(path, data);
      print(res);
      return res;
    } catch (e) {
      print(e);
    }
  }
}
