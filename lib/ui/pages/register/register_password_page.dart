import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPasswordPage extends GetView<RegisterController> {
  const RegisterPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '비밀번호를 입력해주세요';
    const String _titleLabelText = '영문자, 숫자, 특수문자를\n각각 하나 이상 포함해야 합니다';
    const String _passwordInputFieldLabelText = '비밀번호';
    const String _passwordCheckFieldLabelText = '비밀번호 확인';
    const String _nextButtonText = '다음';
    final double _height = Get.height;

    void _onBackPressed() {
      controller.page--;
    }

    void _onNextPressed() {
      controller.page++;
    }

    return Column(
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputTextField(
                    label: _passwordInputFieldLabelText,
                    controller: controller.passwordInputController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InputTextField(
                    label: _passwordCheckFieldLabelText,
                    controller: controller.passwordCheckController,
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
        verticalSpacer(50),
      ],
    );
  }
}
