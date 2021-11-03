import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/auth.dart';

class KakaoService {
  static _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      TokenManager.instance.setToken(token);
      print(token.toJson());
      return token.toJson();
    } catch (e) {
      print(e);
    }
  }

  static loginWithKakao() async {
    try {
      String authCode = await AuthCodeClient.instance.request();
      var token = await _issueAccessToken(authCode);
      return token.map((key, value) => MapEntry(key, value?.toString()));
    } catch (e) {
      print(e);
    }
  }

  static loginWithKakaoTalk() async {
    try {
      String authCode = await AuthCodeClient.instance.requestWithTalk();
      var token = await _issueAccessToken(authCode);
      return token.map((key, value) => MapEntry(key, value?.toString()));
    } catch (e) {
      print(e);
    }
  }

  static void logoutKakaoTalk() async {
    try {
      var code = await UserApi.instance.logout();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }

  static void unlinkKakaoTalk() async {
    try {
      var code = await UserApi.instance.unlink();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }
}
