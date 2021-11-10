import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/dummy_data.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/exercise/set_input_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseBlockView extends GetView<ExerciseBlockController> {
  const ExerciseBlockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _totalExerciseTimeLabelText = '총 운동시간';
    const String _totalRestTimeLabelText = '총 휴식시간';
    const String _exerciseOngoingLabelText = '진행중';
    const String _exercisePausedLabelText = '휴식중';
    const String _recommendedRestTimeLabelText = '권장 휴식';
    const String _nextExerciseSetLabelText = '다음 운동';

    void _onBackPressed() {
      Get.back();
      controller.reset();
    }

    void _onCompleteSetPressed() {
      if (controller.exercisePaused) {
        controller.startNextSet();
      } else if (controller.currentSet == controller.numSets) {
        controller.endExercise();
        Get.back();
      } else {
        controller.completeExerciseSet();
      }
    }

    void _onBottomSheetClosePressed() {
      Get.back();
    }

    void _onBottomSheetCompletePressed() {
      controller.updateInputSetValues();
      Get.back();
    }

    void _onInputSetWeightChanged(int index) {
      controller.updateCurrentInputSetWeight(index + 1);
    }

    void _onInputSetRepsChanged(int index) {
      controller.updateCurrentInputSetReps(index + 1);
    }

    Widget _bottomSheet(int setNum) {
      return SetInputBottomSheet(
        setNum: setNum,
        onClosePressed: _onBottomSheetClosePressed,
        onCompletePressed: _onBottomSheetCompletePressed,
        onWeightChanged: _onInputSetWeightChanged,
        onRepsChanged: _onInputSetRepsChanged,
        weightController: controller.getWeightController(setNum),
        repsController: controller.getRepsController(setNum),
      );
    }

    void _onNumRepsTap(int setNum) {
      Get.bottomSheet(_bottomSheet(setNum));
    }

    Widget _exerciseTimeBox = Container(
      color: mainBackgroundColor,
      height: context.height * 0.3 - 56,
      width: context.width,
      child: Column(
        children: [
          const Text(
            _totalExerciseTimeLabelText,
            style: TextStyle(
              fontSize: 18,
              color: darkPrimaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 14),
            child: GetX<ExerciseBlockController>(
              builder: (_) {
                return Text(
                  formatHHMMSS(_.totalExerciseTime.value),
                  style: const TextStyle(
                    color: darkPrimaryColor,
                    fontSize: 48,
                    letterSpacing: -2,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    controller.exerciseName ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: deepGrayColor,
                    ),
                  ),
                  GetX<ExerciseBlockController>(
                    builder: (_) {
                      return Text(
                        formatHHMMSS(_.currentExerciseTime.value),
                        style: const TextStyle(
                          color: deepGrayColor,
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                ],
              ),
              horizontalSpacer(100),
              Column(
                children: [
                  const Text(
                    _totalRestTimeLabelText,
                    style: TextStyle(
                      fontSize: 14,
                      color: deepGrayColor,
                    ),
                  ),
                  GetX<ExerciseBlockController>(
                    builder: (_) {
                      return Text(
                        formatHHMMSS(_.totalRestTime.value),
                        style: const TextStyle(
                          color: deepGrayColor,
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    Widget _exerciseControlButton = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: darkPrimaryColor),
      ),
      child: Center(
        child: Material(
          type: MaterialType.circle,
          color: Colors.transparent,
          child: IconButton(
            color: Colors.white,
            iconSize: 100,
            splashRadius: 50,
            padding: EdgeInsets.zero,
            icon: GetBuilder<ExerciseBlockController>(
              builder: (_) {
                if (_.currentSet == _.numSets && !_.exercisePaused) {
                  return const Icon(
                    Icons.check_rounded,
                    color: darkPrimaryColor,
                    size: 55,
                  );
                } else {
                  return Icon(
                    _.exercisePaused
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: darkPrimaryColor,
                    size: 55,
                  );
                }
              },
            ),
            onPressed: _onCompleteSetPressed,
          ),
        ),
      ),
    );

    Widget _exerciseStateDisplay = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          GetBuilder<ExerciseBlockController>(
            builder: (_) {
              return Text(
                _.exercisePaused
                    ? _exercisePausedLabelText
                    : _exerciseOngoingLabelText,
                style: const TextStyle(
                  fontSize: 18,
                  color: deepGrayColor,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 20),
            child: GetBuilder<ExerciseBlockController>(
              builder: (_) {
                if (_.exercisePaused) {
                  return Obx(
                    () => Text(
                      formatHHMMSS(_.totalRestTime.value),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: darkPrimaryColor,
                      ),
                    ),
                  );
                } else {
                  return Text(
                    _.currentSet.toString() + '세트',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: darkPrimaryColor,
                    ),
                  );
                }
              },
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xffd6d6d6),
                ),
                bottom: BorderSide(
                  color: Color(0xffd6d6d6),
                ),
              ),
            ),
            child: SizedBox(
              width: context.width,
              height: 180,
              child: GetBuilder<ExerciseBlockController>(
                builder: (_) {
                  if (_.exercisePaused) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const ColorBadge(
                                  text: _recommendedRestTimeLabelText,
                                  color: Color(0xff7b8196),
                                  height: 37,
                                  width: 88,
                                  fontSize: 17,
                                ),
                                verticalSpacer(8),
                                Text(
                                  formatHHMMSS(_.recommendedRestTime!),
                                  style: const TextStyle(
                                    color: clearBlackColor,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                            horizontalSpacer(60),
                            Column(
                              children: [
                                const ColorBadge(
                                  text: _nextExerciseSetLabelText,
                                  color: Color(0xff7b8196),
                                  height: 37,
                                  width: 88,
                                  fontSize: 17,
                                ),
                                verticalSpacer(8),
                                Text(
                                  _.exerciseName! +
                                      '\n' +
                                      _.currentSet.toString() +
                                      '세트',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: clearBlackColor,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '목표',
                              style: TextStyle(
                                color: deepGrayColor,
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: SizedBox(
                                width: 70,
                                height: 45,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.exercisePlan!['sets']
                                              [controller.currentSet - 1]
                                              ['target_weight']!
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                'kg',
                                style: TextStyle(
                                  color: deepGrayColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.close_rounded,
                              color: deepGrayColor,
                              size: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: SizedBox(
                                width: 70,
                                height: 45,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.exercisePlan!['sets']
                                              [controller.currentSet - 1]
                                              ['target_reps']!
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              '회',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '기록',
                              style: TextStyle(
                                color: deepGrayColor,
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: SizedBox(
                                width: 70,
                                height: 45,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                  child: GetBuilder<ExerciseBlockController>(
                                    builder: (_) {
                                      return NumberInputFieldDisplay(
                                        hintText: '0',
                                        inputText: _.inputSetValues == null
                                            ? ''
                                            : _.inputSetValues![0].toString(),
                                        onTap: () =>
                                            _onNumRepsTap(_.currentSet),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                'kg',
                                style: TextStyle(
                                  color: deepGrayColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.close_rounded,
                              color: deepGrayColor,
                              size: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: SizedBox(
                                width: 70,
                                height: 45,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                  child: GetBuilder<ExerciseBlockController>(
                                    builder: (_) {
                                      return NumberInputFieldDisplay(
                                        hintText: '0',
                                        inputText: _.inputSetValues == null
                                            ? ''
                                            : _.inputSetValues![1].toString(),
                                        onTap: () =>
                                            _onNumRepsTap(_.currentSet),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              '회',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Header(
            onPressed: _onBackPressed,
            color: mainBackgroundColor,
          ),
          Expanded(
            child: DisableGlowListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: context.height,
                  width: context.width,
                  child: Stack(
                    children: [
                      Positioned(top: 0, child: _exerciseTimeBox),
                      Positioned(
                        top: context.height * 0.3 - 106,
                        left: context.width * 0.5 - 50,
                        child: _exerciseControlButton,
                      ),
                      Positioned(
                        top: context.height * 0.3 - 6,
                        child: _exerciseStateDisplay,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
