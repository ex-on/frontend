import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/index_indicator.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/stats/exercise_stat_block.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CumulativeStatsExercisePage extends GetView<StatsController> {
  const CumulativeStatsExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _exerciseCategoryStatsLabelText = '운동 부위별 통계';

    Future.delayed(Duration.zero, () {
      if (controller.cumulativeExerciseStatData.isEmpty) {
        controller.getCumulativeExerciseStats();
      }
    });

    void _onExpandExerciseStatsListPressed() {
      Get.toNamed('stats/exercise_list');
    }

    return GetBuilder<StatsController>(
      builder: (_) {
        if (_.loading || _.cumulativeExerciseStatData.isEmpty) {
          return const LoadingIndicator();
        } else {
          int piChartValuesLength = 0;
          int piChartValuesSum = 0; // Total exercise time
          List<int> targetMuscleList = [];
          List<int> piChartValuesList = []; // Exercise time list

          if (_.cumulativeExerciseStatData['category_stats']['weight'] !=
              null) {
            _.cumulativeExerciseStatData['category_stats']['weight']
                .forEach((key, val) {
              piChartValuesLength += 1;
              targetMuscleList.add(int.parse(key));
              piChartValuesSum += val as int;
              piChartValuesList.add(val);
            });
          }
          if (_.cumulativeExerciseStatData['category_stats']['cardio'] > 0) {
            piChartValuesLength += 1;
            piChartValuesSum +=
                _.cumulativeExerciseStatData['category_stats']['cardio'] as int;
            piChartValuesList.add(_.cumulativeExerciseStatData['category_stats']
                ['cardio'] as int);
          }
          List<PieChartSectionData> _generatePiChartData() {
            return List.generate(
              piChartValuesLength,
              (i) {
                bool isTouched = i == _.cumulativeExerciseStatsPiTouchIndex;
                double fontSize = isTouched
                    ? (20 +
                        (piChartValuesList[i].toDouble() /
                            piChartValuesSum *
                            45))
                    : (15 +
                        (piChartValuesList[i].toDouble() /
                            piChartValuesSum *
                            45));
                double radius = isTouched ? 120.0 : 110.0;
                if (piChartValuesLength != targetMuscleList.length &&
                    i == piChartValuesLength - 1) {
                  return PieChartSectionData(
                    color: cardioColor,
                    value: piChartValuesList[i].toDouble(),
                    title: '유산소',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff),
                    ),
                  );
                }
                return PieChartSectionData(
                  color: targetMuscleIntToColor[targetMuscleList[i]],
                  value: piChartValuesList[i].toDouble(),
                  title: targetMuscleIntToStr[targetMuscleList[i]],
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffffffff),
                  ),
                );
              },
            );
          }

          _generatePiChartLabel(context, index) {
            bool isSelected = index == _.cumulativeExerciseStatsPiTouchIndex;
            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: isSelected ? 12 : 9,
                      height: isSelected ? 12 : 9,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == targetMuscleList.length
                              ? cardioColor
                              : targetMuscleIntToColor[targetMuscleList[index]],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        index == targetMuscleList.length
                            ? '유산소'
                            : targetMuscleIntToStr[targetMuscleList[index]]!,
                        style: TextStyle(
                          fontSize: isSelected ? 15 : 12,
                          color: clearBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    formatMMSS(piChartValuesList[index]),
                    style: TextStyle(
                      color: clearBlackColor,
                      fontSize: isSelected ? 25 : 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    getCleanTextFromDouble(
                            piChartValuesList[index] / piChartValuesSum * 100) +
                        '%',
                    style: TextStyle(
                      color: deepGrayColor,
                      fontSize: isSelected ? 15 : 12,
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '제일 많이 한 운동',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: statsLabelFontSize,
                      ),
                    ),
                    () {
                      if (_.cumulativeExerciseStatData['exercise_stats']
                              .length >
                          3) {
                        return TextActionButton(
                          buttonText: '전체보기',
                          onPressed: _onExpandExerciseStatsListPressed,
                          textColor: deepGrayColor,
                          fontSize: 13,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }(),
                  ],
                ),
              ),
              SizedBox(
                height: 260,
                child: NotificationListener(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return true;
                  },
                  child: PageView.builder(
                    itemCount:
                        _.cumulativeExerciseStatData['exercise_stats'].length,
                    onPageChanged:
                        controller.updateCurrentCumulativeExerciseIndex,
                    itemBuilder: (context, page) {
                      int lastPageItemNum =
                          (_.cumulativeExerciseStatData['exercise_stats']
                                          .length %
                                      3 ==
                                  0)
                              ? 3
                              : (_.cumulativeExerciseStatData['exercise_stats']
                                      .length %
                                  3);
                      List<Widget> children = List.generate(
                        (_.cumulativeExerciseStatData['exercise_stats'].length /
                                            3)
                                        .ceil() -
                                    1 ==
                                page
                            ? lastPageItemNum
                            : 3,
                        (index) => ExerciseStatBlock(
                          exerciseId:
                              _.cumulativeExerciseStatData['exercise_stats']
                                  [page * 3 + index]['exercise']['id'],
                          exerciseName:
                              _.cumulativeExerciseStatData['exercise_stats']
                                  [page * 3 + index]['exercise']['name'],
                          targetMuscle: _
                                  .cumulativeExerciseStatData['exercise_stats']
                              [page * 3 + index]['exercise']['target_muscle'],
                          exerciseMethod: _
                                  .cumulativeExerciseStatData['exercise_stats']
                              [page * 3 + index]['exercise']['exercise_method'],
                          count: _.cumulativeExerciseStatData['exercise_stats']
                              [page * 3 + index]['count'],
                          time: _.cumulativeExerciseStatData['exercise_stats']
                              [page * 3 + index]['time'],
                        ),
                      );
                      return Column(
                        children: children,
                      );
                    },
                  ),
                ),
              ),
              GetBuilder<StatsController>(
                builder: (_) {
                  return IndexIndicator(
                      currentIndex: _.currentCumulativeExerciseIndex,
                      totalLength: (_
                                  .cumulativeExerciseStatData['exercise_stats']
                                  .length /
                              3)
                          .ceil());
                },
              ),
              verticalSpacer(50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: const [
                    Text(
                      _exerciseCategoryStatsLabelText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: statsLabelFontSize,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                child: Text(
                  AuthController.to.userInfo['username'] +
                      '님, ' +
                      _.cumulativeExerciseStatData['category_stats']['copy'],
                  style: const TextStyle(
                    fontSize: statsLabelFontSize,
                    fontWeight: FontWeight.w500,
                    color: clearBlackColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _.updateCumulativeExerciseStatsPiTouchIndex(-1);
                            return;
                          }
                          _.updateCumulativeExerciseStatsPiTouchIndex(
                              pieTouchResponse
                                  .touchedSection!.touchedSectionIndex);
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: _generatePiChartData(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                    itemBuilder: _generatePiChartLabel,
                    separatorBuilder: (context, index) => const VerticalDivider(
                      color: dividerColor,
                      width: 30,
                      thickness: 1,
                      endIndent: 30,
                    ),
                    itemCount: piChartValuesList.length,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
