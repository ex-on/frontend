import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_plan_controller.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/custom_refresh_header.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DailyExercisePlansPage extends GetView<ExercisePlanController> {
  const DailyExercisePlansPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _totalExercisePlanNumText = '총 운동 ';

    Future.delayed(Duration.zero, () {
      if (controller.dailyExercisePlans.isEmpty) {
        controller.exercisePlansRefreshController.requestRefresh();
      }
    });

    void _onBackPressed() {
      Get.back();
    }

    void _onStartPressed(Map<String, dynamic> planData,
        Map<String, dynamic> exerciseData) async {
      if (exerciseData['target_muscle'] != null) {
        await ExerciseBlockController.to
            .getExercisePlanWeightSets(planData['id']);
        ExerciseBlockController.to
            .startExerciseWeight(planData['id'], exerciseData);
      } else {
        ExerciseBlockController.to.updateExercisePlanCardio(planData);
        ExerciseBlockController.to
            .startExerciseCardio(planData['id'], exerciseData);
      }
    }

    void _onDeletePressed(int index) async {
      Get.back();
      await controller.deleteExercisePlan(index);
    }

    void _onEditPressed(int index) {
      controller.initializeExerciseUpdate(index);
      Get.back();
      Get.toNamed('/add_exercise');
    }

    void _onMenuPressed(int index) {
      Get.bottomSheet(
        CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => _onDeletePressed(index),
              child: const Text(
                '삭제',
                style: TextStyle(
                  color: cancelRedColor,
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _onEditPressed(index),
              child: const Text(
                '수정',
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Get.back(),
            child: const Text(
              '취소',
              style: TextStyle(
                color: clearBlackColor,
              ),
            ),
          ),
        ),
      );
    }

    Widget _exerciseSetBlock(int index, int setNum) {
      return SizedBox(
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: lightGrayColor.withOpacity(0.15),
            border: const Border(
              bottom: BorderSide(
                color: lightGrayColor,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${setNum + 1}세트',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  (controller.dailyExercisePlans[index]['exercise_data']
                                  ['exercise_method'] ==
                              1
                          ? '--'
                          : getCleanTextFromDouble(
                              controller.dailyExercisePlans[index]['plan_data']
                                  ['sets'][setNum]['target_weight'])) +
                      'kg',
                  style: const TextStyle(
                    color: clearBlackColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  controller.dailyExercisePlans[index]['plan_data']['sets']
                              [setNum]['target_reps']
                          .toString() +
                      '회',
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
      );
    }

    Widget _exerciseCardioBlock(int index) {
      return SizedBox(
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: lightGrayColor.withOpacity(0.15),
            border: const Border(
              bottom: BorderSide(
                color: lightGrayColor,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Text(
                  (controller.dailyExercisePlans[index]['plan_data']
                                  ['target_distance'] ==
                              null
                          ? '--'
                          : getCleanTextFromDouble(
                              controller.dailyExercisePlans[index]['plan_data']
                                  ['target_distance'])) +
                      'km',
                  style: const TextStyle(
                    color: clearBlackColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  controller.dailyExercisePlans[index]['plan_data']
                              ['target_duration'] ==
                          null
                      ? '--'
                      : formatTimeToText(controller.dailyExercisePlans[index]
                          ['plan_data']['target_duration']),
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
      );
    }

    Widget _exercisePlanDetails(int index) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Builder(
          builder: (context) {
            if (controller.dailyExercisePlans[index]['exercise_data']['type'] ==
                0) {
              return Column(
                children: List.generate(
                  controller
                      .dailyExercisePlans[index]['plan_data']['sets'].length,
                  (setNum) {
                    return _exerciseSetBlock(index, setNum);
                  },
                ),
              );
            } else {
              return _exerciseCardioBlock(index);
            }
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            onPressed: _onBackPressed,
            title: DateFormat('yyyy년 MM월 dd일').format(DateTime.now()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
              _totalExercisePlanNumText +
                  HomeController.to.indexDayExercisePlanList.length.toString() +
                  '개',
              style: const TextStyle(
                color: softGrayColor,
                fontSize: 13.7,
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<ExercisePlanController>(
              builder: (_) {
                return SmartRefresher(
                  controller: _.exercisePlansRefreshController,
                  onRefresh: _.onExercisePlansRefresh,
                  header: const CustomRefreshHeader(),
                  child: _.dailyExercisePlans.isEmpty
                      ? ListView(
                          children: const [],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(30, 8, 30, 30),
                          itemBuilder: (context, index) {
                            var exerciseData = HomeController
                                    .to.indexDayExercisePlanList[index]
                                ['exercise_data'];
                            var planData = HomeController.to
                                .indexDayExercisePlanList[index]['plan_data'];
                            if (index > _.dailyExercisePlans.length) {
                              return const SizedBox.shrink();
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            StartExerciseButton(
                                              onStartPressed: () =>
                                                  _onStartPressed(
                                                planData,
                                                exerciseData,
                                              ),
                                            ),
                                            horizontalSpacer(15),
                                            if (exerciseData['target_muscle'] !=
                                                null)
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    exerciseData['name'],
                                                    style: const TextStyle(
                                                      height: 1.0,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: clearBlackColor,
                                                    ),
                                                  ),
                                                  verticalSpacer(10),
                                                  TargetMuscleLabel(
                                                    targetMuscle: exerciseData[
                                                        'target_muscle'],
                                                    text:
                                                        '${targetMuscleIntToStr[exerciseData['target_muscle']]} / ${exerciseMethodIntToStr[exerciseData['exercise_method']]} / ${planData['num_sets']}세트',
                                                  ),
                                                ],
                                              )
                                            else
                                              Builder(
                                                builder: (context) {
                                                  String _targetDistance = '';
                                                  String _targetDuration = '';

                                                  if (planData[
                                                          'target_distance'] !=
                                                      null) {
                                                    _targetDistance = ' / ' +
                                                        getCleanTextFromDouble(
                                                            planData[
                                                                'target_distance']) +
                                                        'km';
                                                  }

                                                  if (planData[
                                                          'target_duration'] !=
                                                      null) {
                                                    _targetDuration = ' / ' +
                                                        formatTimeToText(planData[
                                                            'target_duration']);
                                                  }

                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            exerciseData[
                                                                'name'],
                                                            style:
                                                                const TextStyle(
                                                              height: 1.0,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  clearBlackColor,
                                                            ),
                                                          ),
                                                          verticalSpacer(10),
                                                          CardioLabel(
                                                            text:
                                                                '유산소 / ${cardioMethodIntToStr[exerciseData['exercise_method']]}$_targetDistance$_targetDuration',
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                        Positioned(
                                          right: 10,
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    _onMenuPressed(index),
                                                padding: EdgeInsets.zero,
                                                iconSize: 20,
                                                icon: const Icon(
                                                  Icons.edit_rounded,
                                                  color: deepGrayColor,
                                                  size: 20,
                                                ),
                                                splashRadius: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    _exercisePlanDetails(index),
                                  ],
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, index) =>
                              verticalSpacer(24),
                          itemCount: _.dailyExercisePlans.length,
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
