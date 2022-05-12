import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/core/services/kakao_service.dart';
import 'package:exon_app/helpers/url_launcher.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:get/get.dart';

const String _title = '환영합니다';
const String _titleLabel = 'EXON에서 운동을 기록하고\n사람들과 공유해보세요';
const String _kakaoLoginButtonText = '카카오 로그인';
const String _appleLoginButtonText = 'Apple로 로그인';
const String _googleLoginButtonText = 'Google 계정으로 로그인';
const String _facebookLoginButtonText = 'Facebook으로 로그인';
const String _registerButtonText = '회원가입';
const String _loginLabelText = '이미 계정이 있으신가요?';
const String _loginButtonText = '로그인';
const Color _registerButtonColor = Color(0xffEEEEEE);
final Color _kakaoLoginTextColor = Colors.black.withOpacity(0.85);
final Color _googleLoginTextColor = Colors.black.withOpacity(0.54);
const Color _facebookLoginTextColor = Colors.white;
const String _privacyPolicyUrl = endPointUrl + '/user/policy/privacy';
const String _termsOfUseUrl = endPointUrl + '/user/policy/terms_of_use';

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
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AppleLoginButton(
            onPressed: () => UrlLauncher.launchInApp(
              AmplifyService.getSocialLoginUrl('SignInWithApple'),
            ),
          ),
          KakaoLoginButton(
            onPressed: _onKakaoLoginPressed,
          ),
          GoogleLoginButton(
            onPressed: () => UrlLauncher.launchInApp(
              AmplifyService.getSocialLoginUrl('Google'),
            ),
          ),
          FacebookLoginButton(
            onPressed: () => UrlLauncher.launchInApp(
              AmplifyService.getSocialLoginUrl('Facebook'),
            ),
          ),
          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              child: const Text(
                _registerButtonText,
                style: TextStyle(
                  color: clearBlackColor,
                ),
              ),
              onPressed: () => Get.toNamed('/register'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(_registerButtonColor),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
              ),
            ),
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
      crossAxisAlignment: WrapCrossAlignment.center,
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
          onPressed: () => UrlLauncher.launchInApp(_termsOfUseUrl),
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
          onPressed: () => UrlLauncher.launchInApp(_privacyPolicyUrl),
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

class KakaoLoginButton extends StatelessWidget {
  final Function() onPressed;
  const KakaoLoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _style = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(kakaoLoginColor),
      elevation: MaterialStateProperty.all(0),
    );

    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _style,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: KakaoIcon(
                height: 16,
              ),
            ),
            Text(
              _kakaoLoginButtonText,
              style: TextStyle(
                color: _kakaoLoginTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppleLoginButton extends StatelessWidget {
  final Function() onPressed;
  const AppleLoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _style = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.black),
      overlayColor: MaterialStateProperty.all(Colors.black),
      elevation: MaterialStateProperty.all(0),
    );

    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _style,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 3),
              child: AppleWhiteIcon(
                height: 50,
                width: 50,
              ),
            ),
            const Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _appleLoginButtonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 21.5,
                  ),
                ),
              ),
            ),
            horizontalSpacer(20),
          ],
        ),
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  final Function() onPressed;
  const GoogleLoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _style = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(Colors.white),
      overlayColor: MaterialStateProperty.all(lightGrayColor.withOpacity(0.15)),
      elevation: MaterialStateProperty.all(1),
    );

    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _style,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            horizontalSpacer(8),
            const Padding(
              padding: EdgeInsets.only(right: 24),
              child: GoogleIcon(
                width: 18,
              ),
            ),
            Text(
              _googleLoginButtonText,
              style: TextStyle(
                color: _googleLoginTextColor,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            horizontalSpacer(8),
          ],
        ),
      ),
    );
  }
}

class FacebookLoginButton extends StatelessWidget {
  final Function() onPressed;
  const FacebookLoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _style = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(facebookLoginColor),
      elevation: MaterialStateProperty.all(0),
    );

    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _style,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: FacebookIcon(
                height: 28,
              ),
            ),
            Text(
              _facebookLoginButtonText,
              style: TextStyle(
                color: _facebookLoginTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
