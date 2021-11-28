import 'package:exon_app/core/controllers/login_controller.dart';
import 'package:exon_app/ui/pages/login/login_email_page.dart';
import 'package:exon_app/ui/pages/login/login_password_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      const LoginEmailPage(),
      const LoginPasswordPage(),
    ];
    if (controller.page < 0 || controller.page >= _pages.length) {
      controller.jumpToPage(0);
    }
    return GetBuilder<LoginController>(
      builder: (_) {
        return Scaffold(body: _pages[_.page]);
      },
    );
  }
}
