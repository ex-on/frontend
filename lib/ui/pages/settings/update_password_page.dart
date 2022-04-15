import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/settings_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class UpdatePasswordPage extends GetView<SettingsController> {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;
    const String _titleText = '새 비밀번호를 입력해 주세요';
    const String _titleLabelText = '영문자, 숫자, 특수문자를 각각 하나 이상 포함하고, 8자 이상이어야 합니다';
    const String _inputPasswordFieldLabelText = '비밀번호';
    const String _checkPasswordFieldLabelText = '비밀번호';
    const String _completeButtonText = '다음';

    void _onBackPressed() {
      Get.back();
      controller.resetPasswordUpdate();
    }

    void _onCompletePressed() async {
      Get.toNamed('/loading');
      var valid = await controller.updatePassword();
      if (valid) {
        controller.resetPasswordAuthorize();
        controller.resetPasswordUpdate();
        Get.until((route) => Get.currentRoute == '/settings');
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text(
              '비밀번호가 성공적으로 변경되었어요',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            borderRadius: 10,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            duration: const Duration(seconds: 2),
            isDismissible: false,
            backgroundColor: darkSecondaryColor.withOpacity(0.8),
          ),
        );
      } else {
        controller.updateFormKey.currentState!.validate();
        Get.back();
      }
    }

    void _onPasswordFormChanged(String text) {
      bool isValid = controller.updateFormKey.currentState!.validate();
      print('password check input ' + controller.passwordCheckInput.toString());
      print('isValid ' + isValid.toString());
      controller.setPasswordFormValid(isValid);
    }

    void _togglePasswordInputVisibility() {
      controller.togglePasswordInputVisibility();
    }

    void _togglePasswordCheckVisibility() {
      controller.togglePasswordCheckVisibility();
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
                  Form(
                    key: _.updateFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 330,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  _titleText,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              WrappedKoreanText(
                                _titleLabelText,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpacer(45),
                        InputTextField(
                          icon: IconButton(
                            icon: _.passwordInputVisible
                                ? const Icon(Icons.visibility_off_rounded)
                                : const Icon(Icons.visibility_rounded),
                            onPressed: _togglePasswordInputVisibility,
                          ),
                          label: _inputPasswordFieldLabelText,
                          controller: _.passwordInputController,
                          validator: _.updatePasswordInputValidator,
                          obscureText: !_.passwordInputVisible,
                          onChanged: _onPasswordFormChanged,
                          isPassword: true,
                        ),
                        verticalSpacer(30),
                        InputTextField(
                          icon: IconButton(
                            icon: _.passwordCheckVisible
                                ? const Icon(Icons.visibility_off_rounded)
                                : const Icon(Icons.visibility_rounded),
                            onPressed: _togglePasswordCheckVisibility,
                          ),
                          label: _checkPasswordFieldLabelText,
                          controller: _.passwordCheckController,
                          validator: _.updatePasswordCheckValidator,
                          obscureText: !_.passwordCheckVisible,
                          onChanged: (String text) {
                            _onPasswordFormChanged(text);
                            if (!_.passwordCheckInput) {
                              _.passwordCheckInput = true;
                            }
                          },
                          isPassword: true,
                        ),
                      ],
                    ),
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
                    buttonText: _completeButtonText,
                    onPressed: _onCompletePressed,
                    activated: _.isPasswordFormValid && _.passwordCheckInput,
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
