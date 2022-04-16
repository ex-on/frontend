import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/core/controllers/tooltip_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/bubble_tooltips.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/helpers/utils.dart';

class CardioRecordPage extends GetView<ExerciseBlockController> {
  const CardioRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _endRecordButtonText = '기록 완료';

    void _onSubtractDistancePressed() {
      controller.subtractRecordDistance();
      TooltipController.to.deactivateTooltip();
    }

    void _onAddDistancePressed() {
      controller.addRecordDistance();
      TooltipController.to.deactivateTooltip();
    }

    void _updateDistanceChangeValue(int index) {
      controller
          .updateInputDistanceChangeValue(inputDistanceChangeValueList[index]);
      TooltipController.to.deactivateTooltip();
    }

    void _onDistanceInputChanged(String val) {
      controller.onDistanceInputChanged(val);
      TooltipController.to.deactivateTooltip();
    }

    void _onRecordButtonPressed() {
      controller.endExerciseCardioRecord();
    }

    void _onBackPressed() {
      Get.back();
      controller.endCardioRest();
    }

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Header(
          onPressed: _onBackPressed,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: clearBlackColor,
            size: 30,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () => Future(() => false),
        child: GetBuilder<ExerciseBlockController>(
          builder: (_) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    _.exerciseData['name'] + ' 운동시간',
                    style: const TextStyle(
                      fontSize: 17,
                      color: darkPrimaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 75),
                  child: Text(
                    _.currentExerciseTime.value >= 3600
                        ? formatHHMMSS(_.currentExerciseTime.value)
                        : formatMMSS(_.currentExerciseTime.value),
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: darkPrimaryColor,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ReverseBubbleTooltip(
                          message: '실제 달성한 거리 기록을 적어주세요',
                          backgroundColor: Colors.white,
                          textColor: brightPrimaryColor,
                          margin: const EdgeInsets.only(bottom: 20),
                          arrowHeight: 10,
                          child: Container(
                            width: 285,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            alignment: Alignment.center,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Padding(
                                padding: const EdgeInsets.all(13),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: _onSubtractDistancePressed,
                                      highlightColor:
                                          brightPrimaryColor.withOpacity(0.2),
                                      splashColor:
                                          brightPrimaryColor.withOpacity(0.2),
                                      icon: const SubtractIcon(
                                        color: brightPrimaryColor,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          NumberInputField(
                                            controller:
                                                _.recordDistanceTextController,
                                            onChanged: _onDistanceInputChanged,
                                            hintText: _.exercisePlanCardio[
                                                        'target_distance'] ==
                                                    0
                                                ? '--'
                                                : '0.0',
                                            fontSize: 30,
                                          ),
                                          const Text(
                                            'km',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: brightPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Mandrope',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      highlightColor:
                                          brightPrimaryColor.withOpacity(0.2),
                                      splashColor:
                                          brightPrimaryColor.withOpacity(0.2),
                                      onPressed: _onAddDistancePressed,
                                      icon: const AddIcon(
                                        color: brightPrimaryColor,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              4 + 3,
                              (index) => index % 2 == 1
                                  ? horizontalSpacer(10)
                                  : ElevatedActionButton(
                                      height: 38,
                                      width: 62,
                                      buttonText: getCleanTextFromDouble(
                                          inputDistanceChangeValueList[
                                              index ~/ 2]),
                                      onPressed: () =>
                                          _updateDistanceChangeValue(
                                              index ~/ 2),
                                      backgroundColor:
                                          _.inputDistanceChangeValue ==
                                                  inputDistanceChangeValueList[
                                                      index ~/ 2]
                                              ? brightPrimaryColor
                                              : const Color(0xffE1F4F8),
                                      textStyle: TextStyle(
                                        color: _.inputDistanceChangeValue ==
                                                inputDistanceChangeValueList[
                                                    index ~/ 2]
                                            ? Colors.white
                                            : brightPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: ElevatedActionButton(
                    buttonText: _endRecordButtonText,
                    width: 280,
                    height: 75,
                    borderRadius: 100,
                    textStyle: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: mainBackgroundColor,
                    ),
                    onPressed: _onRecordButtonPressed,
                    disabledColor: lightGrayColor,
                    activated: _.recordDistanceTextController.text.isNotEmpty
                        ? double.parse(_.recordDistanceTextController.text) > 0
                        : false,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
