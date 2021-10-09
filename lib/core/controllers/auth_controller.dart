import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController authControl = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final PageController _pageController = PageController(initialPage: 0);

  final birthDate = DateTime.utc(2001, 01, 01).obs;
  final gender = 0.obs;
  final height = 0.obs;
  final weight = 0.obs;
  final bodyFatPercentage = 0.obs;
  final muscleMass = 0.obs;

  PageController get pageController => _pageController;

  void jumpToPage(int page) {
    _pageController.jumpToPage(page);
  }
}
