import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/pages/register/register_birth_date_gender_page.dart';
import 'package:exon_app/ui/pages/register/register_email_page.dart';
import 'package:exon_app/ui/pages/register/register_password_page.dart';
import 'package:exon_app/ui/pages/register/register_phone_auth_page.dart';
import 'package:exon_app/ui/pages/register/register_physical_info_page.dart';
import 'package:exon_app/ui/pages/register/register_username_page.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationView extends GetView<RegisterController> {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      const RegisterEmailPage(),
      const RegisterPasswordPage(),
      // const RegisterUsernamePage(),
      const RegisterPhoneAuthPage(),
    ];
    if (controller.page < 0 || controller.page >= _pages.length) {
      controller.jumpToPage(0);
    }
    return GetBuilder<RegisterController>(
      builder: (_) {
        return Scaffold(body: _pages[_.page]);
      },
    );
  }
}

class RegisterInfoView extends GetView<RegisterInfoController> {
  const RegisterInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      const RegisterUsernamePage(),
      const RegisterBirthDateGenderPage(),
      const RegisterPhysicalInfoPage(),
    ];
    if (controller.page < 0 || controller.page >= _pages.length) {
      controller.jumpToPage(0);
    }

    return GetBuilder<RegisterInfoController>(
      builder: (_) {
        return Scaffold(
          body: _pages[_.page],
        );
      },
    );
  }
}
