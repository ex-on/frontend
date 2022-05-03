import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:exon_app/ui/widgets/common/index_indicator.dart';

class ExerciseCardioStatsPage extends GetView<StatsController> {
  const ExerciseCardioStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.exerciseStatData.isEmpty) {
        controller.exerciseStatsRefreshController.requestRefresh();
      }
    });

    void _onBackPressed() {
      controller.cumulativeExercisePageController
          .jumpToPage(controller.currentCumulativeExerciseIndex);
      Get.back();
      controller.resetExerciseStats();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Header(
          onPressed: _onBackPressed,
        ),
      ),
      body: SafeArea(
        child: GetBuilder<StatsController>(
          builder: (_) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 26, bottom: 30),
                  child: Row(
                    children: [
                      Text(
                        _.selectedExerciseInfo['name'],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: clearBlackColor,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 30, right: 20),
                        child: CardioLabel(
                          fontSize: 18,
                        ),
                      ),
                      CardioMethodLabel(
                        fontSize: 18,
                        exerciseMethod:
                            _.selectedExerciseInfo['exercise_method'],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.exerciseStatsRefreshController,
                    onRefresh: controller.onExerciseStatsRefresh,
                    header: CustomHeader(
                      height: 80,
                      builder: (context, mode) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: LoadingIndicator(icon: true),
                        );
                      },
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 10),
                      children: () {
                        if (_.exerciseStatData.isEmpty) {
                          return const [
                            Center(
                              child: Text(
                                '최근 운동 기록을 불러오는 중입니다...',
                                style: TextStyle(
                                  color: deepGrayColor,
                                ),
                              ),
                            )
                          ];
                        } else {
                          List _chartData = [];

                          if (_.exerciseCardioStatsCategory == 0) {
                            _.exerciseStatData['record_distance_stat']
                                .forEach((date, reps) {
                              _chartData.add([DateTime.parse(date), reps]);
                            });
                          } else if (_.exerciseCardioStatsCategory == 1) {
                            _.exerciseStatData['record_duration_stat']
                                .forEach((date, reps) {
                              _chartData.add([DateTime.parse(date), reps]);
                            });
                          } else {
                            _.exerciseStatData['record_calories_stat']
                                .forEach((date, reps) {
                              _chartData.add([DateTime.parse(date), reps]);
                            });
                          }

                          List<dynamic> _radialChartValuesList = [];

                          _.exerciseStatData['current_records'].asMap().forEach(
                            (index, data) {
                              _radialChartValuesList.add(
                                [
                                  [
                                    '소모 칼로리',
                                    100,
                                    darkSecondaryColor,
                                  ],
                                  [
                                    '운동 시간',
                                    data['target_duration'] != null
                                        ? (data['record_duration'] /
                                            data['target_duration'] *
                                            100)
                                        : 100,
                                    chestMuscleColor,
                                  ],
                                  [
                                    '주행 거리',
                                    data['target_distance'] != null
                                        ? (data['record_distance'] /
                                            data['target_distance'] *
                                            100)
                                        : 100,
                                    cardioColor,
                                  ],
                                ],
                              );
                            },
                          );

                          return [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                '소모 칼로리 최고기록',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: clearBlackColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
                              child: Text.rich(
                                TextSpan(
                                  text: DateFormat('yyyy년 MM월 dd일(E)', 'ko-KR')
                                      .format(DateTime.parse(
                                          _.exerciseStatData['max_calories']
                                              ['date'])),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: clearBlackColor,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: ' 운동 기록',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: deepGrayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 3),
                                          child: Text(
                                            '주행 거리',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          getCleanTextFromDouble(
                                                  _.exerciseStatData[
                                                          'max_calories']
                                                      ['record_distance']) +
                                              'km',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: cardioColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      color: lightGrayColor,
                                      width: 40,
                                      thickness: 1,
                                    ),
                                    Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 3),
                                          child: Text(
                                            '운동 시간',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          formatTimeToText(
                                              _.exerciseStatData['max_calories']
                                                  ['record_duration']),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: brightSecondaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      color: lightGrayColor,
                                      width: 40,
                                      thickness: 1,
                                    ),
                                    Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 3),
                                          child: Text(
                                            '소모 칼로리',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          getCleanTextFromDouble(
                                                  _.exerciseStatData[
                                                          'max_calories']
                                                      ['record_calories']) +
                                              'kcal',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: darkSecondaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 13,
                              height: 63,
                              color: mainBackgroundColor,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '통계',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: clearBlackColor,
                                      ),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    TextActionButton(
                                      buttonText: '주행 거리',
                                      onPressed: () => _
                                          .updateExerciseCardioStatsCategory(0),
                                      isUnderlined: false,
                                      fontSize: 15,
                                      textColor:
                                          _.exerciseCardioStatsCategory == 0
                                              ? brightPrimaryColor
                                              : deepGrayColor,
                                    ),
                                    const VerticalDivider(
                                      color: dividerColor,
                                      width: 7,
                                      thickness: 1,
                                      indent: 8,
                                      endIndent: 8,
                                    ),
                                    TextActionButton(
                                      buttonText: '운동 시간',
                                      onPressed: () => _
                                          .updateExerciseCardioStatsCategory(1),
                                      isUnderlined: false,
                                      fontSize: 15,
                                      textColor:
                                          _.exerciseCardioStatsCategory == 1
                                              ? brightPrimaryColor
                                              : deepGrayColor,
                                    ),
                                    const VerticalDivider(
                                      color: dividerColor,
                                      width: 7,
                                      thickness: 1,
                                      indent: 8,
                                      endIndent: 8,
                                    ),
                                    TextActionButton(
                                      buttonText: '소모 칼로리',
                                      onPressed: () => _
                                          .updateExerciseCardioStatsCategory(2),
                                      isUnderlined: false,
                                      fontSize: 15,
                                      textColor:
                                          _.exerciseCardioStatsCategory == 2
                                              ? brightPrimaryColor
                                              : deepGrayColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 30, 10),
                              child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  rangePadding: ChartRangePadding.additional,
                                  maximumLabels: 1,
                                  axisLabelFormatter:
                                      (AxisLabelRenderDetails args) {
                                    late String label;
                                    DateTime date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            args.value as int);
                                    if (date.year != DateTime.now().year) {
                                      label = DateFormat('yyyy년 MM월 dd일')
                                          .format(date);
                                    } else {
                                      label =
                                          DateFormat('MM월 dd일').format(date);
                                    }
                                    return ChartAxisLabel(
                                      label,
                                      const TextStyle(
                                        fontSize: 12,
                                        color: deepGrayColor,
                                      ),
                                    );
                                  },
                                  interval: 1,
                                  dateFormat: DateFormat('yyyy년 MM월 dd일'),
                                  intervalType: DateTimeIntervalType.months,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  majorTickLines: const MajorTickLines(size: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                  title: () {
                                    late String _title;
                                    switch (_.exerciseCardioStatsCategory) {
                                      case 1:
                                        _title = '(시간)';
                                        break;
                                      case 2:
                                        _title = '(kcal)';
                                        break;
                                      default:
                                        _title = '(km)';
                                        break;
                                    }

                                    return AxisTitle(
                                      text: _title,
                                      textStyle: const TextStyle(
                                        fontSize: 10,
                                        color: deepGrayColor,
                                      ),
                                      alignment: ChartAlignment.far,
                                    );
                                  }(),
                                  axisLabelFormatter:
                                      (AxisLabelRenderDetails args) {
                                    return ChartAxisLabel(
                                      _.exerciseCardioStatsCategory != 1
                                          ? args.text
                                          : (args.value % 60 == 0
                                              ? formatTimeToText(
                                                  args.value as int)
                                              : ''),
                                      const TextStyle(
                                        fontSize: 12,
                                        color: deepGrayColor,
                                      ),
                                    );
                                  },
                                  majorGridLines: const MajorGridLines(
                                    width: 1,
                                  ),
                                  majorTickLines: const MajorTickLines(size: 0),
                                  axisLine: const AxisLine(width: 0),
                                ),
                                plotAreaBorderWidth: 0,
                                trackballBehavior:
                                    _.exerciseCardioStatsTrackballBehavior,
                                series: <ChartSeries>[
                                  AreaSeries<dynamic, DateTime>(
                                    dataSource: _chartData,
                                    color: brightPrimaryColor,
                                    borderWidth: 3,
                                    borderColor: brightPrimaryColor,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        brightPrimaryColor.withOpacity(0.4),
                                        brightPrimaryColor.withOpacity(0)
                                      ],
                                    ),
                                    markerSettings: const MarkerSettings(
                                      isVisible: true,
                                      borderColor: brightPrimaryColor,
                                      height: 10,
                                      width: 10,
                                    ),
                                    xValueMapper: (dynamic data, _) => data[0],
                                    yValueMapper: (dynamic data, _) {
                                      return data[1];
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 13,
                              height: 63,
                              color: mainBackgroundColor,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                '운동 기록',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: clearBlackColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 400,
                              child: NotificationListener(
                                onNotification: (OverscrollIndicatorNotification
                                    overscroll) {
                                  overscroll.disallowGlow();
                                  return true;
                                },
                                child: PageView.builder(
                                  itemCount: _
                                      .exerciseStatData['current_records']
                                      .length,
                                  onPageChanged: controller
                                      .updateExerciseCardioCurrentRecordsIndex,
                                  itemBuilder: (context, page) {
                                    Map<String, dynamic> _data =
                                        _.exerciseStatData['current_records']
                                            [page];
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 10, 30, 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                DateFormat('yyyy년 MM월 dd일(E)',
                                                        'ko-KR')
                                                    .format(DateTime.parse(
                                                        _data['date'])),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: clearBlackColor,
                                                ),
                                              ),
                                              const Text(
                                                ' 운동 기록입니다.',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: deepGrayColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: SizedBox(
                                              width: 250,
                                              height: 250,
                                              child: SfCircularChart(
                                                series: <CircularSeries>[
                                                  RadialBarSeries<dynamic,
                                                      String>(
                                                    maximumValue: 100,
                                                    radius: '100%',
                                                    strokeWidth: 7.5,
                                                    innerRadius: '40%',
                                                    cornerStyle:
                                                        CornerStyle.bothCurve,
                                                    dataSource:
                                                        _radialChartValuesList[
                                                            page],
                                                    xValueMapper:
                                                        (dynamic data, _) =>
                                                            data[0],
                                                    yValueMapper:
                                                        (dynamic data, _) =>
                                                            data[1],
                                                    pointColorMapper:
                                                        (dynamic data, _) =>
                                                            data[2],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 3),
                                                      child: Text(
                                                        '주행 거리',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      getCleanTextFromDouble(
                                                              _.exerciseStatData[
                                                                          'current_records']
                                                                      [page][
                                                                  'record_distance']) +
                                                          'km',
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: cardioColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const VerticalDivider(
                                                  color: lightGrayColor,
                                                  width: 40,
                                                  thickness: 1,
                                                ),
                                                Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 3),
                                                      child: Text(
                                                        '운동 시간',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      formatTimeToText(_
                                                                  .exerciseStatData[
                                                              'current_records']
                                                          [
                                                          page]['record_duration']),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            brightSecondaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const VerticalDivider(
                                                  color: lightGrayColor,
                                                  width: 40,
                                                  thickness: 1,
                                                ),
                                                Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 3),
                                                      child: Text(
                                                        '소모 칼로리',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      getCleanTextFromDouble(
                                                              _.exerciseStatData[
                                                                          'current_records']
                                                                      [page][
                                                                  'record_calories']) +
                                                          'kcal',
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            darkSecondaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  },
                                ),
                              ),
                            ),
                            IndexIndicator(
                              currentIndex: _.exerciseCardioCurrentRecordsIndex,
                              totalLength:
                                  _.exerciseStatData['current_records'].length,
                              color: darkSecondaryColor,
                            ),
                            verticalSpacer(30),
                          ];
                        }
                      }(),
                    ),
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
