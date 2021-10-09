import 'package:exon_app/core/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthPhysicalInfoPage extends StatelessWidget {
  final AuthController authController = AuthController.authControl;
  AuthPhysicalInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _titleText = '신체를 업그레이드할 준비가 되셨나요?';
    const _titleLabelText = '원활한 서비스 제공을 위해 신체 정보를 알려주세요';

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                _titleText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                ),
              ),
              Text(
                _titleLabelText,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
