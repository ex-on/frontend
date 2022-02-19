import 'dart:math';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyExerciseStatBlock extends StatefulWidget {
  final int index;
  const DailyExerciseStatBlock({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<DailyExerciseStatBlock> createState() => _DailyExerciseStatBlockState();
}

class _DailyExerciseStatBlockState extends State<DailyExerciseStatBlock> {
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
                      height: 51,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  _exerciseData['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: clearBlackColor,
                                    fontSize: 14,
                                  ),
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
                                            _exerciseData['exercise_method']]! +
                                        ' / ' +
                                        _recordData['total_sets'].toString() +
                                        '세트',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text.rich(
                                      TextSpan(
                                        text: '예상 1RM ',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: deepGrayColor,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: getCleanTextFromDouble(
                                                    _recordData['max_one_rm']) +
                                                'kg',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: brightPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                              Padding(
                                padding: const EdgeInsets.only(top: 3, left: 8),
                                child: AnimatedRotation(
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
                              ),
                            ],
                          ),
                        ],
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
