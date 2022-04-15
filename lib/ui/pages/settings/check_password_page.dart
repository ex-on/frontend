import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/settings_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckPasswordPage extends GetView<SettingsController> {
  const CheckPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;
    const String _titleText = '현재 비밀번호를 입력해 주세요';
    const String _textFieldLabelText = '비밀번호';
    const String _nextButtonText = '다음';

    void _onBackPressed() {
      Get.back();
      controller.resetPasswordAuthorize();
    }

    void _onNextPressed() async {
      Get.toNamed('/loading');
      var valid = await controller.checkPassword();
      if (valid) {
        controller.passwordJumpToPage(1);
      } else {
        controller.authFormKey.currentState!.validate();
      }
      Get.back();
    }

    void _onPasswordChanged(String text) {
      controller.setPasswordInvalidError(false);
      bool isValid = controller.authFormKey.currentState!.validate();
      controller.setPasswordRegexValid(isValid);
    }

    void _togglePasswordAuthorizeVisibility() {
      controller.togglePasswordAuthorizeVisibility();
    }

    return Column(
      children: [
        Header(onPressed: _onBackPressed),
        Expanded(
          child: GetBuilder<SettingsController>(
            builder: (_) {
              return ListView(
                physics: const ClampingScrollPhysics(),
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
                      verticalSpacer(45),
                      Form(
                        key: _.authFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: InputTextField(
                          icon: IconButton(
                            icon: _.passwordAuthorizeVisible
                                ? const Icon(Icons.visibility_off_rounded)
                                : const Icon(Icons.visibility_rounded),
                            onPressed: _togglePasswordAuthorizeVisibility,
                          ),
                          label: _textFieldLabelText,
                          controller: _.passwordAuthorizeController,
                          validator: _.passwordAuthorizeValidator,
                          obscureText: !_.passwordAuthorizeVisible,
                          onChanged: _onPasswordChanged,
                          isPassword: true,
                        ),
                      ),
                    
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<SettingsController>(
              builder: (_) {
                if (_.loading) {
                  return const CircularProgressIndicator(
                      color: brightPrimaryColor);
                } else {
                  return ElevatedActionButton(
                    buttonText: _nextButtonText,
                    onPressed: _onNextPressed,
                    activated:
                        _.isPasswordRegexValid && !_.passwordInvalidError,
                  );
                }
              },
            ),
          ],
        ),
        verticalSpacer(50),
      ],
    );
  }
}
