import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_plan_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/keep_alive_wrapper.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/exercise/set_input_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/helpers/utils.dart';

class AddExerciseDetailsPage extends GetView<ExercisePlanController> {
  const AddExerciseDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _crashText = '정보를 찾을 수 없습니다';
    const String _targetTimeLabelText = '목표 시간';
    const String _targetDistanceLabelText = '목표 거리';
    const String _loadRecordButtonText = '최근 기록 가져오기 >';
    const String _addSetButtonText = '세트 추가';
    const String _completeButtonText = '완료';

    int _targetMuscle = controller.selectedExerciseInfo['target_muscle'];
    int _exerciseMethod = controller.selectedExerciseInfo['exercise_method'];

    void _onBackPressed() {
      if (controller.isUpdate) {
        Get.back();
        Future.delayed(const Duration(seconds: 1), () {
          controller.resetExerciseWeightDetails();
          controller.resetExerciseCardioDetails();
          controller.resetExerciseUpdate();
        });
      } else {
        controller.jumpToPage(0);
        controller.resetExerciseWeightDetails();
        controller.resetExerciseCardioDetails();
      }
    }

    void _onLoadRecordPressed() {
      controller.loadRecentExercisePlan();
    }

    void _onDeleteSetPressed(int setNum) {
      controller.deleteSet(setNum);
    }

    void _onCompletePressed() {
      if (controller.isUpdate) {
        if (controller.exerciseType == 0) {
          controller.updateExercisePlanWeight();
        } else {
          controller.updateExercisePlanCardio();
        }
        Get.back();
      } else {
        if (controller.exerciseType == 0) {
          controller.postExerciseWeightPlan();
        } else {
          controller.postExerciseCardioPlan();
        }
        HomeController.to.updateRefreshModeWeek(false);
        Future.delayed(Duration.zero, () {
          HomeController.to.refreshController.requestRefresh();
        });

        Get.back();
      }
    }

    void _onSetPressed(int setNum) {
      controller.updateInputSetNum(setNum);
    }

    void _onAddSetPressed() {
      controller.addSet();
      controller.updateInputSetNum(controller.numSets);
    }

    void _updateDistanceChangeValue(int index) {
      controller
          .updateInputDistanceChangeValue(inputDistanceChangeValueList[index]);
    }

    void _onSubtractDistancePressed() {
      controller.subtractDistance();
    }

    void _onAddDistancePressed() {
      controller.addDistance();
    }

    void _onDistanceInputChanged(String val) {
      controller.onDistanceInputChanged(val);
    }

    Widget _exerciseInfoSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            controller.selectedExerciseInfo['name'],
            style: const TextStyle(
              fontSize: 20,
              color: clearBlackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        controller.exerciseType == 0
            ? Row(
                children: [
                  TargetMuscleLabel(
                    targetMuscle: _targetMuscle,
                  ),
                  horizontalSpacer(10),
                  ExerciseMethodLabel(
                    exerciseMethod: _exerciseMethod,
                  ),
                ],
              )
            : Row(
                children: [
                  const CardioLabel(),
                  horizontalSpacer(10),
                  CardioMethodLabel(
                    exerciseMethod: _exerciseMethod,
                  ),
                ],
              ),
      ],
    );

    Widget _exerciseSetBlock(int setNum) {
      return GetBuilder<ExercisePlanController>(
        builder: (_) {
          if (setNum == 1) {
            return SizedBox(
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: setNum == _.inputSetNum
                      ? brightPrimaryColor.withOpacity(0.15)
                      : lightGrayColor.withOpacity(0.15),
                  border: const Border(
                    bottom: BorderSide(
                      color: lightGrayColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => _onSetPressed(setNum),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$setNum세트',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            (_.selectedExerciseInfo['exercise_method'] == 1
                                    ? '--'
                                    : _.inputSetControllerList[setNum - 1][0]
                                        .text) +
                                'kg',
                            style: const TextStyle(
                              color: clearBlackColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _.inputSetControllerList[setNum - 1][1].text + '회',
                            style: const TextStyle(
                              color: clearBlackColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: setNum == _.inputSetNum
                      ? brightPrimaryColor.withOpacity(0.15)
                      : lightGrayColor.withOpacity(0.15),
                  border: const Border(
                    bottom: BorderSide(
                      color: lightGrayColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => _onSetPressed(setNum),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 15),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$setNum세트',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                (_.selectedExerciseInfo['exercise_method'] == 1
                                        ? '--'
                                        : _
                                            .inputSetControllerList[setNum - 1]
                                                [0]
                                            .text) +
                                    'kg',
                                style: const TextStyle(
                                  color: clearBlackColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _.inputSetControllerList[setNum - 1][1].text +
                                    '회',
                                style: const TextStyle(
                                  color: clearBlackColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox.shrink(),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child: IconButton(
                                onPressed: () => _onDeleteSetPressed(setNum),
                                padding: EdgeInsets.zero,
                                splashRadius: 13,
                                iconSize: 15,
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Color(0xffD9433A),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    }

    Widget _addExerciseSetButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextActionButton(
        buttonText: _addSetButtonText,
        onPressed: _onAddSetPressed,
        fontSize: 18,
        textColor: clearBlackColor,
        isUnderlined: false,
        width: 170,
        fontWeight: FontWeight.w500,
      ),
    );

    Widget _targetTimeTabBarView = Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Builder(builder: (context) {
        List<Widget> _inputHourList = List.generate(
          10,
          (index) => Center(
            child: Text(
              index.toString(),
              style: const TextStyle(
                color: brightPrimaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Manrope',
              ),
            ),
          ),
        );

        List<Widget> _inputMinList = List.generate(
          60,
          (index) {
            return Center(
              child: Text(
                index.toString(),
                style: const TextStyle(
                  color: brightPrimaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Manrope',
                ),
              ),
            );
          },
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 240,
              child: GetBuilder<ExercisePlanController>(
                builder: (_) {
                  _.targetHourScrollController = FixedExtentScrollController();

                  return CupertinoPicker(
                    scrollController: _.targetHourScrollController,
                    itemExtent: 60,
                    onSelectedItemChanged: _.updateInputCardioHour,
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
                    children: _inputHourList,
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text(
                '시간',
                style: TextStyle(
                  color: brightPrimaryColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                width: 45,
                height: 240,
                child: GetBuilder<ExercisePlanController>(builder: (_) {
                  _.targetMinScrollController = FixedExtentScrollController();
                  return CupertinoPicker(
                    scrollController: _.targetMinScrollController,
                    itemExtent: 60,
                    onSelectedItemChanged: _.updateInputCardioMin,
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
                    children: _inputMinList,
                  );
                }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text(
                '분',
                style: TextStyle(
                  color: brightPrimaryColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
          ],
        );
      }),
    );

    Widget _targetDistanceTabBarView = GetBuilder<ExercisePlanController>(
      builder: (_) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _onSubtractDistancePressed,
                    highlightColor: brightPrimaryColor.withOpacity(0.2),
                    splashColor: brightPrimaryColor.withOpacity(0.2),
                    icon: const SubtractIcon(
                      color: brightPrimaryColor,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        NumberInputField(
                          controller: _.targetDistanceTextController,
                          onChanged: _onDistanceInputChanged,
                          hintText: '0.0',
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
                    highlightColor: brightPrimaryColor.withOpacity(0.2),
                    splashColor: brightPrimaryColor.withOpacity(0.2),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4 + 3,
                (index) => index % 2 == 1
                    ? horizontalSpacer(10)
                    : ElevatedActionButton(
                        height: 31,
                        width: 56,
                        buttonText: getCleanTextFromDouble(
                            inputDistanceChangeValueList[index ~/ 2]),
                        onPressed: () => _updateDistanceChangeValue(index ~/ 2),
                        backgroundColor: _.inputDistanceChangeValue ==
                                inputDistanceChangeValueList[index ~/ 2]
                            ? const Color(0xff007590)
                            : const Color(0xff40CCEC),
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          overflow: TextOverflow.visible,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );

    Widget _exercisePlanDetailsInput = GetBuilder<ExercisePlanController>(
      builder: (_) {
        if (controller.exerciseType == 0) {
          var children = List.generate(
            _.numSets,
            (index) {
              return _exerciseSetBlock(index + 1);
            },
          );
          children.add(_addExerciseSetButton);
          return Column(
            children: children,
          );
        } else {
          return SizedBox(
            height: 300,
            child: Column(
              children: [
                SizedBox(
                  height: 85,
                  child: TabBar(
                    labelPadding: EdgeInsets.zero,
                    controller: _.cardioPlanInputTabController,
                    physics: const NeverScrollableScrollPhysics(),
                    indicatorColor: Colors.transparent,
                    tabs: <Widget>[
                      GetBuilder<ExercisePlanController>(builder: (_) {
                        return Container(
                          constraints: const BoxConstraints.expand(height: 100),
                          decoration: BoxDecoration(
                            color: _.cardioPlanInputTabController.index == 0
                                ? brightPrimaryColor.withOpacity(0.12)
                                : lightGrayColor.withOpacity(0.12),
                            border: _.cardioPlanInputTabController.index == 0
                                ? Border.all(
                                    color: brightPrimaryColor, width: 1)
                                : const Border(
                                    bottom: BorderSide(
                                        color: lightGrayColor, width: 0.5),
                                  ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            children: [
                              const Text(
                                _targetTimeLabelText,
                                style: TextStyle(
                                  color: clearBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  (_.inputCardioHour == 0 &&
                                          _.inputCardioMin == 0)
                                      ? '--'
                                      : (_.inputCardioHour.toString() +
                                          '시간 ' +
                                          _.inputCardioMin.toString() +
                                          '분'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: clearBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      GetBuilder<ExercisePlanController>(builder: (_) {
                        return Container(
                          constraints: const BoxConstraints.expand(),
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: _.cardioPlanInputTabController.index == 1
                                ? brightPrimaryColor.withOpacity(0.12)
                                : lightGrayColor.withOpacity(0.12),
                            border: _.cardioPlanInputTabController.index == 1
                                ? Border.all(
                                    color: brightPrimaryColor, width: 1)
                                : const Border(
                                    bottom: BorderSide(
                                        color: lightGrayColor, width: 0.5),
                                  ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            children: [
                              const Text(
                                _targetDistanceLabelText,
                                style: TextStyle(
                                  color: clearBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  (_.targetDistanceTextController.text.isEmpty
                                          ? true
                                          : double.parse(_
                                                  .targetDistanceTextController
                                                  .text) ==
                                              0)
                                      ? '--'
                                      : (_.targetDistanceTextController.text +
                                          'km'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: clearBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.cardioPlanInputTabController,
                    children: [
                      KeepAliveWrapper(child: _targetTimeTabBarView),
                      KeepAliveWrapper(child: _targetDistanceTabBarView),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );

    Widget _completeButtonSection = Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 40),
      child: GetBuilder<ExercisePlanController>(
        builder: (_) {
          bool _isActivated = false;

          if (_.isUpdate) {
            if (_.exerciseType == 0) {
              if (_.selectedExerciseInfo['exercise_method'] == 1) {
                _isActivated = _.inputSetControllerList.every((element) =>
                    element[0].text == '0.0' &&
                    element[1].text.isNotEmpty &&
                    element[1].text != '0');
                if (_isActivated) {
                  bool _isSame = true;
                  _.inputSetControllerList.asMap().forEach(
                    (index, element) {
                      if (index < _.previousExercisePlan.length) {
                        _isSame = _isSame &&
                            (int.parse(element[1].text) ==
                                _.previousExercisePlan['sets'][index]
                                    ['target_reps']);
                      } else {
                        _isSame = false;
                      }
                    },
                  );
                  if (_isSame) {
                    _isActivated = false;
                  }
                }
              } else {
                _isActivated = _.inputSetControllerList.every((element) =>
                    element[0].text.isNotEmpty &&
                    element[0].text != '0.0' &&
                    element[0].text != '0' &&
                    element[1].text.isNotEmpty &&
                    element[1].text != '0');
                if (_isActivated) {
                  bool _isSame = true;
                  _.inputSetControllerList.asMap().forEach(
                    (index, element) {
                      if (index < _.previousExercisePlan.length) {
                        _isSame = _isSame &&
                            (double.parse(element[0].text) ==
                                _.previousExercisePlan['sets'][index]
                                    ['target_weight']);
                        _isSame = _isSame &&
                            (int.parse(element[1].text) ==
                                _.previousExercisePlan['sets'][index]
                                    ['target_reps']);
                      } else {
                        _isSame = false;
                      }
                    },
                  );
                  if (_isSame) {
                    _isActivated = false;
                  }
                }
              }
            } else {
              _isActivated = (_.targetDistanceTextController.text.isNotEmpty
                      ? double.parse(_.targetDistanceTextController.text) > 0
                      : false) ||
                  _.inputCardioHour != 0 ||
                  _.inputCardioMin != 0;
              if (_isActivated) {
                if (_.previousExercisePlan['target_distance'] != null) {
                  _isActivated =
                      double.parse(_.targetDistanceTextController.text) !=
                          _.previousExercisePlan['target_distance'];
                }
                if (_.previousExercisePlan['target_duration'] != null) {}
                _isActivated = _isActivated &&
                    !(_.inputCardioHour ==
                            _.previousExercisePlan['target_duration'] ~/ 3600 &&
                        _.inputCardioMin ==
                            (_.previousExercisePlan['target_duration'] %
                                    3600) ~/
                                60);
              }
            }
          } else {
            if (_.exerciseType == 0) {
              if (_.selectedExerciseInfo['exercise_method'] == 1) {
                _isActivated = _.inputSetControllerList.every((element) =>
                    element[0].text == '0.0' &&
                    element[1].text.isNotEmpty &&
                    element[1].text != '0');
              } else {
                _isActivated = _.inputSetControllerList.every((element) =>
                    element[0].text.isNotEmpty &&
                    element[0].text != '0.0' &&
                    element[0].text != '0' &&
                    element[1].text.isNotEmpty &&
                    element[1].text != '0');
              }
            } else {
              _isActivated = (_.targetDistanceTextController.text.isNotEmpty
                      ? double.parse(_.targetDistanceTextController.text) > 0
                      : false) ||
                  _.inputCardioHour != 0 ||
                  _.inputCardioMin != 0;
            }
          }

          return Center(
            child: ElevatedActionButton(
              buttonText: _completeButtonText,
              onPressed: _onCompletePressed,
              activated: _isActivated,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              disabledColor: lightGrayColor,
            ),
          );
        },
      ),
    );

    return Column(
      children: [
        Header(
          onPressed: _onBackPressed,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 30,
                top: 15,
                bottom: 15,
              ),
              child: GetBuilder<ExercisePlanController>(builder: (_) {
                if (_.loading) {
                  return const AspectRatio(
                    aspectRatio: 1,
                    child: CircularLoadingIndicator(),
                  );
                } else {
                  return TextActionButton(
                    buttonText: _loadRecordButtonText,
                    onPressed: _onLoadRecordPressed,
                    fontSize: 13,
                    isUnderlined: false,
                    textColor: softGrayColor,
                  );
                }
              }),
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              // color: darkSecondaryColor,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: context.width,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
            child: SingleChildScrollView(
              child: controller.selectedExerciseInfo.isEmpty
                  ? const Center(child: Text(_crashText))
                  : Column(
                      children: [
                        _exerciseInfoSection,
                        Column(
                          children: [
                            verticalSpacer(20),
                            _exercisePlanDetailsInput,
                            verticalSpacer(60),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ),
        GetBuilder<ExercisePlanController>(
          builder: (_) {
            if (_.exerciseType == 0) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                  width: context.width,
                  height: _.inputSetNum == null ? null : 0,
                  child: _.inputSetNum == null ? _completeButtonSection : null,
                ),
              );
            } else {
              return _completeButtonSection;
            }
          },
        ),
        GetBuilder<ExercisePlanController>(
          builder: (_) {
            if (_.exerciseType == 0) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                  width: context.width,
                  height: _.inputSetNum == null ? 0 : null,
                  child: _.inputSetNum == null
                      ? null
                      : WeightSetInputSection(
                          bodyWeight:
                              _.selectedExerciseInfo['exercise_method'] == 1,
                        ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
