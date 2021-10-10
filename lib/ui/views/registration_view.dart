import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/ui/pages/register/register_email_page.dart';
import 'package:exon_app/ui/pages/register/register_password_page.dart';
import 'package:exon_app/ui/pages/register/register_phone_auth_page.dart';
import 'package:exon_app/ui/pages/register/register_username_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationView extends GetView<RegisterController> {
  RegistrationView({Key? key}) : super(key: key);
  final List<Widget> _pages = [
    const RegisterEmailPage(),
    const RegisterPasswordPage(),
    const RegisterUsernamePage(),
    const RegisterPhoneAuthPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.page.value < 0 || controller.page.value >= _pages.length) {
        controller.page.value = 0;
      }
      return Scaffold(body: _pages[controller.page.value]);
    });
  }
}
