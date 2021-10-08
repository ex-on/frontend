import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final birthDate = DateTime.utc(2001, 01, 01).obs;
  final gender = 0.obs;
  final height = 0.obs;
  final weight = 0.obs;
  final bodyFatPercentage = 0.obs;
  final muscleMass = 0.obs;
}
