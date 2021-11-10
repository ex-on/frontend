import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterEmailPage extends GetView<RegisterController> {
  const RegisterEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '반갑습니다!';
    const String _titleLabelText = '회원가입을 위한 이메일을 입력해주세요';
    const String _textFieldLabelText = '이메일';
    const String _nextButtonText = '다음';
    final double _height = Get.height;

    void _onBackPressed() {
      Get.back();
    }

    void _onNextPressed() {
      controller.page++;
    }

    return Column(
      children: [
        Header(onPressed: _onBackPressed),
        Expanded(
          child: DisableGlowListView(
            padding: const EdgeInsets.only(top: 20),
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputTextField(
                    label: _textFieldLabelText,
                    controller: controller.emailController,
                  ),
                ],
              ),
            ],
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedActionButton(
              buttonText: _nextButtonText,
              onPressed: _onNextPressed,
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
