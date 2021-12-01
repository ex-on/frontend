import 'dart:ffi';

import 'package:exon_app/core/controllers/login_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPasswordPage extends StatelessWidget {
  const LoginPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<LoginController>(LoginController());
    const String _titleText = '비밀번호를 입력해 주세요';
    const String _textFieldLabelText = '비밀번호';
    const String _loginButtonText = '로그인';
    final double _height = Get.height;

    void _onBackPressed() {
      controller.jumpToPage(0);
    }

    void _onLoginPressed() async {
      var loginRes = await controller.login();
      controller.formKey.currentState!.validate();
      if (loginRes) {
        Get.offAllNamed('/home');
        controller.reset();
      }
    }

    void _togglePasswordVisibility() {
      controller.togglePasswordVisibility();
    }

    String? _passwordValidator(String? text) {
      const pattern = r'^([A-Za-z0-9!@#\$&*~]){8,}$';
      final regExp = RegExp(pattern);
      if (text == null || text.isEmpty) {
        return '비밀번호를 입력해주세요';
      } else if (text.length < 8) {
        return '비밀번호가 너무 짧아요';
      }
      if (!regExp.hasMatch(text)) {
        return '비밀번호 형식이 올바르지 않아요';
      } else if (controller.passwordInvalidError) {
        return '비밀번호가 일치하지 않아요';
      } else {
        return null;
      }
    }

    void _onPasswordChanged(String text) {
      controller.setPasswordInvalidError(false);
      bool isValid = controller.formKey.currentState!.validate();
      controller.setPasswordRegexValid(isValid);
    }

    return Stack(
      children: [
        Column(
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
                          ],
                        ),
                      ),
                      verticalSpacer(45),
                      Form(
                        key: controller.formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: GetBuilder<LoginController>(builder: (_) {
                          return InputTextField(
                            label: _textFieldLabelText,
                            controller: controller.passwordController,
                            validator: _passwordValidator,
                            obscureText: !_.isPasswordVisible,
                            isPassword: true,
                            onChanged: _onPasswordChanged,
                            icon: IconButton(
                              icon: _.isPasswordVisible
                                  ? const Icon(Icons.visibility_off_rounded)
                                  : const Icon(Icons.visibility_rounded),
                              onPressed: _togglePasswordVisibility,
                            ),
                          );
                        }),
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
                  GetBuilder<LoginController>(builder: (_) {
                    return ElevatedActionButton(
                      buttonText: _loginButtonText,
                      onPressed: _onLoginPressed,
                      activated:
                          _.isPasswordRegexValid && !_.passwordInvalidError,
                    );
                  }),
                ]),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
        GetBuilder<LoginController>(
          builder: (_) {
            if (_.loading) {
              return const LoadingIndicator();
            } else {
              return horizontalSpacer(0);
            }
          },
        ),
      ],
    );
  }
}
