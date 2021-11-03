import 'dart:io';
import 'dart:typed_data';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:exon_app/amplifyconfiguration.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dio/dio.dart';
import 'package:exon_app/constants/constants.dart';

class AmplifyService {
  static String getSocialLoginUrl(String identityProvider) {
    return 'https://$cognitoPoolUrl.amazoncognito.com/'
        'oauth2/authorize?identity_provider=$identityProvider'
        '&redirect_uri=$redirectUri'
        '&response_type=CODE&client_id=$cognitoClientId'
        '&scope=email openid phone aws.cognito.signin.user.admin';
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
      } catch (e) {
        print(e);
      }
    }

    if (_amplifyConfigured) {
      print('Successfully configured Amplify🎉');
    }
  }

  static Future getUserAuthToken(String authCode) async {
    var dio = Dio();
    String url = "https://$cognitoPoolUrl.amazoncognito.com/oauth2/token";

    final response = await dio.post(
      url,
      data: {
        "grant_type": "authorization_code",
        "client_id": cognitoClientId,
        "code": authCode,
        "redirect_uri": redirectUri,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("Received bad status code from Cognito for auth code:" +
          response.statusCode.toString() +
          "; body: " +
          response.data);
    }
    print(response);
    return response.data;
  }

  static Future signUserInWithAuthToken(Map<String, String> tokenData) async {
    final idToken = CognitoIdToken(tokenData['id_token']);
    final accessToken = CognitoAccessToken(tokenData['access_token']);
    final refreshToken = CognitoRefreshToken(tokenData['refresh_token']);
    final session =
        CognitoUserSession(idToken, accessToken, refreshToken: refreshToken);

    final userPool = CognitoUserPool(cognitoPoolId, cognitoClientId);
    final user = CognitoUser(null, userPool, signInUserSession: session);
    print(session);
    // NOTE: in order to get the email from the list of user attributes, make sure you select email in the list of
    // attributes in Cognito and map it to the email field in the identity provider.
    final attributes = await user.getUserAttributes();
    for (CognitoUserAttribute attribute in attributes!) {
      if (attribute.getName() == "email") {
        user.username = attribute.getValue();
        break;
      }
    }

    print("login successfully.");
    print(user.username);
    return user;
  }

  static Future signUserInWithKakaoLogin(String accessToken) async {
    const apiName = 'kakaoLogin';
    const path = '/user/login';
    var body =
        Uint8List.fromList('{"access_token": "$accessToken"}'.codeUnits);
    try {
      RestOptions options = RestOptions(
        apiName: apiName,
        path: path,
        body: body,
      );
      RestOperation restOperation = Amplify.API.post(restOptions: options);
      RestResponse response = await restOperation.response;
      print('POST call succeeded');
      print(String.fromCharCodes(response.data));
    } on RestException catch (e) {
      print('POST call failed: $e');
    }
  }
}
