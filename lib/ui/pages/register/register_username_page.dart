import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterUsernamePage extends GetView<RegisterInfoController> {
  const RegisterUsernamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '닉네임을 입력해 주세요';
    const String _textFieldLabelText = '닉네임';
    const String _nextButtonText = '다음';
    final double _height = Get.height;

    void _onNextPressed() {
      controller.jumpToPage(1);
    }

    String? _usernameValidator(String? text) {
      const pattern =
          r'^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣._\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]]+(?<![_.])$';
      final regExp = RegExp(pattern);
      if (text == null || text.isEmpty) {
        return '닉네임을 입력해주세요';
      } else if (text.length < 3) {
        return '3글자 이상 입력해주세요';
      } else if (text.length > 20) {
        return '20자 이내로 입력해주세요';
      } else if (!regExp.hasMatch(text)) {
        return '닉네임 형식이 올바르지 않습니다';
      } else {
        if (!controller.isUsernameAvailable) {
          return '이미 존재하는 닉네임이에요';
        } else {
          return null;
        }
      }
    }

    void _onUsernameChanged(String text) async {
      if (controller.usernameController.text.length >= 3 &&
          controller.usernameController.text.length <= 20) {
        controller.setLoading(true);
        await controller.checkAvailableUsername();
        controller.setLoading(false);
      }
      if (controller.formKey.currentState != null) {
        bool isValid = controller.formKey.currentState!.validate();
        controller.setUsernameValid(isValid);
      }
    }

    return Column(
      children: [
        // Header(onPressed: _onBackPressed),
        verticalSpacer(56),
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
                    child: InputTextField(
                      label: _textFieldLabelText,
                      controller: controller.usernameController,
                      validator: _usernameValidator,
                      onChanged: _onUsernameChanged,
                    ),
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
              GetBuilder<RegisterInfoController>(builder: (_) {
                if (_.loading) {
                  return const CircularProgressIndicator(
                      color: brightPrimaryColor);
                } else {
                  return ElevatedActionButton(
                    buttonText: _nextButtonText,
                    onPressed: _onNextPressed,
                    activated: _.isUsernameValid && _.isUsernameAvailable,
                  );
                }
              }),
            ]),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
