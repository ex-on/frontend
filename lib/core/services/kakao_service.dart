import 'package:kakao_flutter_sdk/all.dart';

class KakaoService {
  static _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      var tokenManger = DefaultTokenManager();
      tokenManger.setToken(token);
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
      // String authCode = await AuthCodeClient.instance.requestWithTalk(
      //     redirectUri:
      //         'kakao9289c2192aae86a9837cf14e90664ffd://oauth/register_optional_info');
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
