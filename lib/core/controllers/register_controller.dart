import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/helpers/transformers.dart';

class RegisterController extends GetxController {
  static RegisterController to = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController phoneAuthNumController = TextEditingController();
  RxInt page = 0.obs;
  RxBool phoneAuthNumSent = false.obs;
  RxBool phoneAuthenticated = false.obs;

  // void jumpToPage(int pageNum) {
  //   page.value = pageNum;
  //   update();
  // }
}

class RegisterOptionalInfoController extends GetxController {
  static RegisterOptionalInfoController to = Get.find();
  int page = 0;
  DateTime? birthDate;
  Gender? gender;
  double? height;
  double? weight;
  double? bodyFatPercentage;
  double? muscleMass;
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
