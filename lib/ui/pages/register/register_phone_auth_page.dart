import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/buttons.dart';
import 'package:exon_app/ui/widgets/header.dart';
import 'package:exon_app/ui/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPhoneAuthPage extends GetView<RegisterController> {
  const RegisterPhoneAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '휴대폰 번호를 입력해주세요';
    const String _textFieldLabelText = '휴대폰 번호';
    const String _authNumTextFieldLabelText = '인증번호 확인';
    const String _sendAuthNumButtonText = '인증번호 전송';
    const String _checkAuthNumButtonText = '인증번호 확인';
    const String _nextButtonText = '다음';
    final double _height = Get.height;

    void _onBackPressed() {
      controller.page++;
      controller.phoneAuthNumSent.value = false;
      controller.phoneAuthenticated.value = false;
    }

    void _onSendAuthNumPressed() {
      controller.phoneAuthNumSent.value = true;
    }

    void _onCheckAuthNumPressed() {
      controller.phoneAuthenticated.value = true;
    }

    void _onNextPressed() {
      controller.page++;
      controller.phoneAuthNumSent.value = false;
      controller.phoneAuthenticated.value = false;
    }

    return Obx(() {
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputTextField(
                      label: _textFieldLabelText,
                      controller: controller.phoneNumController,
                    ),
                    controller.phoneAuthNumSent.value
                        ? const SizedBox(height: 20)
                        : const SizedBox(height: 0),
                    controller.phoneAuthNumSent.value
                        ? InputTextField(
                            label: _authNumTextFieldLabelText,
                            controller: controller.phoneAuthNumController)
                        : const SizedBox(height: 0),
                  ],
                ),
              ],
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.phoneAuthNumSent.value
                  ? (controller.phoneAuthenticated.value
                      ? ElevatedActionButton(
                          buttonText: _nextButtonText,
                          onPressed: _onNextPressed,
                        )
                      : ElevatedActionButton(
                          buttonText: _checkAuthNumButtonText,
                          onPressed: _onCheckAuthNumPressed,
                        ))
                  : ElevatedActionButton(
                      buttonText: _sendAuthNumButtonText,
                      onPressed: _onSendAuthNumPressed,
                    ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      );
    });
  }
}
