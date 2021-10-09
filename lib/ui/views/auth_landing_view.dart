import 'package:flutter/material.dart';
import 'package:exon_app/ui/widgets/buttons.dart';
import 'package:exon_app/constants/colors.dart';
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

class AuthLandingView extends StatelessWidget {
  const AuthLandingView({Key? key}) : super(key: key);

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
          ElevatedActionButton(
              buttonText: _kakaoLoginButtonText,
              backgroundColor: kakaoLoginColor,
              onPressed: () => Get.toNamed('/register')),
          ElevatedActionButton(
            buttonText: _googleLoginButtonText,
            backgroundColor: Colors.white,
            onPressed: () => Get.toNamed('/register'),
          ),
          ElevatedActionButton(
            buttonText: _facebookLoginButtonText,
            backgroundColor: facebookLoginColor,
            onPressed: () => Get.toNamed('/register'),
          ),
          ElevatedActionButton(
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
        children: const [
          Text(
            _loginLabelText,
            style: TextStyle(fontSize: 12),
          ),
          TextActionButton(
            buttonText: _loginButtonText,
            route: '/login',
            fontSize: 12,
          ),
        ],
      ),
    );

    Widget _termsOfUseText = Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: const [
        Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Text(
            '회원가입 시',
            style: TextStyle(fontSize: 10),
          ),
        ),
        TextActionButton(
          buttonText: '이용약관',
          route: '/terms_of_use',
          fontSize: 10,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            '및',
            style: TextStyle(fontSize: 10),
          ),
        ),
        TextActionButton(
          buttonText: '개인정보처리방침',
          route: '/privacy_policy',
          fontSize: 10,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Text(
            '에 동의한 것으로 간주됩니다',
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _titleSection,
          _registerButtonSection,
          _loginButtonSection,
          _termsOfUseText,
        ],
      ),
    );
  }
}
