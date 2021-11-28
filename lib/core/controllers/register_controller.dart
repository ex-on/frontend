import 'dart:async';

import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/dummy_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/helpers/transformers.dart';

class RegisterController extends GetxController {
  static RegisterController to = Get.find();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  // TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  Timer? verificationCodeTimeLimitCounter;
  int page = 0;
  bool isEmailValid = false;
  bool isEmailAvailable = true;
  bool isPasswordFormValid = false;
  // bool isUsernameValid = false;
  // bool isUsernameAvailable = false;
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

  // void checkAvailableEmail() async {
  // todo
  // update();
  // }

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

// // Username control
//   void setUsernameValid(bool val) {
//     isUsernameValid = val;
//     update();
//   }

//   void checkAvailableUsername() {
//     isUsernameAvailable =
//         !DummyDataController.to.usernameList.contains(usernameController.text);
//     update();
//   }

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
    
  }
}

class RegisterInfoController extends GetxController {
  static RegisterInfoController to = Get.find();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  int page = 0;
  DateTime? birthDate;
  Gender? gender;
  double? height;
  double? weight;
  double? bodyFatPercentage;
  double? muscleMass;
  bool isUsernameValid = false;
  bool isUsernameAvailable = false;
  bool isBirthDateFieldOpen = false;
  bool isGenderFieldOpen = false;
  bool isHeightFieldOpen = false;
  bool isWeightFieldOpen = false;
  bool isBodyFatPercentageFieldOpen = false;
  bool isMuscleMassFieldOpen = false;

  void jumpToPage(int pageNum) {
    page = pageNum;
    update();
  }

  // Username control
  void setUsernameValid(bool val) {
    isUsernameValid = val;
    update();
  }

  void checkAvailableUsername() {
    isUsernameAvailable =
        !DummyDataController.to.usernameList.contains(usernameController.text);
    update();
  }

  void toggleBirthDateField() {
    isBirthDateFieldOpen = !isBirthDateFieldOpen;
    update();
  }

  void toggleGenderField() {
    isGenderFieldOpen = !isGenderFieldOpen;
    update();
  }

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

  void updateBirthDate(DateTime date) {
    birthDate = date;
    update();
  }

  void updateGender(Gender? val) {
    gender = val;
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
}
