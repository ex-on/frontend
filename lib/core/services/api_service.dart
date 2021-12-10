import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/parse_jwt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static var dio = Dio();
  static const storage = FlutterSecureStorage();
  static Future<String> getAccessToken() async {
    String? accessToken = await storage.read(key: 'access_token');
    return accessToken ?? '';
  }

  static Future<String> getIdToken() async {
    String? idToken = await storage.read(key: 'id_token');
    return idToken ?? '';
  }

  static Future<Response<dynamic>> get(
      String path, Map<String, dynamic>? parameters) async {
    String accessToken = await getAccessToken();
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
    String accessToken = await getAccessToken();
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
      String idToken = await getIdToken();
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

  static Future<dynamic> getPostPreview(
      int indexNum, int pageNum, int type) async {
    String path = '/community/postmain';

    Map<String, dynamic> parameters = {
      'index_num': indexNum,
      'page_num': pageNum,
      'type': type,
    };

    try {
      var res = await get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getHotBoardPreview(int indexNum, int pageNum) async {
    String path = '/community/hotboardmain';

    Map<String, dynamic> parameters = {
      'index_num': indexNum,
      'page_num': pageNum,
    };

    try {
      var res = await get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getPost(int postId) async {
    String path = '/community/getpost';

    Map<String, dynamic> parameters = {
      'post_id': postId,
    };

    try {
      var res = await get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getPostComments(int postId) async {
    String path = '/community/getpostcomments';

    Map<String, dynamic> parameters = {
      'post_id': postId,
    };

    try {
      var res = await get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postPostComment(int postId, String content) async {
    String path = '/community/postcomment';

    Map<String, dynamic> data = {
      'post_id': postId,
      'content': content,
    };

    try {
      var res = await post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postPostCommentReply(
      int postId, int postCommentId, String content) async {
    String path = '/community/postcommentreply';

    Map<String, dynamic> data = {
      'post_id': postId,
      'post_comment_id': postCommentId,
      'content': content,
    };

    try {
      var res = await post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getUserRecentCommunityData() async {
    String path = '/community/user_recent_community';

    try {
      var res = await get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
