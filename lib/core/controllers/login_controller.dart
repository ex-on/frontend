import 'package:exon_app/core/services/amplify_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController to = Get.find();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int page = 0;
  bool isEmailValid = false;
  bool isPasswordRegexValid = false;
  bool isPasswordVisible = false;
  bool passwordInvalidError = false;

  void jumpToPage(int pageNum) {
    page = pageNum;
    update();
  }

  void setEmailValid(bool val) {
    isEmailValid = val;
    update();
  }

  void setPasswordRegexValid(bool val) {
    isPasswordRegexValid = val;
    update();
  }

  void setPasswordInvalidError(bool val) {
    passwordInvalidError = val;
    update();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void reset() {
    emailController.clear();
    passwordController.clear();
    page = 0;
    isEmailValid = false;
    isPasswordRegexValid = false;
    isPasswordVisible = false;
    passwordInvalidError = false;
  }

  Future<bool> login() async {
    var loginRes = await AmplifyService.signInWithUsernameAndPassword(
        emailController.text, passwordController.text);
    setPasswordInvalidError(!loginRes);
    update();
    print(loginRes);
    return loginRes;
  }
}
