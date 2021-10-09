import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController registerControl = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  var page = 0.obs;

  void jumpToPage(int pageNum) {
    page.value = pageNum;
    update(); 
  }
}
