import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/core/services/kakao_service.dart';
import 'package:exon_app/helpers/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:get/get.dart';

const String _title = '환영합니다';
const String _titleLabel = 'EXON에서 운동을 기록하고\n사람들과 공유해보세요';
const String _kakaoLoginButtonText = '카카오로 로그인';
const String _googleLoginButtonText = 'Google로 로그인';
const String _facebookLoginButtonText = '페이스북으로 로그인';
const String _registerButtonText = '회원가입';
const String _loginLabelText = '이미 계정이 있으신가요?';
const String _loginButtonText = '로그인';
const Color _registerButtonColor = Color(0xffEEEEEE);

class AuthLandingView extends GetView<AuthController> {
  AuthLandingView({Key? key}) : super(key: key);
  final kakaoController = Get.put<KakaoLoginController>(KakaoLoginController());

  Future<void> _onKakaoLoginPressed() async {
    dynamic accessToken;
    Get.toNamed('/loading');
    if (kakaoController.isKakaoInstalled) {
      var token = await KakaoService.loginWithKakaoTalk();
      accessToken = token['access_token']!.toString();
    } else {
      var token = await KakaoService.loginWithKakao();
      accessToken = token['access_token'];
    }
    print(accessToken);
    bool success = await AmplifyService.signUserInWithKakaoLogin(accessToken);
    print('success:');
    print(success);
    AuthController.to.setLoading(false);
    if (success) {
      await RegisterInfoController.to.checkUserInfo();
      print('userInfoExists');
      print(RegisterInfoController.to.userInfoExists);
      if (RegisterInfoController.to.userInfoExists) {
        Get.offNamed('/home');
      } else {
        Get.offNamed('/register_info', arguments: 'Kakao');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _titleSection = Align(
      alignment: Alignment.center,
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text(
              _title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _titleLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );

    Widget _registerButtonSection = SizedBox(
      height: 260,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedRouteButton(
              buttonText: _kakaoLoginButtonText,
              backgroundColor: kakaoLoginColor,
              onPressed: _onKakaoLoginPressed),
          ElevatedRouteButton(
            buttonText: _googleLoginButtonText,
            backgroundColor: Colors.white,
            onPressed: () => UrlLauncher.launchInBrowser(
              AmplifyService.getSocialLoginUrl('Google'),
            ),
          ),
          ElevatedRouteButton(
            buttonText: _facebookLoginButtonText,
            backgroundColor: facebookLoginColor,
            onPressed: () => UrlLauncher.launchInBrowser(
              AmplifyService.getSocialLoginUrl('Facebook'),
            ),
          ),
          ElevatedRouteButton(
            buttonText: _registerButtonText,
            backgroundColor: _registerButtonColor,
            onPressed: () => Get.toNamed('/register'),
          ),
        ],
      ),
    );

    Widget _loginButtonSection = Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            _loginLabelText,
            style: TextStyle(fontSize: 12),
          ),
          TextActionButton(
            buttonText: _loginButtonText,
            onPressed: () => Get.toNamed('/login'),
            fontSize: 12,
          ),
        ],
      ),
    );

    Widget _spacer = const SizedBox(
      height: 30,
    );

    Widget _termsOfUseText = Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            '회원가입 시',
            style: TextStyle(fontSize: 10),
          ),
        ),
        TextActionButton(
          buttonText: '이용약관',
          onPressed: () => Get.toNamed('/terms_of_use'),
          fontSize: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            '및',
            style: TextStyle(fontSize: 10),
          ),
        ),
        TextActionButton(
          buttonText: '개인정보처리방침',
          onPressed: () => Get.toNamed('/privacy_policy'),
          fontSize: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            '에 동의한 것으로 간주됩니다',
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _titleSection,
              _registerButtonSection,
              _loginButtonSection,
              _spacer,
              _termsOfUseText,
            ],
          ),
        ),
      ),
    );
  }
}
