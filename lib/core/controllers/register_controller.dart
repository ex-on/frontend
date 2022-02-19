import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/core/services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:intl/intl.dart';

class RegisterController extends GetxController {
  static RegisterController to = Get.find();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  Timer? verificationCodeTimeLimitCounter;
  int page = 0;
  bool loading = false;
  bool isEmailValid = true;
  bool isEmailAvailable = true;
  bool isPasswordFormValid = false;
  bool isPhoneNumValid = false;
  bool phoneNumChanged = false;
  bool isVerificationCodeValid = false;
  bool verificationCodeSent = false;
  bool checkingVerificationCode = false;
  bool phoneVerified = false;
  String? phoneVerificationException;

  bool passwordInputVisible = false;
  bool passwordCheckVisible = false;

  RxInt verificationCodeTimeLimit = RxInt(180);

  Timer _createCounter(RxInt time) {
    return Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (time < 0) {
          timer.cancel();
        } else {
          time--;
        }
      },
    );
  }

  // Loading control
  void setLoading(bool val) {
    loading = val;
    update();
  }

  // Page navigation
  void toNextPage() {
    page++;
    update();
  }

  void toPreviousPage() {
    page--;
    update();
  }

  void jumpToPage(int pageNum) {
    page = pageNum;
    update();
  }

// Email control
  void setEmailValid(bool val) {
    isEmailValid = val;
    update();
  }

  void setEmailAvailable() {
    isEmailAvailable = true;
    update();
  }

  Future<void> checkAvailableEmail() async {
    setLoading(true);
    var dio = Dio();
    try {
      isEmailAvailable =
          await UserApiService.checkUserEmailAvailable(emailController.text);
      print(isEmailAvailable);
    } catch (e) {
      print(e);
    }
    update();
    setLoading(false);
  }

// Password control
  void setPasswordFormValid(bool val) {
    isPasswordFormValid = val;
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

// Phone verification control
  void setPhoneNumValid(bool val) {
    isPhoneNumValid = val;
    update();
  }

  void setVerificationCodeValid(bool val) {
    isVerificationCodeValid = val;
    update();
  }

  void setPhoneVerificationCodeSent(bool val) {
    verificationCodeSent = val;
    update();
  }

  void setPhoneVerified(bool val) {
    phoneVerified = val;
    update();
  }

  void setPhoneNumChanged(bool val) {
    phoneNumChanged = val;
    update();
  }

  void resetPhoneVerificationException() {
    phoneVerificationException = null;
    update();
  }

  void sendPhoneVerificationCode() {
    String phoneNum = '+82' + phoneNumController.text.split('-').join();
    Map<String, String> userInfo = {
      'username': emailController.text,
      'password': passwordCheckController.text,
      'email': emailController.text,
      'phone_number': phoneNum,
    };
    AmplifyService.signUpWithPhoneNum(userInfo);
    verificationCodeTimeLimitCounter =
        _createCounter(verificationCodeTimeLimit);
  }

  void resendPhoneVerificationCode() async {
    verificationCodeTimeLimitCounter!.cancel();
    verificationCodeTimeLimit = RxInt(180);
    update();
    if (!phoneNumChanged) {
      AmplifyService.resendVerificationCode(emailController.text);
      verificationCodeTimeLimitCounter =
          _createCounter(verificationCodeTimeLimit);
    } else {
      // var signInRes = await AmplifyService.signInWithUsernameAndPassword(
      //     emailController.text, passwordCheckController.text);
      // if (signInRes) {
      //   var deleteRes = await AmplifyService.deleteUser(emailController.text);
      //   if (deleteRes) {
      sendPhoneVerificationCode();
      //   }
      // }
    }
  }

  void toggleCheckingVerificationCode() {
    checkingVerificationCode = !checkingVerificationCode;
    update();
  }

  void checkVerificationCode() async {
    toggleCheckingVerificationCode();
    var result = await AmplifyService.confirmVerificationCode(
        emailController.text, verificationCodeController.text);

    if (result.runtimeType == bool) {
      phoneVerified = result;
      isVerificationCodeValid = result;
      if (result) {
        verificationCodeTimeLimitCounter!.cancel();
      }
    } else if (result.runtimeType == String) {
      phoneVerificationException = result;
      phoneVerified = false;
      isVerificationCodeValid = false;
    }
    toggleCheckingVerificationCode();
    update();
  }

  void reset() {
    emailController.clear();
    passwordInputController.clear();
    passwordCheckController.clear();
    phoneNumController.clear();
    verificationCodeController.clear();
    if (verificationCodeTimeLimitCounter != null) {
      verificationCodeTimeLimitCounter!.cancel();
    }
    ;
    page = 0;
    loading = false;
    isEmailValid = true;
    isEmailAvailable = true;
    isPasswordFormValid = false;
    isPhoneNumValid = false;
    phoneNumChanged = false;
    isVerificationCodeValid = false;
    verificationCodeSent = false;
    checkingVerificationCode = false;
    phoneVerified = false;
    phoneVerificationException = null;

    passwordInputVisible = false;
    passwordCheckVisible = false;

    verificationCodeTimeLimit = RxInt(180);
    update();
  }
}

class RegisterInfoController extends GetxController {
  static RegisterInfoController to = Get.find();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  int page = 0;
  String authProvider = 'Social';
  DateTime? birthDate;
  Gender? gender;
  double? height;
  double? weight;
  double? bodyFatPercentage;
  double? muscleMass;
  bool userInfoLoading = false;
  bool loading = false;
  bool userInfoExists = false;
  bool isUsernameValid = false;
  bool isUsernameRegexValid = false;
  bool isUsernameAvailable = false;
  bool isBirthDateFieldOpen = false;
  bool isGenderFieldOpen = false;
  bool isHeightFieldOpen = false;
  bool isWeightFieldOpen = false;
  bool isBodyFatPercentageFieldOpen = false;
  bool isMuscleMassFieldOpen = false;

  @override
  void onInit() async {
    // todo: implement onInit
    reset();
    super.onInit();
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }

  // Page navigation control

  void jumpToPage(int pageNum) {
    page = pageNum;
    update();
  }

  // Auth provider control
  void setAuthProvider(String val) {
    authProvider = val;
    update();
  }

  // Username control
  void setUsernameValid(bool val) {
    isUsernameValid = val;
    update();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void setUserInfoLoading(bool val) {
    userInfoLoading = val;
    update();
  }

  void setUsernameRegexValid(bool val) {
    isUsernameRegexValid = val;
    update();
  }

  Future<void> checkAvailableUsername() async {
    isUsernameAvailable =
        await UserApiService.checkUsernameAvailable(usernameController.text);
    update();
  }

  // Birth date, gender control
  void toggleBirthDateField() {
    isBirthDateFieldOpen = !isBirthDateFieldOpen;
    update();
  }

  void toggleGenderField() {
    isGenderFieldOpen = !isGenderFieldOpen;
    update();
  }

  void updateBirthDate(DateTime date) {
    birthDate = date;
    update();
  }

  void updateGender(Gender? val) {
    gender = val;
    update();
  }

  // Physical info control
  void toggleHeightField() {
    isHeightFieldOpen = !isHeightFieldOpen;
    update();
  }

  void toggleWeightField() {
    isWeightFieldOpen = !isWeightFieldOpen;
    update();
  }

  void toggleBodyFatPercentageField() {
    isBodyFatPercentageFieldOpen = !isBodyFatPercentageFieldOpen;
    update();
  }

  void toggleMuscleMassField() {
    isMuscleMassFieldOpen = !isMuscleMassFieldOpen;
    update();
  }

  void updateHeight(double val) {
    height = val;
    update();
  }

  void updateWeight(double val) {
    weight = val;
    update();
  }

  void updateBodyFatPercentage(double val) {
    bodyFatPercentage = val;
    update();
  }

  void updateMuscleMass(double val) {
    muscleMass = val;
    update();
  }

  // Api control
  Future<void> checkUserInfo() async {
    setUserInfoLoading(true);
    userInfoExists = await UserApiService.checkUserInfo();
    update();
    setUserInfoLoading(false);
  }

  void postUserInfo() async {
    String? phoneNumber;
    String? email;
    print('Auth provider:');
    print(authProvider);
    if (authProvider == 'Manual') {
      phoneNumber = RegisterController.to.phoneNumController.text;
      email = RegisterController.to.emailController.text;
    }
    var res = await UserApiService.registerUserInfo(
      authProvider,
      genderToInt[gender]!,
      DateFormat('yyyy-MM-dd').format(birthDate!),
      usernameController.text,
      phoneNumber,
      email,
    );
  }

  void postUserPhysicalInfo() async {
    UserApiService.postUserPhysicalInfo(
        height, weight, muscleMass, bodyFatPercentage);
  }

  // reset
  void reset() {
    page = 0;
    usernameController.clear();
    birthDate = null;
    gender = null;
    height = null;
    weight = null;
    bodyFatPercentage = null;
    muscleMass = null;
    isUsernameValid = false;
    isUsernameAvailable = false;
    isBirthDateFieldOpen = false;
    isGenderFieldOpen = false;
    isHeightFieldOpen = false;
    isWeightFieldOpen = false;
    isBodyFatPercentageFieldOpen = false;
    isMuscleMassFieldOpen = false;
    update();
  }
}
