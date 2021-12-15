import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/helpers/parse_jwt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class ApiService {
  static var dio = Dio();
  static const storage = FlutterSecureStorage();
  static Future<String> _getAccessToken() async {
    String? accessToken = await storage.read(key: 'access_token');
    return accessToken ?? '';
  }

  static Future<String> _getIdToken() async {
    String? idToken = await storage.read(key: 'id_token');
    return idToken ?? '';
  }

  static Future<dynamic> get(
      String path, Map<String, dynamic>? parameters) async {
    var accessToken = await AuthController.to.getAccessToken();
    var response = await dio.get(endPointUrl + path,
        queryParameters: parameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer ' + accessToken,
          },
        ));
    log(response.toString());
    return response;
  }

  static Future<Response<dynamic>> post(String path, dynamic data) async {
    var accessToken = await AuthController.to.getAccessToken();
    var response = await dio.post(endPointUrl + path,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ' + accessToken,
          },
        ));
    log(response.toString());
    return response;
  }

  static Future<bool> checkUserEmailAvailable(String email) async {
    String path = '/user/check_email';
    Map<String, dynamic> parameters = {
      'email': email,
    };

    try {
      var res = await get(path, parameters);
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
      var res = await get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> checkUserInfo() async {
    String path = '/user/check_user_info';
    try {
      var res = await get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getUserInfo() async {
    String path = '/user/get_user_info';
    try {
      var res = await get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
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
      var res = await post(path, data);
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
      var res = await post(path, data);
      print(res);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

// Community API
}

