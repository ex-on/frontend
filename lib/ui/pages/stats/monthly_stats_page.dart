import 'dart:developer';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/calendar.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyStatsPage extends GetView<StatsController> {
  const MonthlyStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onCalendarMonthChanged(DateTime month) {
      controller.getMonthlyStatsMonthlyExerciseDates(month);
      controller.getMonthlyExerciseStats();
    }

    _onMonthlyStatsCategoryButtonPressed(int val) {
      controller.updateMonthlyStatsByWeekCategory(val);
    }

    return ListView(
      children: [
        GetBuilder<StatsController>(
          builder: (_) {
            return Calendar(
              updateSelectedDate: _.updateMonthlyStatsSelectedDate,
              onMonthChanged: _onCalendarMonthChanged,
              exerciseDates: _.monthlyStatsMonthlyExerciseDates,
              selectMode: CalendarSelectMode.monthly,
            );
          },
        ),
        GetBuilder<StatsController>(
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_.monthlyStatsSelectedDate.year}년 ${_.monthlyStatsSelectedDate.month}월',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: clearBlackColor,
                    ),
                  ),
                  const Text(
                    '(전월 대비)',
                    style: TextStyle(
                      fontSize: 10,
                      color: deepGrayColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        GetBuilder<StatsController>(
          builder: (_) {
            if (_.loading) {
              return const Padding(
                padding: EdgeInsets.only(top: 30),
                child: LoadingIndicator(icon: true),
              );
            } else if (_.monthlyExerciseStatData.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  '운동 기록이 없습니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: lightGrayColor,
                  ),
                ),
              );
            } else {
              List<int> hms = splitHMS(
                  _.monthlyExerciseStatData['avg_exercise_time']['current']);

              Widget diffIndicatorBuilder(dynamic val, String unit) {
                String text;
                Color color;
                IconData? icon;
                if (val < 0) {
                  color = softRedColor;
                  icon = Icons.arrow_drop_down;
                  val = -val;
                } else if (val == 0) {
                  color = deepGrayColor;
                  // icon = Icons.remove;
                } else {
                  color = softBlueColor;
                  icon = Icons.arrow_drop_up;
                }

                switch (unit) {
                  case 'day':
                    text = val.toString() + '일';
                    break;
                  case 'time':
                    text = formatTimeToText(val);
                    break;
                  case 'kg':
                    text = getCleanTextFromDouble(val) + 'kg';
                    break;
                  case 'km':
                    text = getCleanTextFromDouble(val) + 'km';
                    break;
                  default:
                    text = '';
                    break;
                }

                return SizedBox(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                        ),
                      ),
                      val == 0
                          ? Text(' -',
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                              ))
                          : Icon(
                              icon,
                              color: color,
                            ),
                    ],
                  ),
                );
              }

              var weeklyList = _.monthlyExerciseStatData['weekly_list'];
              var previousWeeklyList =
                  _.monthlyExerciseStatData['previous_weekly_list'];

              List weeklyData = [];
              weeklyList.asMap().forEach((index, val) {
                weeklyData.add([
                  (index + 1).toString() + '주',
                  weeklyList[index][monthlyStatsCategoryIntToStrEng[
                      _.monthlyStatsByWeekCategory]]
                ]);
              });
              List previousWeeklyData = [];
              previousWeeklyList.asMap().forEach((index, val) {
                previousWeeklyData.add([
                  (index + 1).toString() + '주',
                  previousWeeklyList[index][monthlyStatsCategoryIntToStrEng[
                      _.monthlyStatsByWeekCategory]]
                ]);
              });

              int piChartValuesLength = 0;
              int piChartValuesSum = 0; // Total exercise time
              List<int> targetMuscleList = [];
              List<int> piChartValuesList = []; // Exercise time list

              if (_.monthlyExerciseStatData['category_stats']['weight'] !=
                  null) {
                _.monthlyExerciseStatData['category_stats']['weight']
                    .forEach((key, val) {
                  piChartValuesLength += 1;
                  targetMuscleList.add(int.parse(key));
                  piChartValuesSum += val as int;
                  piChartValuesList.add(val);
                });
              }
              if (_.monthlyExerciseStatData['category_stats']['cardio'] !=
                  null) {
                piChartValuesLength += 1;
                piChartValuesSum += _.monthlyExerciseStatData['category_stats']
                    ['cardio'] as int;
                piChartValuesList.add(
                    _.monthlyExerciseStatData['category_stats']['cardio']
                        as int);
              }

              List<PieChartSectionData> _generatePiChartData() {
                return List.generate(
                  piChartValuesLength,
                  (i) {
                    bool isTouched = i == _.monthlyStatsPiTouchIndex;
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
                    print(targetMuscleIntToStr[targetMuscleList[i]]);
                    print(piChartValuesList[i]);
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
                bool isSelected = index == _.monthlyStatsPiTouchIndex;
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
                              color: targetMuscleIntToColor[
                                  targetMuscleList[index]],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            targetMuscleIntToStr[targetMuscleList[index]]!,
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
                        // getCleanTextFromDouble(piChartValuesList[index] /
                        //         piChartValuesSum *
                        //         100) +
                        //     '%',
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
                        getCleanTextFromDouble(piChartValuesList[index] /
                                piChartValuesSum *
                                100) +
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: SizedBox(
                      height: 70,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              const Text(
                                '운동 일수',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: deepGrayColor,
                                  fontSize: 12,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text.rich(
                                  TextSpan(
                                    text: _.monthlyExerciseStatData[
                                            'exercise_days']['current']
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: darkPrimaryColor,
                                      fontFamily: 'Manrope',
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' 일',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: darkPrimaryColor,
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              diffIndicatorBuilder(
                                _.monthlyExerciseStatData['exercise_days']
                                    ['diff'],
                                'day',
                              ),
                            ],
                          ),
                          const VerticalDivider(
                            color: dividerColor,
                            thickness: 1,
                            width: 30,
                            endIndent: 20,
                          ),
                          Column(
                            children: [
                              const Text(
                                '평균 운동 시간',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: deepGrayColor,
                                  fontSize: 12,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: () {
                                  if (hms[0] == 0) {
                                    return Text.rich(
                                      TextSpan(
                                        text: hms[1].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: darkPrimaryColor,
                                          fontFamily: 'Manrope',
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: '분 ',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: darkPrimaryColor,
                                              fontFamily: 'Manrope',
                                            ),
                                          ),
                                          TextSpan(
                                            text: hms[2].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: darkPrimaryColor,
                                              fontFamily: 'Manrope',
                                            ),
                                          ),
                                          const TextSpan(
                                            text: '초',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: darkPrimaryColor,
                                              fontFamily: 'Manrope',
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Text.rich(
                                      TextSpan(
                                        text: hms[0].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: darkPrimaryColor,
                                          fontFamily: 'Manrope',
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: '시간 ',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: darkPrimaryColor,
                                              fontFamily: 'Manrope',
                                            ),
                                          ),
                                          TextSpan(
                                            text: hms[1].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: darkPrimaryColor,
                                              fontFamily: 'Manrope',
                                            ),
                                          ),
                                          const TextSpan(
                                            text: '분',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: darkPrimaryColor,
                                              fontFamily: 'Manrope',
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }(),
                              ),
                              diffIndicatorBuilder(
                                _.monthlyExerciseStatData['avg_exercise_time']
                                    ['diff'],
                                'time',
                              ),
                            ],
                          ),
                          const VerticalDivider(
                            color: dividerColor,
                            thickness: 1,
                            width: 30,
                            endIndent: 20,
                          ),
                          Column(
                            children: [
                              const Text(
                                '평균 운동 볼륨',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: deepGrayColor,
                                  fontSize: 12,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Text.rich(
                                  TextSpan(
                                    text: getCleanTextFromDouble(
                                        _.monthlyExerciseStatData[
                                            'avg_exercise_volume']['current']),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: darkPrimaryColor,
                                      fontFamily: 'Manrope',
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' kg',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: darkPrimaryColor,
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              diffIndicatorBuilder(
                                _.monthlyExerciseStatData['avg_exercise_volume']
                                    ['diff'],
                                'kg',
                              ),
                            ],
                          ),
                          const VerticalDivider(
                            color: dividerColor,
                            thickness: 1,
                            width: 30,
                            endIndent: 20,
                          ),
                          Column(
                            children: [
                              const Text(
                                '최고 1RM',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: deepGrayColor,
                                  fontSize: 12,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text.rich(
                                  TextSpan(
                                    text: getCleanTextFromDouble(
                                        _.monthlyExerciseStatData['max_one_rm']
                                            ['current']),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: darkPrimaryColor,
                                      fontFamily: 'Manrope',
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' kg',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: darkPrimaryColor,
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              diffIndicatorBuilder(
                                _.monthlyExerciseStatData['max_one_rm']['diff'],
                                'kg',
                              ),
                            ],
                          ),
                          const VerticalDivider(
                            color: dividerColor,
                            thickness: 1,
                            width: 30,
                            endIndent: 20,
                          ),
                          Column(
                            children: [
                              const Text(
                                '총 주행 거리',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: deepGrayColor,
                                  fontSize: 12,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Text.rich(
                                  TextSpan(
                                    text: getCleanTextFromDouble(
                                        _.monthlyExerciseStatData[
                                            'avg_distance']['current']),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: darkPrimaryColor,
                                      fontFamily: 'Manrope',
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' km',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: darkPrimaryColor,
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              diffIndicatorBuilder(
                                _.monthlyExerciseStatData['avg_distance']
                                    ['diff'],
                                'km',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: mainBackgroundColor,
                    thickness: 10,
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 25, 30, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '주별 통계',
                          style: TextStyle(
                            fontSize: statsLabelFontSize,
                            fontWeight: FontWeight.bold,
                            color: clearBlackColor,
                          ),
                        ),
                        Row(
                          children: const [
                            SizedBox(
                              width: 6,
                              height: 6,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: brightPrimaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3, right: 8),
                              child: Text(
                                '이번달',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: clearBlackColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                              height: 6,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: lightGrayColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3),
                              child: Text(
                                '지난달',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: clearBlackColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      height: 30,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        children: List.generate(9, (index) {
                          if (index % 2 == 0) {
                            int idx = index ~/ 2;
                            if (idx == _.monthlyStatsByWeekCategory) {
                              return ElevatedButton(
                                onPressed: () =>
                                    _onMonthlyStatsCategoryButtonPressed(idx),
                                style: ElevatedButton.styleFrom(
                                  primary: selectLabelColor,
                                  minimumSize: Size.zero,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 7, 10, 7),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  monthlyStatsCategoryIntToStr[idx]!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: deepGrayColor,
                                  ),
                                ),
                              );
                            } else {
                              return TextActionButton(
                                height: 23,
                                buttonText: monthlyStatsCategoryIntToStr[idx]!,
                                onPressed: () =>
                                    _onMonthlyStatsCategoryButtonPressed(idx),
                                fontSize: 11,
                                isUnderlined: false,
                                fontWeight: FontWeight.w500,
                                textColor: deepGrayColor,
                                overlayColor: selectLabelColor.withOpacity(0.7),
                              );
                            }
                          } else {
                            return horizontalSpacer(10);
                          }
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 25),
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      trackballBehavior: _.monthlyStatsTrackballBehavior,
                      series: <ChartSeries>[
                        StackedLineSeries<dynamic, String>(
                          dataSource: weeklyData,
                          color: brightPrimaryColor,
                          width: 3,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                          ),
                          xValueMapper: (dynamic data, _) => data[0],
                          yValueMapper: (dynamic data, _) {
                            log(data[1].toString());
                            return data[1];
                          },
                        ),
                        StackedLineSeries<dynamic, String>(
                          dataSource: previousWeeklyData,
                          color: lightGrayColor,
                          width: 3,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                          ),
                          xValueMapper: (dynamic data, _) => data[0],
                          yValueMapper: (dynamic data, _) {
                            log(data[1].toString());
                            return data[1];
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: mainBackgroundColor,
                    thickness: 10,
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 25, 30, 15),
                    child: Text(
                      '운동 부위별 통계',
                      style: TextStyle(
                        fontSize: statsLabelFontSize,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: Text(
                      AuthController.to.userInfo['username'] + '님, ',
                      style: const TextStyle(
                        fontSize: statsLabelFontSize,
                        fontWeight: FontWeight.w500,
                        color: clearBlackColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
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
                                  _.updateMonthlyStatsPiTouchIndex(-1);
                                  return;
                                }
                                _.updateMonthlyStatsPiTouchIndex(
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
                  ),
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                        itemBuilder: _generatePiChartLabel,
                        separatorBuilder: (context, index) =>
                            const VerticalDivider(
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
        ),
      ],
    );
  }
}
