import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/core/services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  static SettingsController to = Get.find();
  final authFormKey = GlobalKey<FormState>();
  final updateFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordAuthorizeController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  bool loading = false;
  bool privacyCommunity = false;
  bool privacyPhysicalData = false;
  bool isUsernameAvailable = true;
  bool isUsernameValid = false;
  bool isAuthorized = false;
  bool passwordAuthorizeVisible = false;
  bool passwordInputVisible = false;
  bool passwordCheckVisible = false;
  bool passwordInvalidError = false;
  bool isPasswordRegexValid = false;
  bool isPasswordFormValid = false;
  bool passwordCheckInput = false;
  int updatePasswordPage = 0;
  late String appVersion;
  late String buildNumber;

  @override
  void onInit() async {
    super.onInit();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  String? usernameValidator(String? text) {
    const pattern =
        r'^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣._\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]]+(?<![_.])$';
    final regExp = RegExp(pattern);
    if (text == null || text.isEmpty) {
      return '닉네임을 입력해주세요';
    } else if (text.length < 3) {
      return '3글자 이상 입력해주세요';
    } else if (text.length > 20) {
      return '20자 이내로 입력해주세요';
    } else if (!regExp.hasMatch(text)) {
      return '닉네임 형식이 올바르지 않습니다';
    } else {
      if (!isUsernameAvailable) {
        if (usernameController.text != AuthController.to.userInfo['username'] &&
            !loading) {
          return '이미 존재하는 닉네임이에요';
        } else {
          return '현재 닉네임과 동일해요';
        }
      } else {
        return null;
      }
    }
  }

  String? passwordAuthorizeValidator(String? text) {
    const pattern = r'^([A-Za-z0-9!@#\$&*~]){8,}$';
    final regExp = RegExp(pattern);
    if (text == null || text.isEmpty) {
      return '비밀번호를 입력해주세요';
    } else if (text.length < 8) {
      return '비밀번호가 너무 짧아요';
    }
    if (!regExp.hasMatch(text)) {
      return '비밀번호 형식이 올바르지 않아요';
    } else if (passwordInvalidError) {
      return '비밀번호가 일치하지 않아요';
    } else {
      return null;
    }
  }

  String? updatePasswordInputValidator(String? text) {
    const pattern = r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regExp = RegExp(pattern);
    print(passwordAuthorizeController.text);
    if (text == null || text.isEmpty) {
      return '비밀번호를 입력해주세요';
    } else if (text.length < 8) {
      return '8자 이상의 비밀번호를 입력해주세요';
    }
    if (!regExp.hasMatch(text)) {
      return '비밀번호 형식이 올바르지 않아요';
    } else if (text == passwordAuthorizeController.text) {
      return '현재 비밀번호와 동일해요';
    } else {
      return null;
    }
  }

  String? updatePasswordCheckValidator(String? text) {
    print('yo');
    if (text != passwordInputController.text && passwordCheckInput) {
      return '비밀번호가 일치하지 않아요';
    } else {
      return null;
    }
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void passwordJumpToPage(int val) {
    updatePasswordPage = val;
    update();
  }

  void togglePasswordAuthorizeVisibility() {
    passwordAuthorizeVisible = !passwordAuthorizeVisible;
    update();
  }

  void togglePasswordInputVisibility() {
    passwordInputVisible = !passwordInputVisible;
    update();
  }

  void togglePasswordCheckVisibility() {
    passwordCheckVisible = !passwordCheckVisible;
    update();
  }

  void setPasswordInvalidError(bool val) {
    passwordInvalidError = val;
    update();
  }

  void setPasswordRegexValid(bool val) {
    isPasswordRegexValid = val;
    update();
  }

  void setPasswordFormValid(bool val) {
    isPasswordFormValid = val;
    update();
  }

  void resetPasswordAuthorize() {
    passwordAuthorizeController.clear();
    isAuthorized = false;
    passwordAuthorizeVisible = false;
    isPasswordRegexValid = false;
    passwordInvalidError = false;
  }

  void resetPasswordUpdate() {
    passwordInputController.clear();
    passwordCheckController.clear();
    passwordInputVisible = false;
    passwordCheckVisible = false;
    isPasswordFormValid = false;
    passwordCheckInput = false;
    updatePasswordPage = 0;
  }

  void setUsernameValid(bool val) {
    isUsernameValid = val;
    update();
  }

  void onUsernameChanged(String text) async {
    if (usernameController.text.length >= 3 &&
        usernameController.text.length <= 20) {
      setLoading(true);
      await checkAvailableUsername();
      setLoading(false);
    }
    if (authFormKey.currentState != null) {
      bool isValid = authFormKey.currentState!.validate();
      setUsernameValid(isValid);
    }
  }

  void onPasswordAuthorizeChanged(String text) {}

  void resetUsername() {
    usernameController.clear();
  }

  void updatePrivacyAll() {
    bool _allOpen = privacyCommunity && privacyPhysicalData;
    if (_allOpen) {
      privacyCommunity = false;
      privacyPhysicalData = false;
    } else {
      privacyCommunity = true;
      privacyPhysicalData = true;
    }
    update();
  }

  void updatePrivacyCommunity() {
    privacyCommunity = !privacyCommunity;
    update();
  }

  void updatePrivacyPhysicalData() {
    privacyPhysicalData = !privacyPhysicalData;
    update();
  }

  Future<void> checkAvailableUsername() async {
    isUsernameAvailable =
        await UserApiService.checkUsernameAvailable(usernameController.text);
    update();
  }

  Future<bool> updateUsername() async {
    setLoading(true);
    var res = await UserApiService.updateUsername(usernameController.text);
    setLoading(false);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkPassword() async {
    var valid = await AmplifyService.authenticateUser(
        AuthController.to.userInfo['email'], passwordAuthorizeController.text);
    setPasswordInvalidError(!valid);
    return valid;
  }

  Future<bool> updatePassword() async {
    var success = await AmplifyService.updateCognitoPassword(
        passwordAuthorizeController.text, passwordInputController.text);

    return success;
  }

  Future<void> getPrivacySettings() async {}

  Future<bool> signOut() async {
    setLoading(true);
    var signOutRes = await AmplifyService.signOut(
        RegisterController.to.emailController.text);
    AuthController.to.reset();
    HomeNavigationController.to.reset();
    setLoading(false);
    return signOutRes;
  }
}
