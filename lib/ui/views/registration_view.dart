import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/pages/register/register_email_page.dart';
import 'package:exon_app/ui/pages/register/register_password_page.dart';
import 'package:exon_app/ui/pages/register/register_phone_auth_page.dart';
import 'package:exon_app/ui/pages/register/register_username_page.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
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

class RegisterPhysicalInfoView extends GetView<RegisterPhysicalInfoController> {
  const RegisterPhysicalInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '신체를 업그레이드할 준비가 되셨나요?';
    const String _titleLabelText = '원활한 서비스 제공을 위해 신체 정보를 알려주세요';
    const String _startButtonText = '시작하기';
    final double _height = Get.height;

    void _onBackPressed() {
      Get.back();
    }

    void _onStartPressed() {
      Get.offAllNamed('/home');
    }

    return Scaffold(
      body: Column(
        children: [
          Header(onPressed: _onBackPressed),
          Expanded(
            child: DisableGlowListView(
              children: [
                SizedBox(
                  height: 0.025 * _height,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 330,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _titleText,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            _titleLabelText,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //todo: add input fields
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ElevatedActionButton(
            buttonText: _startButtonText,
            onPressed: _onStartPressed,
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
