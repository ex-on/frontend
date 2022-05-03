import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/circle.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExercisePlanBlock extends StatelessWidget {
  final Map<String, dynamic> exerciseData;
  final Map<String, dynamic> planData;
  final bool incomplete;
  const ExercisePlanBlock({
    Key? key,
    required this.exerciseData,
    required this.planData,
    required this.incomplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onPressed() {
      Get.toNamed('exercise_plans');
    }

    void _onStartPressed() async {
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

    return Container(
      height: 95,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: incomplete ? null : _onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 24,
              right: 18,
            ),
            child: Row(
              children: [
                incomplete
                    ? const IncompleteIcon()
                    : StartExerciseButton(onStartPressed: _onStartPressed),
                horizontalSpacer(15),
                exerciseData['target_muscle'] != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exerciseData['name'],
                            style: const TextStyle(
                              height: 1.0,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: clearBlackColor,
                            ),
                          ),
                          verticalSpacer(10),
                          TargetMuscleLabel(
                            targetMuscle: exerciseData['target_muscle'],
                            text:
                                '${targetMuscleIntToStr[exerciseData['target_muscle']]} / ${exerciseMethodIntToStr[exerciseData['exercise_method']]} / ${planData['num_sets']}세트',
                          ),
                        ],
                      )
                    : Builder(builder: (context) {
                        String _targetDistance = '';
                        String _targetDuration = '';

                        if (planData['target_distance'] != null) {
                          _targetDistance = ' / ' +
                              getCleanTextFromDouble(
                                  planData['target_distance']) +
                              'km';
                        }

                        if (planData['target_duration'] != null) {
                          _targetDuration = ' / ' +
                              formatTimeToText(planData['target_duration']);
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exerciseData['name'],
                              style: const TextStyle(
                                height: 1.0,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: clearBlackColor,
                              ),
                            ),
                            verticalSpacer(10),
                            CardioLabel(
                              text:
                                  '유산소 / ${cardioMethodIntToStr[exerciseData['exercise_method']]}$_targetDistance$_targetDuration',
                            ),
                          ],
                        );
                      }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseRecordBlock extends StatelessWidget {
  final Map<String, dynamic> exerciseData;
  final Map<String, dynamic> recordData;
  const ExerciseRecordBlock({
    Key? key,
    required this.exerciseData,
    required this.recordData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onPressed() {
      Get.toNamed('exercise_plans');
    }

    return Container(
      height: 95,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 24,
              right: 18,
            ),
            child: Row(
              children: [
                const CompleteIcon(),
                horizontalSpacer(15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseData['name'],
                      style: const TextStyle(
                        height: 1.0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    verticalSpacer(10),
                    (exerciseData['target_muscle'] != null)
                        ? Row(
                            children: [
                              TargetMuscleLabel(
                                text: targetMuscleIntToStr[
                                        exerciseData['target_muscle']]! +
                                    ' / ' +
                                    exerciseMethodIntToStr[
                                        exerciseData['exercise_method']]!,
                                targetMuscle: exerciseData['target_muscle'],
                              ),
                              horizontalSpacer(10),
                              ExerciseRecordLabel(
                                text: recordData['total_volume'] != 0
                                    ? '${recordData['total_sets']}세트 / ${getCleanTextFromDouble(recordData['total_volume'])}kg'
                                    : '${recordData['total_sets']}세트 / ${recordData['total_reps']}회',
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              CardioLabel(
                                text: '유산소 / ' +
                                    cardioMethodIntToStr[
                                        exerciseData['exercise_method']]!,
                              ),
                              horizontalSpacer(10),
                              Builder(builder: (context) {
                                String _recordDistance = '';
                                String _recordDuration = ' / ' +
                                    formatTimeToText(
                                        recordData['record_duration']);

                                if (recordData['record_distance'] != null) {
                                  _recordDistance = getCleanTextFromDouble(
                                          recordData['record_distance']) +
                                      'km';
                                }
                                return ExerciseRecordLabel(
                                  text: _recordDistance + _recordDuration,
                                );
                              }),
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseStatBlock extends GetView<StatsController> {
  final int exerciseId;
  final String exerciseName;
  final int? targetMuscle;
  final int exerciseMethod;
  final int count;
  final int time;
  const ExerciseStatBlock({
    Key? key,
    required this.exerciseId,
    required this.exerciseName,
    required this.targetMuscle,
    required this.exerciseMethod,
    required this.count,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onPressed() {
      controller.updateSelectedExerciseInfo(
        {
          'id': exerciseId,
          'name': exerciseName,
          'target_muscle': targetMuscle,
          'exercise_method': exerciseMethod,
        },
      );
      if (targetMuscle == null) {
        Get.toNamed('/stats/exercise/cardio');
      } else if (exerciseMethod == 1) {
        Get.toNamed('/stats/exercise/bodyweight');
      } else {
        Get.toNamed('/stats/exercise/weight');
      }
    }

    return Container(
      height: 76,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: mainBackgroundColor,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _onPressed,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 24, right: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      exerciseName,
                      style: const TextStyle(
                        height: 1.0,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    Expanded(
                      child: verticalSpacer(0),
                    ),
                    const Text(
                      '수행 횟수 ',
                      style: TextStyle(
                        fontSize: 11,
                        color: clearBlackColor,
                      ),
                    ),
                    Text(
                      count.toString() + '회',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: brightPrimaryColor,
                      ),
                    ),
                  ],
                ),
                targetMuscle != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TargetMuscleLabel(targetMuscle: targetMuscle!),
                          horizontalSpacer(10),
                          ExerciseMethodLabel(
                            exerciseMethod: exerciseMethod,
                          ),
                          const Expanded(
                            child: SizedBox(
                              height: 0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Text(
                              formatTimeToText(time),
                              style: const TextStyle(
                                fontSize: 12,
                                color: deepGrayColor,
                              ),
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CardioLabel(),
                          horizontalSpacer(10),
                          CardioMethodLabel(
                            exerciseMethod: exerciseMethod,
                          ),
                          const Expanded(
                            child: SizedBox(
                              height: 0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Text(
                              formatTimeToText(time),
                              style: const TextStyle(
                                fontSize: 12,
                                color: deepGrayColor,
                              ),
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DailyExerciseStatWeightBlock extends StatefulWidget {
  final int index;
  const DailyExerciseStatWeightBlock({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<DailyExerciseStatWeightBlock> createState() =>
      _DailyExerciseStatWeightBlockState();
}

class _DailyExerciseStatWeightBlockState
    extends State<DailyExerciseStatWeightBlock> {
  final controller = StatsController.to;
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: mainBackgroundColor,
        ),
        constraints: const BoxConstraints(
          minHeight: 75,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                opened = !opened;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 22, right: 16),
              child: GetBuilder<StatsController>(builder: (_) {
                Map<String, dynamic> _exerciseData =
                    _.dailyExerciseStatData['records'][widget.index]
                        ['exercise_data'];

                Map<String, dynamic> _recordData =
                    _.dailyExerciseStatData['records'][widget.index];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _exerciseData['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: clearBlackColor,
                                    fontSize: 15,
                                  ),
                                ),
                                Row(
                                  children: [
                                    TargetMuscleLabel(
                                      targetMuscle:
                                          _exerciseData['target_muscle'],
                                    ),
                                    horizontalSpacer(8),
                                    ExerciseMethodLabel(
                                      exerciseMethod:
                                          _exerciseData['exercise_method'],
                                      text: exerciseMethodIntToStr[
                                              _exerciseData[
                                                  'exercise_method']]! +
                                          ' / ' +
                                          _recordData['sets']
                                              .length
                                              .toString() +
                                          '세트',
                                    ),
                                  ],
                                ),
                                Text(
                                  formatTimeToText(
                                      _recordData['exercise_time']),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: deepGrayColor,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AnimatedRotation(
                                  duration: const Duration(milliseconds: 200),
                                  turns: opened ? 1 / 4 : -1 / 4,
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 18,
                                    color: opened
                                        ? brightPrimaryColor
                                        : deepGrayColor,
                                  ),
                                ),
                                _exerciseData['exercise_method'] != 1
                                    ? Text.rich(
                                        TextSpan(
                                          text: '예상 1RM ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: clearBlackColor,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: getCleanTextFromDouble(
                                                      _recordData[
                                                          'max_one_rm']) +
                                                  'kg',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: brightPrimaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text.rich(
                                        TextSpan(
                                          text: '총 반복횟수 ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: clearBlackColor,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: _recordData['total_reps']
                                                      .toString() +
                                                  '회',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: brightPrimaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                _exerciseData['exercise_method'] != 1
                                    ? Text.rich(
                                        TextSpan(
                                          text: '운동 볼륨 ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: clearBlackColor,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: getCleanTextFromDouble(
                                                      _recordData[
                                                          'total_volume']) +
                                                  'kg',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: brightPrimaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : verticalSpacer(15),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: SizedBox(
                        height: opened ? null : 0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Row(
                                children: () {
                                  List<Widget> children = [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '중량',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff8A8AAA),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ];

                                  for (int i = 0;
                                      i < _recordData['sets'].length * 2 - 1;
                                      i++) {
                                    if (i % 2 == 0) {
                                      Map<String, dynamic> setData =
                                          _recordData['sets'][i ~/ 2];
                                      children.add(
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: const Color(0xff8A8AAA),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: SizedBox(
                                            height: 25,
                                            width: 40,
                                            child: Center(
                                              child: Text(
                                                getCleanTextFromDouble(setData[
                                                        'record_weight']) +
                                                    'kg',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      children.add(horizontalSpacer(5));
                                    }
                                  }

                                  return children;
                                }(),
                              ),
                              verticalSpacer(10),
                              Row(
                                children: () {
                                  List<Widget> children = [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '횟수',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff8A8AAA),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ];

                                  for (int i = 0;
                                      i < _recordData['sets'].length * 2 - 1;
                                      i++) {
                                    if (i % 2 == 0) {
                                      Map<String, dynamic> setData =
                                          _recordData['sets'][i ~/ 2];
                                      children.add(
                                        SizedBox(
                                          height: 25,
                                          width: 40,
                                          child: Center(
                                            child: Text(
                                              setData['record_reps'].toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Color(0xff8A8AAA),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      children.add(horizontalSpacer(5));
                                    }
                                  }

                                  return children;
                                }(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class DailyExerciseStatCardioBlock extends StatelessWidget {
  final int index;
  const DailyExerciseStatCardioBlock({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = StatsController.to;
    List<dynamic> radialChartValuesList = [
      [
        '소모 칼로리',
        100,
        darkSecondaryColor,
      ],
      [
        '운동 시간',
        controller.dailyExerciseStatData['records'][index]['target_duration'] !=
                null
            ? (controller.dailyExerciseStatData['records'][index]
                    ['record_duration'] /
                controller.dailyExerciseStatData['records'][index]
                    ['target_duration'] *
                100)
            : 100,
        chestMuscleColor,
      ],
      [
        '주행 거리',
        controller.dailyExerciseStatData['records'][index]['target_distance'] !=
                null
            ? (controller.dailyExerciseStatData['records'][index]
                    ['record_distance'] /
                controller.dailyExerciseStatData['records'][index]
                    ['target_distance'] *
                100)
            : 100,
        cardioColor,
      ],
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: mainBackgroundColor,
      ),
      height: 145,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: SfCircularChart(
              series: <CircularSeries>[
                RadialBarSeries<dynamic, String>(
                  maximumValue: 100,
                  radius: '100%',
                  strokeWidth: 7.5,
                  innerRadius: '40%',
                  cornerStyle: CornerStyle.bothCurve,
                  dataSource: radialChartValuesList,
                  xValueMapper: (dynamic data, _) => data[0],
                  yValueMapper: (dynamic data, _) => data[1],
                  pointColorMapper: (dynamic data, _) => data[2],
                )
              ],
            ),
          ),
          SizedBox(
            width: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    controller.dailyExerciseStatData['records'][index]
                        ['exercise_data']['name'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: clearBlackColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: CardioLabel(
                        fontSize: 12,
                      ),
                    ),
                    CardioMethodLabel(
                      fontSize: 12,
                      exerciseMethod:
                          controller.dailyExerciseStatData['records'][index]
                              ['exercise_data']['exercise_method'],
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(3.5),
                      child: Circle(color: cardioColor, width: 5, height: 5),
                    ),
                    const Text(
                      '주행 거리',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: clearBlackColor,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      getCleanTextFromDouble(
                          controller.dailyExerciseStatData['records'][index]
                              ['record_distance']),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: clearBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.dailyExerciseStatData['records'][index]
                                  ['target_distance'] !=
                              null
                          ? (' / ' +
                              getCleanTextFromDouble(
                                  controller.dailyExerciseStatData['records']
                                      [index]['target_distance']) +
                              'km')
                          : '',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: deepGrayColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(3.5),
                      child: Circle(
                          color: brightSecondaryColor, width: 5, height: 5),
                    ),
                    const Text(
                      '운동 시간',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: clearBlackColor,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      formatTimeToText(
                          controller.dailyExerciseStatData['records'][index]
                              ['record_duration']),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: clearBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.dailyExerciseStatData['records'][index]
                                  ['target_duration'] !=
                              null
                          ? (' / ' +
                              formatTimeToText(
                                controller.dailyExerciseStatData['records']
                                    [index]['target_duration'],
                              ))
                          : '',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: deepGrayColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(3.5),
                      child: Circle(
                        color: darkSecondaryColor,
                        width: 5,
                        height: 5,
                      ),
                    ),
                    const Text(
                      '소모 칼로리',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: clearBlackColor,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      getCleanTextFromDouble(
                              controller.dailyExerciseStatData['records'][index]
                                  ['record_calories']) +
                          ' kcal',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: clearBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
