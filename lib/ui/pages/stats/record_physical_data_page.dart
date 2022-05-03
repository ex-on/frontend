import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/physical_data_controller.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/ui/widgets/common/bubble_tooltips.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordPhysicalDataPage extends GetView<PhysicalDataController> {
  const RecordPhysicalDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _headerTitle = '신체 정보 기록';
    const String _infoButtonText = 'BMI와 인바디 점수가 뭐에요?';
    const String _heightFieldLabelText = '신장';
    const String _weightFieldLabelText = '몸무게';
    const String _muscleMassFieldLabelText = '골격근량';
    const String _bodyFatPercentageFieldLabelText = '체지방률';
    const String _recordButtonText = '기록하기';

    const String _bmiTitleText = 'BMI';
    const String _bmiInfoText = 'BMI는 체질량지수로,\n인간의 비만도를 나타내는 지수입니다.';
    const String _inbodyTitleText = '인바디 점수';
    const String _inbodyInfoText =
        '인바디 점수는 신체 발달 점수입니다.\n근육량이 높을수록 점수가 높게 나옵니다.';

    const List<Color> _bmiGradientColors = <Color>[
      Color(0xff0D92DD),
      Color(0xff3AD29F),
      Color(0xffFFC700),
      Color(0xffD63E6C),
    ];

    Future.delayed(Duration.zero, () {});

    void _onBackPressed() {
      // Get.until((route) => Get.currentRoute == '/home');
      Get.back();
    }

    void _onRecordPressed() async {
      await controller.postPhysicalData();
      Get.back();
      controller.reset();
    }

    Widget _bmiInfoDialog() {
      return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _bmiTitleText,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: clearBlackColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    splashRadius: 20,
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close),
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 20),
              child: Text(
                _bmiInfoText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: deepGrayColor,
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SizedBox.shrink(),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '18.5',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: deepGrayColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '23',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: deepGrayColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '25',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: deepGrayColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox.shrink(),
                ],
              ),
            ),
            Container(
              width: 220,
              height: 12.5,
              margin: const EdgeInsets.only(top: 3, bottom: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: _bmiGradientColors),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 30,
                      child: Text(
                        '저체중',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '정상',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '과체중',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 30,
                      child: Text(
                        '비만',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              _inbodyTitleText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: clearBlackColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 20),
              child: Text(
                _inbodyInfoText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: deepGrayColor,
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '강인형',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: brightPrimaryColor,
                    ),
                  ),
                  Text(
                    '90 이상',
                    style: TextStyle(
                      fontSize: 12,
                      color: deepGrayColor,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpacer(8),
            SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '건강형',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: brightPrimaryColor,
                    ),
                  ),
                  Text(
                    '70 ~ 90',
                    style: TextStyle(
                      fontSize: 12,
                      color: deepGrayColor,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpacer(8),
            SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '허약형',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: brightPrimaryColor,
                    ),
                  ),
                  Text(
                    '70 이하',
                    style: TextStyle(
                      fontSize: 12,
                      color: deepGrayColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    void _onInfoTextButtonPressed() {
      Get.dialog(_bmiInfoDialog());
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Header(
          onPressed: _onBackPressed,
          title: _headerTitle,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: context.width,
                      child: GetBuilder<PhysicalDataController>(
                        builder: (_) {
                          return Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 5),
                                child: Text(
                                  '입력하신 정보를 토대로 체지방량,\nBMI와 인바디 점수를 계산해드려요',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17.34,
                                    height: 1.26,
                                    color: clearBlackColor,
                                  ),
                                ),
                              ),
                              TextActionButton(
                                buttonText: _infoButtonText,
                                onPressed: _onInfoTextButtonPressed,
                                textColor: deepGrayColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              verticalSpacer(50),
                              SizedBox(
                                width: 330,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: textFieldFillColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 15,
                                            left: 15,
                                            right: 10,
                                            bottom: 15),
                                        child: Text(
                                          _heightFieldLabelText,
                                          style: TextStyle(
                                            height: 1,
                                            color: lightGrayColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      StatsController.to.cumulativeTimeStatData[
                                                      'physical_stat'][1]
                                                  ['height'] ==
                                              null
                                          ? const SizedBox(
                                              height: 0,
                                              width: 0,
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: Text(
                                                ': ' +
                                                    StatsController
                                                        .to
                                                        .cumulativeTimeStatData[
                                                            'physical_stat'][1]
                                                            ['height']
                                                        .toString() +
                                                    'cm',
                                                style: const TextStyle(
                                                  height: 1,
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                      const Expanded(child: SizedBox()),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: TooltipHelpIconButton(
                                            message: '설정에서 신장을 변경할 수 있어요',
                                            overlayColor: brightPrimaryColor
                                                .withOpacity(0.1),
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              verticalSpacer(30),
                              PrefixLabelTextField(
                                label: _weightFieldLabelText,
                                controller: _.weightTextController,
                                focusNode: _.weightFocusNode,
                                unit: 'kg',
                              ),
                              verticalSpacer(30),
                              PrefixLabelTextField(
                                label: _muscleMassFieldLabelText,
                                controller: _.muscleMassTextController,
                                focusNode: _.muscleMassFocusNode,
                                unit: 'kg',
                              ),
                              verticalSpacer(30),
                              PrefixLabelTextField(
                                label: _bodyFatPercentageFieldLabelText,
                                controller: _.bodyFatPercentageTextController,
                                focusNode: _.bodyFatPercentageFocusNode,
                                unit: '%',
                              ),
                              verticalSpacer(30),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: GetBuilder<PhysicalDataController>(builder: (_) {
                    bool _isActivated =
                        _.weightTextController.text.isNotEmpty ||
                            _.muscleMassTextController.text.isNotEmpty ||
                            _.bodyFatPercentageTextController.text.isNotEmpty;
                    return ElevatedActionButton(
                      width: 220,
                      height: 60,
                      buttonText: _recordButtonText,
                      onPressed: _onRecordPressed,
                      activated: _isActivated,
                    );
                  }),
                ),
              ],
            ),
            GetBuilder<PhysicalDataController>(builder: (_) {
              if (_.loading) {
                return const LoadingIndicator();
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
