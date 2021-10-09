import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/ui/pages/register/register_email_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationView extends StatelessWidget {
  final RegisterController registerController =
      RegisterController.registerControl;
  RegistrationView({Key? key}) : super(key: key);
  final List<Widget> _pages = [
    const RegisterEmailPage(),
  ];

  @override
  Widget build(BuildContext context) {
    print(registerController.page.value);
    return Scaffold(body: _pages[registerController.page.value]);
  }
}
