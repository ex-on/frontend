import 'dart:async';
import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:exon_app/core/services/amplify_service.dart';
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
  static AuthController to = AuthController();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void _asyncMethod() async {
    var refreshToken = await storage.read(key: 'refresh_token');
    var allTokens = await storage.readAll();
    allTokens.forEach((key, value) {
      print(key);
      print(value);
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
}
