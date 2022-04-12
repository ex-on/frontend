import 'package:exon_app/core/services/api_service.dart';
import 'package:exon_app/helpers/parse_jwt.dart';

class UserApiService extends ApiService {
  static Future<String> _getIdToken() async {
    String? idToken = await ApiService.storage.read(key: 'id_token');
    return idToken ?? '';
  }

  static Future<bool> checkUserEmailAvailable(String email) async {
    String path = '/user/check_email';
    Map<String, dynamic> parameters = {
      'email': email,
    };

    try {
      var res = await ApiService.getWithoutToken(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> checkUsernameAvailable(String username) async {
    String path = '/user/check_username';
    Map<String, dynamic> parameters = {
      'username': username,
    };

    try {
      var res = await ApiService.getWithoutToken(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> checkUserInfo() async {
    String path = '/user/check_user_info';
    try {
      var res = await ApiService.get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getUserInfo() async {
    String path = '/user/get_user_info';
    var res = await ApiService.get(path, null);
    if (res != null) {
      if (res.data != null) {
        return res.data;
      } else {
        return res;
      }
    }
  }

  static Future<bool> registerUserInfo(
    String authProvider,
    int gender,
    String birthDate,
    String username,
    String? phoneNumber,
    String? email,
  ) async {
    String path = '/user/register';

    Map<String, dynamic> data = {
      'auth_provider': authProvider,
      'gender': gender,
      'birth_date': birthDate,
      'username': username,
    };
    if (authProvider == 'Manual') {
      data['phone_number'] = phoneNumber;
      data['email'] = email;
    } else if (authProvider == 'Kakao') {
      String idToken = await _getIdToken();
      var idTokenData = parseJwt(idToken);
      data['email'] = idTokenData['email'];
    }
    try {
      var res = await ApiService.post(path, data);
      print(res);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> postUserPhysicalInfo(
    double? height,
    double? weight,
    double? muscleMass,
    double? bodyFatPercentage,
  ) async {
    String path = '/user/physical_info';

    Map<String, dynamic> data = {
      'height': height,
      'weight': weight,
      'muscle_mass': muscleMass,
      'body_fat_percentage': bodyFatPercentage,
    };

    try {
      var res = await ApiService.post(path, data);
      print(res);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> postFcmToken(String token) async {
    String path = '/user/fcm_token';

    Map<String, dynamic> data = {
      'token': token,
    };

    try {
      var res = await ApiService.post(path, data);
      print(res);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getProfileStats() async {
    String path = '/user/stats';

    Map<String, dynamic> parameters = {};

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
    }
  }
}
