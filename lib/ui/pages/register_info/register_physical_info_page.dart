import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/horizontal_number_picker.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:get/get.dart';

const String _titleText = '신체를 업그레이드할 준비가 되셨나요?';
const String _titleLabelText =
    '신체 정보를 입력하면 더욱 편리한 서비스 이용이 가능해요😊 아는 만큼 입력해주세요!!';
const String _heightFieldLabelText = '*신장';
const String _weightFieldLabelText = '무게';
const String _bodyFatPercentageFieldLabelText = '체지방률';
const String _muscleMassFieldLabelText = '근육량';
const String _startButtonText = '시작하기';
const String _nextTimeButtonText = '다음에 입력할게요';

class RegisterPhysicalInfoPage extends StatelessWidget {
  const RegisterPhysicalInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;
    final controller =
        Get.put<RegisterInfoController>(RegisterInfoController());

    void _onBackPressed() {
      controller.jumpToPage(0);
    }

    void _onStartPressed() {
      controller.postUserInfo();
      controller.postUserPhysicalInfo();
      AuthController.to.getUserInfo();
      Get.offAllNamed('/home');
      controller.reset();
    }

    void _onNextTimePressed() {
      controller.postUserInfo();
      controller.postUserPhysicalInfo();
      Get.offAllNamed('/home');
      controller.reset();
    }

    void _onHeightFieldPressed() {
      controller.toggleHeightField();
    }

    void _onWeightFieldPressed() {
      controller.toggleWeightField();
    }

    void _onBodyFatPercentageFieldPressed() {
      controller.toggleBodyFatPercentageField();
    }

    void _onMuscleMassFieldPressed() {
      controller.toggleMuscleMassField();
    }

    void _onHeightChanged(double height) {
      controller.updateHeight(height);
    }

    void _onWeightChanged(double weight) {
      controller.updateWeight(weight);
    }

    void _onBodyFatPercentageChanged(double bodyFatPercentage) {
      controller.updateBodyFatPercentage(bodyFatPercentage);
    }

    void _onMuscleMassChanged(double muscleMass) {
      controller.updateMuscleMass(muscleMass);
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
                  GetBuilder<RegisterInfoController>(
                    builder: (_) {
                      return InputFieldDisplay(
                        labelText: _heightFieldLabelText,
                        inputText:
                            _.height == null ? '' : _.height.toString() + 'cm',
                        onPressed: _onHeightFieldPressed,
                        isToggled: _.isHeightFieldOpen,
                        inputWidgetHeight: 100,
                        inputWidget: HorizontalPicker(
                          minValue: 130,
                          maxValue: 210,
                          divisions: 800,
                          onChanged: _onHeightChanged,
                        ),
                      );
                    },
                  ),
                  verticalSpacer(30),
                  GetBuilder<RegisterInfoController>(
                    builder: (_) {
                      return InputFieldDisplay(
                        labelText: _weightFieldLabelText,
                        inputText:
                            _.weight == null ? '' : _.weight.toString() + 'kg',
                        onPressed: _onWeightFieldPressed,
                        isToggled: _.isWeightFieldOpen,
                        inputWidgetHeight: 100,
                        inputWidget: HorizontalPicker(
                          minValue: 30,
                          maxValue: 150,
                          divisions: 1200,
                          unit: 'kg',
                          onChanged: _onWeightChanged,
                        ),
                      );
                    },
                  ),
                  verticalSpacer(30),
                  GetBuilder<RegisterInfoController>(
                    builder: (_) {
                      return InputFieldDisplay(
                        labelText: _bodyFatPercentageFieldLabelText,
                        inputText: _.bodyFatPercentage == null
                            ? ''
                            : _.bodyFatPercentage.toString() + '%',
                        onPressed: _onBodyFatPercentageFieldPressed,
                        isToggled: _.isBodyFatPercentageFieldOpen,
                        inputWidgetHeight: 100,
                        inputWidget: HorizontalPicker(
                          minValue: 0,
                          maxValue: 50,
                          divisions: 500,
                          unit: '%',
                          onChanged: _onBodyFatPercentageChanged,
                        ),
                      );
                    },
                  ),
                  verticalSpacer(30),
                  GetBuilder<RegisterInfoController>(
                    builder: (_) {
                      return InputFieldDisplay(
                        labelText: _muscleMassFieldLabelText,
                        inputText: _.muscleMass == null
                            ? ''
                            : _.muscleMass.toString() + 'kg',
                        onPressed: _onMuscleMassFieldPressed,
                        isToggled: _.isMuscleMassFieldOpen,
                        inputWidgetHeight: 100,
                        inputWidget: HorizontalPicker(
                          minValue: 10,
                          maxValue: 60,
                          divisions: 500,
                          unit: 'kg',
                          onChanged: _onMuscleMassChanged,
                        ),
                      );
                    },
                  ),
                  verticalSpacer(30),
                ],
              ),
            ],
          ),
        ),
        GetBuilder<RegisterInfoController>(
          builder: (_) {
            return ElevatedActionButton(
              buttonText: _startButtonText,
              onPressed: _onStartPressed,
              activated: _.height != null &&
                  _.weight != null ||
                  _.bodyFatPercentage != null ||
                  _.muscleMass != null,
            );
          },
        ),
        verticalSpacer(5),
        TextActionButton(
            buttonText: _nextTimeButtonText, onPressed: _onNextTimePressed),
        verticalSpacer(50),
      ],
    );
  }
}
