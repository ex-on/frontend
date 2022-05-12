import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrapped_korean_text/wrapped_korean_text.dart';

class RegisterPasswordPage extends GetView<RegisterController> {
  const RegisterPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '비밀번호를 입력해주세요';
    const String _titleLabelText = '영문자, 숫자, 특수문자를 각각 하나 이상 포함하고, 8자 이상이어야 합니다';
    const String _passwordInputFieldLabelText = '비밀번호';
    const String _passwordCheckFieldLabelText = '비밀번호 확인';
    const String _nextButtonText = '다음';
    final double _height = Get.height;
    bool _passwordCheckInput = false;

    void _onBackPressed() {
      controller.toPreviousPage();
    }

    void _onNextPressed() {
      controller.toNextPage();
    }

    void _togglePasswordInputVisibility() {
      controller.togglePasswordInputVisibility();
    }

    void _togglePasswordCheckVisibility() {
      controller.togglePasswordCheckVisibility();
    }

    String? _passwordInputValidator(String? text) {
      const pattern = r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      final regExp = RegExp(pattern);
      if (text == null || text.isEmpty) {
        return '비밀번호를 입력해주세요';
      } else if (text.length < 8) {
        return '8자 이상의 비밀번호를 입력해주세요';
      }
      if (!regExp.hasMatch(text)) {
        return '비밀번호 형식이 올바르지 않아요';
      } else {
        return null;
      }
    }

    String? _passwordCheckValidator(String? text) {
      if ((text != controller.passwordInputController.text) &&
          !_passwordCheckInput) {
        return '비밀번호가 일치하지 않아요';
      } else {
        return null;
      }
    }

    void _onPasswordFormChanged(String text) {
      bool isValid = controller.formKey.currentState!.validate();
      controller.setPasswordFormValid(isValid);
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
              Form(
                key: controller.formKey,
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
                    const SizedBox(
                      height: 20,
                    ),
                    GetBuilder<RegisterController>(builder: (_) {
                      return InputTextField(
                        icon: IconButton(
                          icon: _.passwordInputVisible
                              ? const Icon(Icons.visibility_off_rounded)
                              : const Icon(Icons.visibility_rounded),
                          onPressed: _togglePasswordInputVisibility,
                        ),
                        obscureText: !_.passwordInputVisible,
                        label: _passwordInputFieldLabelText,
                        controller: controller.passwordInputController,
                        validator: _passwordInputValidator,
                        onChanged: _onPasswordFormChanged,
                        isPassword: true,
                      );
                    }),
                    verticalSpacer(30),
                    GetBuilder<RegisterController>(builder: (_) {
                      return InputTextField(
                        icon: IconButton(
                          icon: _.passwordCheckVisible
                              ? const Icon(Icons.visibility_off_rounded)
                              : const Icon(Icons.visibility_rounded),
                          onPressed: _togglePasswordCheckVisibility,
                        ),
                        obscureText: !_.passwordCheckVisible,
                        label: _passwordCheckFieldLabelText,
                        controller: controller.passwordCheckController,
                        validator: _passwordCheckValidator,
                        onChanged: (String text) {
                          _onPasswordFormChanged(text);
                          if (!_passwordCheckInput) {
                            _passwordCheckInput = true;
                          }
                        },
                        isPassword: true,
                      );
                    }),
                    verticalSpacer(50),
                  ],
                ),
              ),
            ],
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<RegisterController>(
              builder: (_) {
                return ElevatedActionButton(
                    buttonText: _nextButtonText,
                    onPressed: _onNextPressed,
                    activated: _.isPasswordFormValid);
              },
            ),
          ],
        ),
        verticalSpacer(50),
      ],
    );
  }
}
