import 'dart:io';

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
    bool _amplifyConfigured = false;

    if (!_amplifyConfigured) {
      Amplify.addPlugins([auth, analytics]);
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

  static Future signUserInWithAuthCode(String authCode) async {
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

    final tokenData = response.data;
    final idToken = CognitoIdToken(tokenData['id_token']);
    final accessToken = CognitoAccessToken(tokenData['access_token']);
    final refreshToken = CognitoRefreshToken(tokenData['refresh_token']);
    final session =
        CognitoUserSession(idToken, accessToken, refreshToken: refreshToken);

    final userPool = CognitoUserPool(cognitoPoolId, cognitoClientId);
    final user = CognitoUser(null, userPool, signInUserSession: session);
    print(response);
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
}
