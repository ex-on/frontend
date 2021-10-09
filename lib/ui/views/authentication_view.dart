import 'package:exon_app/core/controllers/auth_controller.dart';
import 'package:exon_app/ui/pages/auth/auth_landing_page.dart';
import 'package:exon_app/ui/pages/auth/auth_physical_info_page.dart';
import 'package:flutter/material.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthenticationPageView(),
    );
  }
}

class AuthenticationPageView extends StatelessWidget {
  final AuthController authController = AuthController.authControl;
  final List<Widget> _pages = [
    AuthLandingPage(),
    AuthPhysicalInfoPage(),
  ];
  AuthenticationPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: _pages,
      controller: authController.pageController,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
