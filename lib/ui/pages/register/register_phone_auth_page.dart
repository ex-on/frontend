import 'dart:async';
import 'dart:ffi';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPhoneAuthPage extends GetView<RegisterController> {
  const RegisterPhoneAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '휴대폰 번호를 입력해주세요';
    const String _textFieldLabelText = '휴대폰 번호';
    const String _verificationCodeTextFieldLabelText = '인증번호 확인';
    const String _sendVerificationCodeButtonText = '인증번호 전송';
    const String _checkVerificationCodeButtonText = '인증번호 확인';
    const String _resendVerificationCodeButtonText = '인증번호 재전송';
    const String _nextButtonText = '다음';
    final double _height = Get.height;

    void _onBackPressed() {
      controller.toPreviousPage();
      controller.setPhoneVerificationCodeSent(false);
      controller.setPhoneVerified(false);
      controller.resetPhoneVerificationException();
      controller.verificationCodeController.clear();
    }

    void _onSendAuthNumPressed() {
      controller.sendPhoneVerificationCode();
      controller.setPhoneVerificationCodeSent(true);
      controller.setPhoneNumChanged(false);
      Timer(const Duration(milliseconds: 10),
          () => FocusScope.of(context).nextFocus());
    }

    void _onCheckAuthNumPressed() {
      controller.checkVerificationCode();
      FocusScope.of(context).unfocus();
    }

    void _onResendCodePressed() {
      controller.resendPhoneVerificationCode();
      FocusScope.of(context).previousFocus();
    }

    void _onNextPressed() {
      FocusScope.of(context).unfocus();
      Get.toNamed('/register_info');
      AmplifyService.signInWithUsernameAndPassword(
          controller.emailController.text,
          controller.passwordCheckController.text);
      controller.setPhoneVerificationCodeSent(false);
      controller.setPhoneVerified(false);
      controller.resetPhoneVerificationException();
      controller.jumpToPage(0);
    }

    String? _phoneNumValidator(String? text) {
      const pattern = r'^(0{1}1{1}[0-9]{1})[0-9]{8}$';
      final regExp = RegExp(pattern);
      if (text == null || text.isEmpty) {
        return '휴대폰 번호를 입력해주세요';
      } else {
        List<String> splitText = text.split('-');
        String phoneNum = splitText.join();
        if (!regExp.hasMatch(phoneNum)) {
          return '올바른 휴대폰 번호를 입력해주세요';
        }
        return null;
      }
    }

    String? _verificationCodeValidator(String? text) {
      const pattern = r'^[0-9]{6}$';
      final regExp = RegExp(pattern);
      if (text == null || text.isEmpty) {
        return '인증번호를 입력해주세요';
      } else {
        if (!regExp.hasMatch(text)) {
          return '인증번호는 6자리여야 합니다.';
        } else if (controller.phoneVerificationException != null &&
            (controller.phoneVerificationException ?? '') ==
                'CodeMismatchException') {
          return '인증번호가 일치하지 않습니다.';
        }
        return null;
      }
    }

    void _onPhoneNumChanged(String? text) {
      bool isValid = controller.formKey.currentState!.validate();
      controller.setPhoneNumValid(isValid);
      controller.setPhoneNumChanged(true);
    }

    void _onVerificationCodeChanged(String? text) {
      bool isValid = controller.formKey.currentState!.validate();
      controller.setVerificationCodeValid(isValid);
      controller.resetPhoneVerificationException();
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
              GetBuilder<RegisterController>(
                builder: (_) {
                  return Form(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
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
                        InputTextField(
                          label: _textFieldLabelText,
                          controller: _.phoneNumController,
                          validator: _phoneNumValidator,
                          keyboardType: TextInputType.number,
                          onChanged: _onPhoneNumChanged,
                          isPhone: true,
                        ),
                        _.verificationCodeSent
                            ? verticalSpacer(20)
                            : verticalSpacer(0),
                        _.verificationCodeSent
                            ? InputTextField(
                                label: _verificationCodeTextFieldLabelText,
                                keyboardType: TextInputType.number,
                                validator: _verificationCodeValidator,
                                controller: _.verificationCodeController,
                                onChanged: _onVerificationCodeChanged,
                                icon: _.phoneVerified
                                    ? null
                                    : GetX<RegisterController>(
                                        builder: (_) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              formatMSS(_
                                                  .verificationCodeTimeLimit
                                                  .value),
                                              style: const TextStyle(
                                                color: brightPrimaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                            : verticalSpacer(0),
                        verticalSpacer(10),
                        _.verificationCodeSent && !_.phoneVerified
                            ? TextActionButton(
                                buttonText: _resendVerificationCodeButtonText,
                                onPressed: _onResendCodePressed)
                            : verticalSpacer(0),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        GetBuilder<RegisterController>(
          builder: (_) {
            return Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.verificationCodeSent
                    ? (controller.phoneVerified
                        ? ElevatedActionButton(
                            buttonText: _nextButtonText,
                            onPressed: _onNextPressed,
                            activated: _.phoneVerified,
                          )
                        : _.checkingVerificationCode
                            ? const CircularProgressIndicator(
                                color: brightPrimaryColor)
                            : ElevatedActionButton(
                                buttonText: _checkVerificationCodeButtonText,
                                onPressed: _onCheckAuthNumPressed,
                                activated: _.isVerificationCodeValid,
                              ))
                    : ElevatedActionButton(
                        buttonText: _sendVerificationCodeButtonText,
                        onPressed: _onSendAuthNumPressed,
                        activated: _.isPhoneNumValid,
                      ),
              ],
            );
          },
        ),
        verticalSpacer(50),
      ],
    );
  }
}
