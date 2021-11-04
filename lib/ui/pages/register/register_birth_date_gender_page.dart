import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:get/get.dart';

const String _titleText = '신체를 업그레이드할 준비가 되셨나요?';
const String _titleLabelText = '입력하신 정보를 토대로\n맞춤형 서비스를 제공해드려요';
const String _birthDateFieldLabelText = '생년월일';
const String _genderFieldLabelText = '성별';
const String _nextButtonText = '다음';

class RegisterBirthDateGenderPage extends StatelessWidget {
  const RegisterBirthDateGenderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;
    final controller = Get.put<RegisterOptionalInfoController>(
        RegisterOptionalInfoController());

    void _onBackPressed() {
      RegisterController.to.page.value = 4;
      Get.back();
    }

    void _onNextPressed() {
      controller.jumpToPage(1);
    }

    void _onBirthDateFieldPressed() {
      controller.toggleBirthDateField();
    }

    void _onBirthDateChanged(DateTime date) {
      controller.updateBirthDate(date);
    }

    void _onGenderFieldPressed() {
      controller.toggleGenderField();
    }

    void _onGenderChanged(Gender? gender) {
      controller.updateGender(gender);
    }

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
                  GetBuilder<RegisterOptionalInfoController>(
                    builder: (_) {
                      return InputFieldDisplay(
                        labelText: _birthDateFieldLabelText,
                        inputText: dateTimeToDisplayString(_.birthDate),
                        onPressed: _onBirthDateFieldPressed,
                        isOpen: _.isBirthDateFieldOpen,
                        inputWidget:
                            DatePicker(onBirthDateChanged: _onBirthDateChanged),
                      );
                    },
                  ),
                  verticalSpacer(30),
                  GetBuilder<RegisterOptionalInfoController>(
                    builder: (_) {
                      return InputFieldDisplay(
                        labelText: _genderFieldLabelText,
                        inputText: genderToString[_.gender] ?? '',
                        onPressed: _onGenderFieldPressed,
                        isOpen: _.isGenderFieldOpen,
                        inputWidget: GenderPicker(
                            onChanged: _onGenderChanged,
                            selectedValue: _.gender),
                      );
                    },
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
            ElevatedActionButton(
              buttonText: _nextButtonText,
              onPressed: _onNextPressed,
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}