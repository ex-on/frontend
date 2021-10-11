import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController registerController = Get.find();
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

class RegisterPhysicalInfoController extends GetxController {
  static RegisterPhysicalInfoController registerPhysicalInfoController = Get.find();
  Rxn<DateTime> birthDate = Rxn<DateTime>();
  Rxn<int> gender = Rxn<int>();
  Rxn<double> height = Rxn<double>();
  Rxn<double> weight = Rxn<double>();
  Rxn<double> bodyFatPercentage = Rxn<double>();
  Rxn<double> muscleMass = Rxn<double>();
}
