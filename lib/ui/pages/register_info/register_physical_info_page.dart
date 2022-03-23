import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:get/get.dart';
// import 'package:wrapped_korean_text/wrapped_korean_text.dart';

const String _titleText = '신체를 업그레이드할 준비가\n되셨나요?';
const String _titleLabelText =
    '신체 정보를 입력하면 더욱 편리한 서비스 이용이 가능해요😊 아는 만큼 입력해주세요!!';
const String _heightFieldLabelText = '신장*';
const String _weightFieldLabelText = '무게*';
const String _bodyFatPercentageFieldLabelText = '체지방률';
const String _muscleMassFieldLabelText = '근육량';
const String _startButtonText = '시작하기';

class RegisterPhysicalInfoPage extends GetView<RegisterInfoController> {
  const RegisterPhysicalInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;

    void _onBackPressed() {
      controller.jumpToPage(0);
    }

    void _onStartPressed() async {
     await controller.postUserInfo();
     await controller.postUserPhysicalInfo();
      Get.offAllNamed('/home');
      controller.reset();
    }

    void _onHeightChanged(String height) {
      controller.update();
    }

    void _onWeightChanged(String height) {
      controller.update();
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
              GetBuilder<RegisterInfoController>(builder: (_) {
                return Column(
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
                    verticalSpacer(30),
                    PrefixLabelTextField(
                      label: _heightFieldLabelText,
                      controller: _.heightController,
                      onChanged: _onHeightChanged,
                      focusNode: _.heightFocusNode,
                      unit: 'cm',
                    ),
                    verticalSpacer(30),
                    PrefixLabelTextField(
                      label: _weightFieldLabelText,
                      controller: _.weightController,
                      onChanged: _onWeightChanged,
                      focusNode: _.weightFocusNode,
                      unit: 'kg',
                    ),
                    verticalSpacer(30),
                    PrefixLabelTextField(
                      label: _muscleMassFieldLabelText,
                      controller: _.muscleMassController,
                      focusNode: _.muscleMassFocusNode,
                      unit: 'kg',
                    ),
                    verticalSpacer(30),
                    PrefixLabelTextField(
                      label: _bodyFatPercentageFieldLabelText,
                      controller: _.bodyFatPercentageController,
                      focusNode: _.bodyFatPercentageFocusNode,
                      unit: '%',
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        GetBuilder<RegisterInfoController>(
          builder: (_) {
            return ElevatedActionButton(
              buttonText: _startButtonText,
              onPressed: _onStartPressed,
              activated: (_.heightController.text != ''
                      ? (double.parse(_.heightController.text) > 0.0)
                      : false) &&
                  (_.weightController.text != ''
                      ? (double.parse(_.weightController.text) > 0.0)
                      : false),
            );
          },
        ),
        verticalSpacer(50),
        // TextActionButton(
        //     buttonText: _nextTimeButtonText, onPressed: _onNextTimePressed),
        // verticalSpacer(50),
      ],
    );
  }
}
