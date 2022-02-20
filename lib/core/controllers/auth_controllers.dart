import 'dart:async';

import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/core/services/user_api_service.dart';
import 'package:exon_app/helpers/parse_jwt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:kakao_flutter_sdk/auth.dart';

class KakaoLoginController extends GetxController {
  bool isKakaoInstalled = false;

  @override
  void onInit() {
    _initKakaoTalkInstalled();
    super.onInit();
  }

  void _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install: ' + installed.toString());
    isKakaoInstalled = installed;
    update();
  }
}

class AuthController extends GetxController {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  static AuthController to = Get.find();
  Map<String, dynamic> userInfo = {};
  bool loading = false;

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void reset() {
    userInfo = {};
    update();
  }

  Future<void> asyncMethod() async {
    await getUserInfo();
    HomeNavigationController.to.reset();
    Get.offNamed('/home');
  }

  Future<dynamic> getAccessToken() async {
    var refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken != null) {
      var accessToken = await storage.read(key: 'access_token');
      if (parseJwt(accessToken!)["exp"] * 1000 <
              DateTime.now().millisecondsSinceEpoch ||
          (accessToken == null)) {
        print('Access token expired');
        await AmplifyService.getTokensWithRefreshToken(refreshToken);
        var updatedAccessToken = await storage.read(key: 'access_token');
        print('Access token updated');
        return updatedAccessToken;
      } else {
        return accessToken;
      }
    } else {
      print("refresh token doesn't exist");
      Get.offNamed('/auth');
    }
  }

  Future<void> getUserInfo() async {
    bool userInfoStored = await storage.containsKey(key: 'username') &&
        await storage.containsKey(key: 'activity_level') &&
        await storage.containsKey(key: 'created_at');
    // if (userInfoStored) {
    //   Map<String, dynamic> storedUserInfo = {
    //     'username': await storage.read(key: 'username'),
    //     'activity_level': await storage.read(key: 'activity_level'),
    //     'created_at': await storage.read(key: 'created_at'),
    //   };
    //   if (storedUserInfo['username'] != null &&
    //       storedUserInfo['activity_level'] != null &&
    //       storedUserInfo['created_at'] != null) {
    //     userInfo = storedUserInfo;
    //     update();
    //     return;
    //   } else {
    storage.delete(key: 'username');
    storage.delete(key: 'activity_level');
    storage.delete(key: 'created_at');
    //   }
    // }
    var data = await UserApiService.getUserInfo();
    if (data != null) {
      userInfo = data;
    }
    update();
    await storage.write(key: 'username', value: userInfo['username']);
    await storage.write(
        key: 'activity_level', value: userInfo['activity_level'].toString());
    await storage.write(key: 'created_at', value: userInfo['created_at']);
  }
}
