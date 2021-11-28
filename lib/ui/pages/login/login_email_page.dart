import 'package:exon_app/core/controllers/login_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginEmailPage extends StatelessWidget {
  const LoginEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '반갑습니다!';
    const String _titleLabelText = '로그인을 위한 이메일을 입력해주세요';
    const String _textFieldLabelText = '이메일';
    const String _nextButtonText = '다음';
    final double _height = Get.height;
    final controller = Get.put<LoginController>(LoginController());

    void _onBackPressed() {
      Get.back();
      controller.reset();
    }

    void _onNextPressed() {
      controller.jumpToPage(1);
    }

    String? _emailValidator(String? text) {
      const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
      final regExp = RegExp(pattern);
      if (text == null || text.isEmpty) {
        return '이메일을 입력해주세요';
      }
      if (!regExp.hasMatch(text)) {
        return '올바른 이메일 주소를 입력해주세요';
      } else if (false) {
        return '존재하지 않는 이메일입니다';
      } else {
        return null;
      }
    }

    void _onInputChanged(String text) {
      bool isValid = controller.formKey.currentState!.validate();
      controller.setEmailValid(isValid);
      if (controller.isEmailValid) {
        print('checking');
        // controller.checkAvailableEmail();
      }
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
                  Form(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: InputTextField(
                      label: _textFieldLabelText,
                      controller: controller.emailController,
                      validator: _emailValidator,
                      onChanged: _onInputChanged,
                      keyboardType: TextInputType.emailAddress,
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
            GetBuilder<LoginController>(builder: (_) {
              return ElevatedActionButton(
                buttonText: _nextButtonText,
                onPressed: _onNextPressed,
                activated: _.isEmailValid,
              );
            }),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
