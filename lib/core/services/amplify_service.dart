import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:exon_app/amplifyconfiguration.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dio/dio.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AmplifyService {
  static String getSocialLoginUrl(String identityProvider) {
    return 'https://$cognitoPoolUrl.amazoncognito.com/'
        'oauth2/authorize?identity_provider=$identityProvider'
        '&redirect_uri=$redirectUri'
        '&response_type=CODE&client_id=$cognitoClientId'
        '&scope=email+openid+phone+aws.cognito.signin.user.admin';
  }

  static configureAmplify() async {
    final auth = AmplifyAuthCognito(); // Auth 서비스 생성
    final analytics = AmplifyAnalyticsPinpoint(); // Analytics 서비스 생성
    final api = AmplifyAPI();
    bool _amplifyConfigured = false;

    if (!_amplifyConfigured) {
      Amplify.addPlugins([auth, analytics, api]);
      try {
        await Amplify.configure(amplifyconfig);
        _amplifyConfigured = true;
      } on AmplifyAlreadyConfiguredException {
        print(
            "Tried to reconfigure Amplify; this can occur when your app restarts on OS.");
      } on AmplifyException catch (e) {
        if (e.underlyingException!
            .contains('Amplify has already been configured.')) {
          print('ignore');
        } else {
          throw e;
        }
      }
    }

    if (_amplifyConfigured) {
      print('Successfully configured Amplify🎉');
    }
  }

  static Future<bool> getAuthTokensWithAuthCode(String authCode) async {
    var dio = Dio();
    const String url = 'https://$cognitoPoolUrl.amazoncognito.com/oauth2/token';
    try {
      var response = await dio.post(
        url,
        data: {
          'grant_type': 'authorization_code',
          'client_id': cognitoClientId,
          'redirect_uri': redirectUri,
          'code': authCode,
        },
        options: Options(headers: {
          "Content-Type": 'application/x-www-form-urlencoded',
        }),
      );
      storeAuthTokens(response.data, 'Cognito_Social');

      return true;
    } catch (e) {
      print('POST call for get auth tokens failed: $e');
      return false;
    }
  }

  static Future<bool> signUserInWithKakaoLogin(String accessToken) async {
    const apiName = 'kakaoLogin';
    const path = '/user/login';
    var body = Uint8List.fromList('{"access_token": "$accessToken"}'.codeUnits);
    try {
      RestOptions options = RestOptions(
        apiName: apiName,
        path: path,
        body: body,
      );
      RestOperation restOperation = Amplify.API.post(restOptions: options);
      RestResponse response = await restOperation.response;
      print('POST call succeeded');
      log(String.fromCharCodes(response.data));
      storeAuthTokens(
          jsonDecode(
              String.fromCharCodes(response.data))["AuthenticationResult"],
          'Kakao');
      return true;
    } on RestException catch (e) {
      print('no');
      print('POST call failed: $e');
      return false;
    } catch (e) {
      print('POST call failed: $e');
      return false;
    }
  }

  static Future<bool> signInWithUsernameAndPassword(
      String email, String password) async {
    var userPool = CognitoUserPool(cognitoPoolId, cognitoClientId);
    var cognitoUser = CognitoUser(email, userPool);
    var authDetails =
        AuthenticationDetails(username: email, password: password);
    try {
      var session = await cognitoUser.authenticateUser(authDetails);
      Map<String, dynamic> tokens = {
        'access_token': session!.getAccessToken().jwtToken,
        'id_token': session.getIdToken().jwtToken,
        'refresh_token': session.getRefreshToken()!.getToken()
      };
      storeAuthTokens(tokens, 'Cognito');
      var storage = const FlutterSecureStorage();
      var read = await storage.readAll();
      read.forEach((key, value) {
        log(key);
        log(value);
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> signUpWithPhoneNum(Map<String, String> userInfo) async {
    var signUpOptions = CognitoSignUpOptions(userAttributes: {
      CognitoUserAttributeKey.phoneNumber: userInfo['phone_number']!,
    });
    try {
      var response = await Amplify.Auth.signUp(
        username: userInfo['username']!,
        password: userInfo['password']!,
        options: signUpOptions,
      );
      print(response.nextStep);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> confirmVerificationCode(
      String email, String verificationCode) async {
    var userPool = CognitoUserPool(cognitoPoolId, cognitoClientId);
    var cognitoUser = CognitoUser(email, userPool);
    try {
      var response = await cognitoUser.confirmRegistration(verificationCode);
      return response;
    } catch (e) {
      var startIndex = e.toString().indexOf('code: ') + 6;
      var endIndex = e.toString().indexOf(', name:');
      var exceptionName = e.toString().substring(startIndex, endIndex);
      print(exceptionName);
      return exceptionName;
    }
  }

  static Future<bool> resendVerificationCode(String email) async {
    var userPool = CognitoUserPool(cognitoPoolId, cognitoClientId);
    var cognitoUser = CognitoUser(email, userPool);
    try {
      var response = await cognitoUser.resendConfirmationCode();
      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> deleteUser(String email) async {
    var userPool = CognitoUserPool(cognitoPoolId, cognitoClientId);
    var cognitoUser = CognitoUser(email, userPool);
    try {
      var response = await cognitoUser.deleteUser();
      return response;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> signOut(String email) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    try {
      storage.delete(key: 'auth_provider');
      storage.delete(key: 'access_token');
      storage.delete(key: 'id_token');
      storage.delete(key: 'refresh_token');
      storage.delete(key: 'username');
      storage.delete(key: 'activity_level');
      storage.delete(key: 'created_at');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static getTokensWithRefreshToken(String refreshToken) async {
    var dio = Dio();
    const String url = 'https://$cognitoPoolUrl.amazoncognito.com/oauth2/token';
    try {
      var response = await dio.post(
        url,
        data: {
          'grant_type': 'refresh_token',
          'client_id': cognitoClientId,
          'refresh_token': refreshToken,
        },
        options: Options(headers: {
          "Content-Type": 'application/x-www-form-urlencoded',
        }),
      );
      storeRefreshedTokens(
          response.data['access_token'], response.data['id_token']);
    } catch (e) {
      print('POST call for refreshing tokens failed: $e');
    }
  }

  static void storeRefreshedTokens(String accessToken, String idToken) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    storage.delete(key: 'access_token');
    storage.delete(key: 'id_token');
    storage.write(key: 'access_token', value: accessToken);
    storage.write(key: 'id_token', value: idToken);
  }

  static void storeAuthTokens(
      Map<String, dynamic> tokens, String authProvider) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    storage.delete(key: 'auth_provider');
    storage.delete(key: 'access_token');
    storage.delete(key: 'id_token');
    storage.delete(key: 'refresh_token');
    switch (authProvider) {
      case 'Kakao':
        storage.write(key: "auth_provider", value: authProvider);
        storage.write(key: "access_token", value: tokens["AccessToken"]);
        storage.write(key: "id_token", value: tokens["IdToken"]);
        storage.write(key: "refresh_token", value: tokens["RefreshToken"]);
        break;
      default:
        storage.write(key: "auth_provider", value: authProvider);
        storage.write(key: "access_token", value: tokens["access_token"]);
        storage.write(key: "id_token", value: tokens["id_token"]);
        storage.write(key: "refresh_token", value: tokens["refresh_token"]);
        break;
    }
  }
}
