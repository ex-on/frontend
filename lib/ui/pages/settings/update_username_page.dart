import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/settings_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUsernamePage extends GetView<SettingsController> {
  const UpdateUsernamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;
    const String _titleText = '새 닉네임을 입력해 주세요';
    const String _textFieldLabelText = '닉네임';
    const String _nextButtonText = '완료';

    void _onBackPressed() {
      Get.back();
      controller.resetUsername();
    }

    void _onCompletePressed() async {
      Get.toNamed('/loading');
      var success = await controller.updateUsername();
      if (success) {
        Get.until((route) => Get.currentRoute == '/settings');
        AuthController.to.getUserInfo();
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text(
              '닉네임이 성공적으로 수정되었어요',
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
        Get.back();
        Get.showSnackbar(
          GetSnackBar(
            messageText: const Text(
              '닉네임 수정에 실패했어요. 다시 시도해 주세요',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            borderRadius: 10,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
            duration: const Duration(seconds: 2),
            isDismissible: false,
            backgroundColor: darkSecondaryColor.withOpacity(0.8),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: InputTextField(
                              label: _textFieldLabelText,
                              controller: _.usernameController,
                              validator: _.usernameValidator,
                              onChanged: _.onUsernameChanged,
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
                        onPressed: _onCompletePressed,
                        activated: _.isUsernameValid && _.isUsernameAvailable,
                      );
                    }
                  },
                ),
              ],
            ),
            verticalSpacer(50),
          ],
        ),
      ),
    );
  }
}
