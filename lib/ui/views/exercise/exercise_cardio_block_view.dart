import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:exon_app/helpers/utils.dart';

const Color _progressBackgroundColor = Color(0xffEAE9EF);

class ExerciseCardioBlockView extends GetView<ExerciseBlockController> {
  const ExerciseCardioBlockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _quitExercise() {
      Get.back(closeOverlays: true);
      controller.reset();
    }

    void _onRestPressed() {
      controller.startCardioRest();
    }

    void _onContinuePressed() {
      controller.endCardioRest();
    }

    void _endExercise() {
      controller.endExerciseCardio();
    }

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
                    SizedBox(
                      width: 170,
                      height: 65,
                      child: ElevatedActionButton(
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
                    ),
                    SizedBox(
                      width: 170,
                      height: 65,
                      child: ElevatedActionButton(
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              () {
                if (_.resting) {
                  return Text(
                    _.exerciseData['name'] + ' 운동 휴식 중...',
                    style: const TextStyle(
                      color: darkSecondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else {
                  return Text(
                    _.exerciseData['name'] + ' 운동 진행 중...',
                    style: const TextStyle(
                      color: brightPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              }(),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: LinearLoadingIndicator(
                  width: context.width - 60,
                  indicatorColor:
                      _.resting ? darkSecondaryColor : brightPrimaryColor,
                  duration: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CardioLabel(),
                      horizontalSpacer(10),
                      CardioMethodLabel(
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

    Widget _currentExerciseTimeCounter = controller
                .exercisePlanCardio['target_duration'] !=
            null
        ? Padding(
            padding: const EdgeInsets.only(top: 30),
            child: GetX<ExerciseBlockController>(
              builder: (__) {
                return CircularPercentIndicator(
                  radius: 130,
                  lineWidth: 12,
                  backgroundColor: _progressBackgroundColor,
                  progressColor: brightPrimaryColor,
                  percent: __.currentExerciseTime.value /
                      __.exercisePlanCardio['target_duration'],
                  circularStrokeCap: CircularStrokeCap.round,
                  center: SizedBox(
                    width: 236,
                    height: 236,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          verticalSpacer(55),
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
                          GetX<ExerciseBlockController>(
                            builder: (__) {
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
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 30),
            child: CircularPercentIndicator(
              radius: 130,
              lineWidth: 12,
              backgroundColor: _progressBackgroundColor,
              progressColor: brightPrimaryColor,
              percent: 1,
              circularStrokeCap: CircularStrokeCap.round,
              center: SizedBox(
                width: 236,
                height: 236,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      verticalSpacer(55),
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
                      GetX<ExerciseBlockController>(
                        builder: (__) {
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

    Widget _restTimeCounter = controller
                .exercisePlanCardio['target_duration'] !=
            null
        ? Padding(
            padding: const EdgeInsets.only(top: 30),
            child: GetX<ExerciseBlockController>(
              builder: (__) {
                return CircularPercentIndicator(
                  radius: 130,
                  lineWidth: 12,
                  backgroundColor: _progressBackgroundColor,
                  progressColor: darkSecondaryColor,
                  percent: __.currentExerciseTime.value /
                      __.exercisePlanCardio['target_duration'],
                  circularStrokeCap: CircularStrokeCap.round,
                  center: SizedBox(
                    width: 236,
                    height: 236,
                    child: LiquidCircularProgressIndicator(
                      value: __.currentExerciseTime.value /
                          __.exercisePlanCardio['target_duration'],
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(
                        darkSecondaryColor.withOpacity(0.4),
                      ),
                      center: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          verticalSpacer(30),
                          const SizedBox(
                            width: 170,
                            child: Text(
                              '휴식중',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: darkPrimaryColor,
                                // color: darkPrimaryColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                          GetX<ExerciseBlockController>(
                            builder: (__) {
                              return Text(
                                formatMMSS(__.restTime.value),
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: darkPrimaryColor,
                                ),
                              );
                            },
                          ),
                          verticalSpacer(10),
                          GetX<ExerciseBlockController>(
                            builder: (__) {
                              if (__.currentExerciseTime.value >= 3600) {
                                return Text(
                                  formatHHMMSS(__.currentExerciseTime.value),
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: darkPrimaryColor.withOpacity(0.4),
                                  ),
                                );
                              } else {
                                return Text(
                                  formatMMSS(__.currentExerciseTime.value),
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: darkPrimaryColor.withOpacity(0.4),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 30),
            child: CircularPercentIndicator(
              radius: 130,
              lineWidth: 12,
              backgroundColor: _progressBackgroundColor,
              progressColor: darkSecondaryColor,
              percent: 1,
              circularStrokeCap: CircularStrokeCap.round,
              center: SizedBox(
                width: 236,
                height: 236,
                child: LiquidCircularProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(
                    darkSecondaryColor.withOpacity(0.4),
                  ),
                  center: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      verticalSpacer(30),
                      const SizedBox(
                        width: 170,
                        child: Text(
                          '휴식중',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: darkPrimaryColor,
                            // color: darkPrimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      GetX<ExerciseBlockController>(
                        builder: (__) {
                          return Text(
                            formatMMSS(__.restTime.value),
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: darkPrimaryColor,
                            ),
                          );
                        },
                      ),
                      verticalSpacer(10),
                      GetX<ExerciseBlockController>(
                        builder: (__) {
                          if (__.currentExerciseTime.value >= 3600) {
                            return Text(
                              formatHHMMSS(__.currentExerciseTime.value),
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: darkPrimaryColor.withOpacity(0.4),
                              ),
                            );
                          } else {
                            return Text(
                              formatMMSS(__.currentExerciseTime.value),
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: darkPrimaryColor.withOpacity(0.4),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
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
            ),
            _exerciseBlockSetHeader,
            Expanded(
              child: DisableGlowListView(
                children: [
                  GetBuilder<ExerciseBlockController>(
                    builder: (_) {
                      if (_.showRestStartHint && _.resting) {
                        Future.delayed(const Duration(seconds: 3),
                            () => _.hideRestStartHint());
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
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: _children,
                          ),
                        );
                      } else {
                        int? _targetDuration =
                            _.exercisePlanCardio['target_duration'];
                        double? _targetDistance =
                            _.exercisePlanCardio['target_distance'];
                        late String _targetInfoText;

                        if (_targetDuration != null) {
                          if (_targetDistance != null && _targetDistance > 0) {
                            _targetInfoText =
                                formatTimeToText(_targetDuration) +
                                    ' | ' +
                                    getCleanTextFromDouble(_targetDistance) +
                                    'km';
                          } else {
                            _targetInfoText = formatTimeToText(_targetDuration);
                          }
                        } else {
                          _targetInfoText = '목표: ' +
                              getCleanTextFromDouble(_targetDistance!) +
                              'km';
                        }

                        return SizedBox(
                          // height: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                FittedBox(
                                  child: Text(
                                    _.exerciseData['name'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: clearBlackColor,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    _targetInfoText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: clearBlackColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Manrope',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
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
                  if (!_.resting) {
                    return ElevatedActionButton(
                      buttonText: '휴식',
                      onPressed: _onRestPressed,
                      textStyle: const TextStyle(
                        color: mainBackgroundColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: 100,
                    );
                  } else {}
                  return ElevatedActionButton(
                    buttonText: '계속하기',
                    onPressed: _onContinuePressed,
                    backgroundColor: darkSecondaryColor,
                    textStyle: const TextStyle(
                      color: mainBackgroundColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: 100,
                  );
                },
              ),
            ),
            GetBuilder<ExerciseBlockController>(builder: (_) {
              return Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 55),
                child: TextActionButton(
                  buttonText: '운동 종료하기',
                  onPressed: _endExercise,
                  isUnderlined: false,
                  textColor: clearBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
