import 'dart:async';
import 'dart:developer';

import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
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
    HomeNavigationController.to.reset();
    await RegisterInfoController.to.checkUserInfo();
    if (!RegisterInfoController.to.userInfoExists) {
      Get.offAllNamed('/register_info');
    } else {
      Get.offAllNamed('/home');
    }
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

  Future<dynamic> readIdToken() async {
    var idToken = await storage.read(key: 'id_token');
    if (idToken != null) {
      Map<String, dynamic> data = parseJwt(idToken);
      log(data.toString());
      String cognitoGroup = data['cognito:groups'][0];
      late String authProvider;
      if (data['identities'] != null) {
        print(data['identities'][0]['providerName']);
      }
      print(data['cognito:groups']);
      switch (cognitoGroup) {
        case 'ManualSignUp':
          authProvider = 'Manual';
          break;
        case 'ap-northeast-2_EuYr8s0Rp_Facebook':
          authProvider = 'Facebook';
          break;
        case 'ap-northeast-2_EuYr8s0Rp_Google':
          authProvider = 'Google';
          break;
        default:
          authProvider = cognitoGroup;
          break;
      }
      return {
        'phone_number': data['phone_number'],
        'email': data['email'],
        'auth_provider': authProvider,
      };
    } else {
      return;
    }
  }

  Future<void> getUserInfo() async {
    var data = await UserApiService.getUserInfo();
    if (data != null) {
      if (data == false) {
        Get.toNamed('/register_info', arguments: 'Manual');
      } else {
        userInfo = data;
      }
    }
    update();
    // await storage.write(key: 'username', value: userInfo['username']);
    // await storage.write(
    //     key: 'activity_level', value: userInfo['activity_level'].toString());
    // await storage.write(key: 'created_at', value: userInfo['created_at']);
  }
}
