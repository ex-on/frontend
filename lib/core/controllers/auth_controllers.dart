import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/core/services/api_service.dart';
import 'package:exon_app/helpers/parse_jwt.dart';
import 'package:flutter/material.dart';
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

  @override
  void onInit() {
    super.onInit();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
      getUserInfo();
    });
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void _asyncMethod() async {
    var refreshToken = await storage.read(key: 'refresh_token');
    var allTokens = await storage.readAll();
    allTokens.forEach((key, value) {
      log(key);
      log(value);
    });
    Timer(const Duration(seconds: 1), () async {
      if (refreshToken != null) {
        var accessToken = await storage.read(key: 'access_token');
        if (parseJwt(accessToken!)["exp"] * 1000 <
            DateTime.now().millisecondsSinceEpoch) {
          AmplifyService.getTokensWithRefreshToken(refreshToken);
        }
        Get.offNamed('/home');
      } else {
        Get.offNamed('/auth');
      }
    });
  }

  Future<void> getUserInfo() async {
    bool userInfoStored = await storage.containsKey(key: 'username') &&
        await storage.containsKey(key: 'profile_icon') &&
        await storage.containsKey(key: 'created_at');
    print(userInfo);
    if (userInfoStored) {
      Map<String, dynamic> storedUserInfo = {
        'username': await storage.read(key: 'username'),
        'profile_icon': await storage.read(key: 'profile_icon'),
        'created_at': await storage.read(key: 'created_at'),
      };
      if (storedUserInfo['username'] != null &&
          storedUserInfo['profile_icon'] != null &&
          storedUserInfo['created_at'] != null) {
        userInfo = storedUserInfo;
        update();
        return;
      } else {
        storage.delete(key: 'username');
        storage.delete(key: 'profile_icon');
        storage.delete(key: 'created_at');
      }
    }
    userInfo = await ApiService.getUserInfo();
    update();
    storage.write(key: 'username', value: userInfo['username']);
    storage.write(key: 'profile_icon', value: userInfo['profile_icon'].toString());
    storage.write(key: 'created_at', value: userInfo['created_at']);
  }
}
