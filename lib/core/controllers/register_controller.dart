import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController registerControl = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController phoneAuthNumController = TextEditingController();
  RxInt page = 0.obs;
  RxBool phoneAuthNumSent = false.obs;
  RxBool phoneAuthenticated = false.obs;

  void jumpToPage(int pageNum) {
    page.value = pageNum;
    update();
  }
}
