import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterEmailPage extends StatelessWidget {
  const RegisterEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '반갑습니다!';
    const String _titleLabelText = '회원가입을 위한 이메일을 입력해주세요';
    const String _textFieldLabelText = '이메일';
    const String _nextButtonText = '다음';
    final double _height = Get.height;
    final controller = Get.put<RegisterController>(RegisterController());

    void _onBackPressed() {
      Get.back();
    }

    void _onNextPressed() async {
      FocusScope.of(context).unfocus();
      await controller.checkAvailableEmail();
      controller.formKey.currentState!.validate();
      if (controller.isEmailAvailable) {
        controller.toNextPage();
      }
    }

    String? _emailValidator(String? text) {
      const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
      final regExp = RegExp(pattern);
      if (text == null || text.isEmpty) {
        return '이메일을 입력해주세요';
      }
      if (!regExp.hasMatch(text)) {
        return '올바른 이메일 주소를 입력해주세요';
      } else if (!controller.isEmailAvailable) {
        return '이미 존재하는 이메일입니다';
      } else {
        return null;
      }
    }

    void _onInputChanged(String text) {
      controller.setEmailAvailable();
      bool isValid = controller.formKey.currentState!.validate();
      controller.setEmailValid(isValid);
    }

    return Stack(children: [
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
              GetBuilder<RegisterController>(builder: (_) {
                return ElevatedActionButton(
                  buttonText: _nextButtonText,
                  onPressed: _onNextPressed,
                  activated: _.isEmailValid && _.isEmailAvailable,
                );
              }),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
      GetBuilder<RegisterController>(builder: (_) {
        if (_.loading) {
          return const LoadingIndicator();
        } else {
          return horizontalSpacer(0);
        }
      }),
    ]);
  }
}
