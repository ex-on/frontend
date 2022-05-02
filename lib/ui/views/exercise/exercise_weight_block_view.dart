import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/core/controllers/tooltip_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/enums.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:exon_app/helpers/utils.dart';

class ExerciseWeightBlockView extends GetView<ExerciseBlockController> {
  const ExerciseWeightBlockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () => controller.restTime.listen((time) {
        controller.checkEndRest();
      }),
    );

    void _quitExercise() {
      Get.back(closeOverlays: true);
      controller.reset();
    }

    void _onCompleteSetRecordPressed() {
      if (controller.currentSet == controller.numSets) {
        controller.endExerciseWeight();
      } else {
        controller.completeExerciseSetRecord();
      }
    }

    void _updateWeightChangeValue(int index) {
      controller
          .updateInputWeightChangeValue(inputWeightChangeValueList[index]);
    }

    void _onWeightRecordInputChanged(String value) {
      controller.onWeightRecordInputChanged(value);
    }

    void _onSubtractWeightRecordPressed() {
      controller.subtractInputWeightRecord();
    }

    void _onAddWeightRecordPressed() {
      controller.addInputWeightRecord();
    }

    void _onInputSetRecordDonePressed() {
      controller.updateInputSetRecordDone(true);
    }

    void _onCompleteSetPressed() {
      controller.completeSet();
    }

    void _endExercise() {
      Get.back(closeOverlays: true);
      if (!controller.exercisePaused) {
        controller.completeSet();
      }
      controller.endExerciseWeight();
    }

    void _onSlidableButtonPositionChanged(SlidableButtonPosition position) {
      if (position == SlidableButtonPosition.left) {
        controller.startExerciseSetRecord();
      } else if (position == SlidableButtonPosition.right) {
        _onCompleteSetRecordPressed();
      }
    }

    void _onSubtractTotalRestPressed() {
      controller.subtractRestTime();
    }

    void _onAddTotalRestPressed() {
      controller.addRestTime();
    }

    void _onEndRestPressed() {
      controller.endRest();
      controller.startNextSet();
    }

    print(controller.exerciseData);

    Widget _inputSetRecordDialog = Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: GetBuilder<ExerciseBlockController>(
          builder: (_) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: context.width - 40,
                  constraints: const BoxConstraints(minHeight: 300),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                              color: brightPrimaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.currentSet.toString() +
                                      '세트 기록 수정하기',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const Expanded(
                                  child: SizedBox.shrink(),
                                ),
                                TextActionButton(
                                  height: 45,
                                  isUnderlined: false,
                                  textColor: Colors.white,
                                  fontSize: 16,
                                  buttonText: '닫기',
                                  onPressed: () => Get.back(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      verticalSpacer(30),
                      _.exerciseData['exercise_method'] == 1
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                4 + 3,
                                (index) => index % 2 == 1
                                    ? horizontalSpacer(10)
                                    : ElevatedActionButton(
                                        height: 38,
                                        width: 62,
                                        buttonText: getCleanTextFromDouble(
                                            inputWeightChangeValueList[
                                                index ~/ 2]),
                                        onPressed: () =>
                                            _updateWeightChangeValue(
                                                index ~/ 2),
                                        backgroundColor:
                                            _.inputWeightChangeValue ==
                                                    inputWeightChangeValueList[
                                                        index ~/ 2]
                                                ? brightPrimaryColor
                                                : const Color(0xffE1F4F8),
                                        textStyle: TextStyle(
                                          color: _.inputWeightChangeValue ==
                                                  inputWeightChangeValueList[
                                                      index ~/ 2]
                                              ? Colors.white
                                              : brightPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                              ),
                            ),
                      _.exerciseData['exercise_method'] == 1
                          ? const SizedBox.shrink()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 30),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const SubtractIcon(),
                                      splashRadius: 20,
                                      onPressed: _onSubtractWeightRecordPressed,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          NumberInputField(
                                            controller: _.inputSetValues![0],
                                            onChanged:
                                                _onWeightRecordInputChanged,
                                            hintText: '0.0',
                                          ),
                                          const Text(
                                            'kg',
                                            style: TextStyle(
                                              fontSize: 26,
                                              color: brightPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Mandrope',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const AddIcon(),
                                      splashRadius: 20,
                                      onPressed: _onAddWeightRecordPressed,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      _.exerciseData['exercise_method'] == 1
                          ? const SizedBox.shrink()
                          : const Divider(
                              color: Color(0xffE1F4F8),
                              thickness: 4,
                              height: 4,
                            ),
                      () {
                        List<Widget> children = _.inputTargetRepsList.map((e) {
                          if (e == int.parse(_.inputSetValues![1].text)) {
                            return Center(
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Text.rich(
                                  TextSpan(
                                    text: e.toString(),
                                    style: const TextStyle(
                                      color: brightPrimaryColor,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Manrope',
                                      height: 1.0,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: '회',
                                        style: TextStyle(
                                          color: brightPrimaryColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Manrope',
                                          height: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return RotatedBox(
                              quarterTurns: 1,
                              child: Center(
                                child: Text(
                                  e.toString(),
                                  style: const TextStyle(
                                    color: brightPrimaryColor,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Manrope',
                                  ),
                                ),
                              ),
                            );
                          }
                        }).toList();

                        _.recordRepsScrollController =
                            FixedExtentScrollController(
                                initialItem:
                                    int.parse(_.inputSetValues![1].text) - 1);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: SizedBox(
                            height: 50,
                            width: context.width,
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: CupertinoPicker(
                                scrollController: _.recordRepsScrollController,
                                itemExtent: 90,
                                selectionOverlay: const DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: brightPrimaryColor,
                                        width: 0.5,
                                      ),
                                      bottom: BorderSide(
                                        color: brightPrimaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                onSelectedItemChanged: _.updateInputReps,
                                children: children,
                              ),
                            ),
                          ),
                        );
                      }()
                    ],
                  ),
                ),
                ElevatedActionButton(
                  width: 280,
                  height: 70,
                  backgroundColor: Colors.white,
                  overlayColor: brightPrimaryColor.withOpacity(0.1),
                  textStyle: const TextStyle(
                    color: brightPrimaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Manrope',
                  ),
                  borderRadius: 100,
                  buttonText: (_.exerciseData['exercise_method'] == 1
                          ? ''
                          : (_.inputSetValues![0].text + 'kg X ')) +
                      _.inputSetValues![1].text +
                      '회',
                  onPressed: () {},
                  disabledColor: Colors.white,
                  activated: false,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 55),
                  child: TextActionButton(
                    buttonText: '완료',
                    onPressed: () {
                      _onInputSetRecordDonePressed();
                      Get.back();
                    },
                    textColor: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );

    Widget _endExerciseDialog = Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: context.width - 40,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '운동이 현재 세트까지만 기록됩니다.\n정말 종료하시겠어요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: clearBlackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: ExcitedCharacter(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedActionButton(
                    width: 170,
                    height: 65,
                    buttonText: '돌아가기',
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(
                      color: clearBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overlayColor: clearBlackColor.withOpacity(0.2),
                    borderRadius: 20,
                    onPressed: () => Get.back(),
                  ),
                  ElevatedActionButton(
                    width: 170,
                    height: 65,
                    buttonText: '종료',
                    backgroundColor: clearBlackColor,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: 20,
                    onPressed: _endExercise,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Widget _quitExerciseDialog = Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: context.width - 40,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '운동이 기록되지 않고 취소됩니다.\n정말 중단하시겠어요?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: clearBlackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: TiredCharacter(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedActionButton(
                      width: 170,
                      height: 65,
                      buttonText: '돌아가기',
                      backgroundColor: Colors.white,
                      textStyle: const TextStyle(
                        color: clearBlackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: 20,
                      overlayColor: clearBlackColor.withOpacity(0.2),
                      onPressed: () => Get.back(),
                    ),
                    ElevatedActionButton(
                      width: 170,
                      height: 65,
                      buttonText: '중단',
                      backgroundColor: cancelRedColor,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: 20,
                      onPressed: _quitExercise,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));

    _onInputExerciseRecordPressed() {
      Get.dialog(
        _inputSetRecordDialog,
        useSafeArea: false,
      );
    }

    void _onEndExercisePressed() {
      Get.dialog(
        _endExerciseDialog,
        // useSafeArea: false,
      );
    }

    void _onClosePressed() {
      Get.dialog(
        _quitExerciseDialog,
      );
    }

    Widget _exerciseBlockSetHeader = GetBuilder<ExerciseBlockController>(
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  () {
                    if (_.resting) {
                      return Text(
                        _.currentSet.toString() + '세트 준비 중...',
                        style: const TextStyle(
                          // color: brightPrimaryColor,
                          color: darkSecondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return Text(
                      _.currentSet.toString() + '세트 진행 중...',
                      style: const TextStyle(
                        color: brightPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }(),
                  Text(
                    '총 ' + _.numSets.toString() + '세트',
                    style: const TextStyle(
                      color: deepGrayColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                width: context.width - 60,
                height: 15,
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: (context.width - 60) * _.currentSet / _.numSets,
                  height: 15,
                  decoration: BoxDecoration(
                    color: _.resting ? darkSecondaryColor : brightPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TargetMuscleLabel(
                        targetMuscle: _.exerciseData['target_muscle'],
                      ),
                      horizontalSpacer(10),
                      ExerciseMethodLabel(
                        exerciseMethod: _.exerciseData['exercise_method'],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '총 운동 시간',
                        style: TextStyle(
                          color: clearBlackColor,
                          fontSize: 14,
                        ),
                      ),
                      GetX<ExerciseBlockController>(builder: (__) {
                        return Text(
                          formatHHMMSS(__.totalExerciseTime.value),
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkPrimaryColor,
                            letterSpacing: -1,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    Widget _currentExerciseTimeCounter = Container(
      height: 260,
      width: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 12,
          color: brightPrimaryColor,
        ),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: context.width - 60,
        maxHeight: context.width - 60,
      ),
      alignment: Alignment.center,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          verticalSpacer(45),
          SizedBox(
            width: 170,
            child: Column(
              children: [
                Text(
                  controller.exerciseData['name'],
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: darkPrimaryColor,
                  ),
                ),
                verticalSpacer(3),
                const Text(
                  '운동시간',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: darkPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          GetX<ExerciseBlockController>(builder: (__) {
            if (__.currentExerciseTime.value >= 3600) {
              return Text(
                formatHHMMSS(__.currentExerciseTime.value),
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: darkPrimaryColor,
                ),
              );
            } else {
              return Text(
                formatMMSS(__.currentExerciseTime.value),
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: darkPrimaryColor,
                ),
              );
            }
          }),
        ],
      ),
    );

    Widget _restTimeCounter = Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Center(
        child: SizedBox(
          width: 260,
          height: 260,
          child: GetBuilder<ExerciseBlockController>(builder: (_) {
            return LiquidCircularProgressIndicator(
              value: _.timerAnimationController.value,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(
                darkSecondaryColor.withOpacity(0.4),
              ),
              borderColor: darkSecondaryColor,
              borderWidth: 12,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '휴식중',
                    style: TextStyle(
                      fontSize: 16,
                      color: darkPrimaryColor,
                    ),
                  ),
                  GetX<ExerciseBlockController>(builder: (_) {
                    return Text(
                      formatMMSS(_.restTime.value),
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: darkPrimaryColor,
                        fontFamily: 'Manrope',
                      ),
                    );
                  })
                ],
              ),
            );
          }),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: WillPopScope(
        onWillPop: () => Future(() => false),
        child: Column(
          children: [
            Header(
              icon: const Icon(
                Icons.close_rounded,
                color: clearBlackColor,
                size: 30,
              ),
              onPressed: _onClosePressed,
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                  child: TextActionButton(
                    buttonText: '운동 끝',
                    onPressed: _onEndExercisePressed,
                    isUnderlined: false,
                    textColor: clearBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            _exerciseBlockSetHeader,
            Expanded(
              child: DisableGlowListView(
                children: [
                  GetBuilder<ExerciseBlockController>(builder: (_) {
                    if (_.resting) {
                      Future.delayed(const Duration(seconds: 3),
                          () => _.hideRestStartHint());
                      if (_.showRestStartHint) {
                        List<Widget> _children = [
                          const Text(
                            '휴식을 시작합니다',
                            style: TextStyle(
                              fontSize: 30,
                              color: clearBlackColor,
                            ),
                          ),
                        ];

                        return SizedBox(
                          height: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: _children,
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 90,
                          child: Column(
                            children: [
                              const Text(
                                '다음 세트 목표',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: clearBlackColor,
                                ),
                              ),
                              Text(
                                (_.exerciseData['exercise_method'] == 1
                                        ? ''
                                        : (getCleanTextFromDouble(
                                                _.exercisePlan![_.currentSet -
                                                    1]['target_weight']) +
                                            'kg X ')) +
                                    _.exercisePlan![_.currentSet - 1]
                                            ['target_reps']
                                        .toString() +
                                    '회',
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: clearBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return SizedBox(
                        height: 90,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: FittedBox(
                                  child: Text(
                                    _.exerciseData['name'] +
                                        ' ' +
                                        _.currentSet.toString() +
                                        '세트',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: clearBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                              () {
                                if (_.inputSetRecordDone) {
                                  return IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '기록 ' +
                                              (_.exerciseData[
                                                          'target_muscle'] ==
                                                      1
                                                  ? ''
                                                  : (getCleanTextFromDouble(
                                                          double.parse((_
                                                              .inputSetValues![
                                                                  0]
                                                              .text))) +
                                                      'kg X ')) +
                                              _.inputSetValues![1].text +
                                              '회',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: brightPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Manrope',
                                          ),
                                        ),
                                        const VerticalDivider(
                                          color: lightGrayColor,
                                          thickness: 3,
                                          width: 20,
                                          indent: 2,
                                          endIndent: 2,
                                        ),
                                        Text(
                                          '목표 ' +
                                              (_.exerciseData[
                                                          'target_muscle'] ==
                                                      1
                                                  ? ''
                                                  : (getCleanTextFromDouble(_
                                                          .exercisePlan![_
                                                              .currentSet -
                                                          1]['target_weight']) +
                                                      'kg X ')) +
                                              _.exercisePlan![_.currentSet - 1]
                                                      ['target_reps']
                                                  .toString() +
                                              '회',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xffA7A7A7),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Manrope',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Text(
                                  (_.exerciseData['exercise_method'] == 1
                                          ? ''
                                          : (getCleanTextFromDouble(
                                                  _.exercisePlan![_.currentSet -
                                                      1]['target_weight']) +
                                              'kg X ')) +
                                      _.exercisePlan![_.currentSet - 1]
                                              ['target_reps']
                                          .toString() +
                                      '회',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: clearBlackColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Manrope',
                                  ),
                                );
                              }(),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                  GetBuilder<ExerciseBlockController>(builder: (_) {
                    if (_.resting) {
                      return _restTimeCounter;
                    } else {
                      return _currentExerciseTimeCounter;
                    }
                  }),
                ],
              ),
            ),
            SizedBox(
              height: 70,
              width: 280,
              child: GetBuilder<ExerciseBlockController>(
                builder: (_) {
                  if (!_.exercisePaused) {
                    return ElevatedActionButton(
                      buttonText: _.currentSet.toString() + '세트 완료',
                      onPressed: _onCompleteSetPressed,
                      textStyle: const TextStyle(
                        color: mainBackgroundColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: 100,
                    );
                  } else if (_.recordingExerciseSet) {
                    return _.inputSetRecordDone
                        ? ElevatedActionButton(
                            buttonText: '기록 완료',
                            textStyle: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: mainBackgroundColor,
                            ),
                            borderRadius: 100,
                            onPressed: _onCompleteSetRecordPressed,
                          )
                        : Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              ElevatedActionButton(
                                height: 70,
                                width: 280,
                                borderRadius: 100,
                                backgroundColor: Colors.white,
                                overlayColor:
                                    brightPrimaryColor.withOpacity(0.1),
                                textStyle: const TextStyle(
                                  color: brightPrimaryColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Manrope',
                                ),
                                buttonText:
                                    (_.exerciseData['exercise_method'] == 1
                                            ? ''
                                            : (_.inputSetValues![0].text +
                                                'kg X ')) +
                                        _.inputSetValues![1].text +
                                        '회',
                                onPressed: _onInputExerciseRecordPressed,
                              ),
                              const Positioned(
                                right: 20,
                                child: Icon(
                                  Icons.edit_rounded,
                                  color: brightPrimaryColor,
                                ),
                              ),
                            ],
                          );
                  } else if (_.resting) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: _onSubtractTotalRestPressed,
                                highlightColor:
                                    darkSecondaryColor.withOpacity(0.2),
                                splashColor:
                                    darkSecondaryColor.withOpacity(0.2),
                                icon: const SubtractIcon(
                                  color: darkSecondaryColor,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              const Text(
                                '10초',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkSecondaryColor,
                                  fontSize: 26,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                              IconButton(
                                highlightColor:
                                    darkSecondaryColor.withOpacity(0.2),
                                splashColor:
                                    darkSecondaryColor.withOpacity(0.2),
                                onPressed: _onAddTotalRestPressed,
                                icon: const AddIcon(
                                  color: darkSecondaryColor,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    Future.delayed(Duration.zero,
                        () => TooltipController.to.activateTooltip());
                    return SlidableButton(
                      width: 280,
                      height: 70,
                      color: Colors.white,
                      buttonColor: brightPrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            XIcon(),
                            CheckIcon(),
                          ],
                        ),
                      ),
                      buttonWidth: 50,
                      buttonHeight: 50,
                      onChanged: _onSlidableButtonPositionChanged,
                    );
                  }
                },
              ),
            ),
            GetBuilder<ExerciseBlockController>(builder: (_) {
              if (_.exercisePaused &&
                  _.recordingExerciseSet &&
                  !_.inputSetRecordDone) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 55),
                  child: TextActionButton(
                    buttonText: '완료',
                    onPressed: _onInputSetRecordDonePressed,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    textColor: brightPrimaryColor,
                  ),
                );
              } else if (_.resting) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 55),
                  child: TextActionButton(
                    buttonText: '건너뛰기',
                    onPressed: _onEndRestPressed,
                  ),
                );
              } else {
                return verticalSpacer(100);
              }
            }),
          ],
        ),
      ),
    );
  }
}
