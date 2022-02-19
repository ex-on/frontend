import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/ui/pages/register_info/register_birth_date_gender_page.dart';
import 'package:exon_app/ui/pages/register/register_email_page.dart';
import 'package:exon_app/ui/pages/register/register_password_page.dart';
import 'package:exon_app/ui/pages/register/register_phone_auth_page.dart';
import 'package:exon_app/ui/pages/register_info/register_physical_info_page.dart';
import 'package:exon_app/ui/pages/register/register_username_page.dart';
import 'package:exon_app/ui/views/home_navigation_view.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationView extends GetView<RegisterController> {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      const RegisterEmailPage(),
      const RegisterPasswordPage(),
      const RegisterPhoneAuthPage(),
    ];
    if (controller.page < 0 || controller.page >= _pages.length) {
      controller.jumpToPage(0);
    }
    return GetBuilder<RegisterController>(
      builder: (_) {
        return Scaffold(
          body: _pages[_.page],
        );
      },
    );
  }
}

class RegisterInfoView extends GetView<RegisterInfoController> {
  const RegisterInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Get.arguments;
    if (authProvider != null) {
      controller.setAuthProvider(authProvider);
    }

    controller.checkUserInfo();

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
        if (_.userInfoLoading) {
          return const LoadingIndicator(
            route: true,
          );
        } else {
          if (_.userInfoExists) {
            return HomeNavigationView();
          } else {
            return Scaffold(
              body: _pages[_.page],
            );
          }
        }
      },
    );
  }
}
