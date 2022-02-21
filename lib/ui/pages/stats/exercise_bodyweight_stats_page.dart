import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/circle.dart';
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

class ExerciseBodyweightStatsPage extends GetView<StatsController> {
  const ExerciseBodyweightStatsPage({Key? key}) : super(key: key);

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
      body: GetBuilder<StatsController>(
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
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 20),
                      child: TargetMuscleLabel(
                        fontSize: 18,
                        targetMuscle: _.selectedExerciseInfo['target_muscle'],
                      ),
                    ),
                    ExerciseMethodLabel(
                      fontSize: 18,
                      exerciseMethod: _.selectedExerciseInfo['exercise_method'],
                    ),
                  ],
                ),
              ),
              () {
                return Expanded(
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

                          if (_.exerciseBodyweightStatsCategory == 0) {
                            _.exerciseStatData['max_reps_stat']
                                .forEach((date, reps) {
                              _chartData.add([DateTime.parse(date), reps]);
                            });
                          } else {
                            _.exerciseStatData['total_reps_stat']
                                .forEach((date, reps) {
                              _chartData.add([DateTime.parse(date), reps]);
                            });
                          }
                          return [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text.rich(
                                TextSpan(
                                    text: '한 세트 최고 기록은 ',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: clearBlackColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: _.exerciseStatData['best_set']
                                                    ['reps']
                                                .toString() +
                                            '회',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: brightPrimaryColor,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '에요',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: clearBlackColor,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
                              child: Text.rich(
                                TextSpan(
                                  text: DateFormat('yyyy년 MM월 dd일(E)', 'ko-KR')
                                      .format(DateTime.parse(
                                          _.exerciseStatData['best_set']
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
                              child: Row(
                                children: () {
                                  List _recordData =
                                      _.exerciseStatData['best_set']
                                          ['record_data'];

                                  List<Widget> _children = [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Text(
                                        '횟수',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: lightDarkSecondaryColor,
                                        ),
                                      ),
                                    ),
                                  ];

                                  _recordData.asMap().forEach((i, val) {
                                    _children.add(
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Column(
                                          children: [
                                            Circle(
                                              color: val ==
                                                      _.exerciseStatData[
                                                          'best_set']['reps']
                                                  ? brightPrimaryColor
                                                      .withOpacity(0.2)
                                                  : Colors.transparent,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  val.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: clearBlackColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              (i + 1).toString() + '세트',
                                              style: const TextStyle(
                                                height: 1.5,
                                                color: lightDarkSecondaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });

                                  return _children;
                                }(),
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
                              child: Text.rich(
                                TextSpan(
                                    text: '한 세션 최고 기록은 ',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: clearBlackColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: _.exerciseStatData['best_session']
                                                    ['total_reps']
                                                .toString() +
                                            '회',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: brightPrimaryColor,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '에요',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: clearBlackColor,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                              child: Text.rich(
                                TextSpan(
                                  text: DateFormat('yyyy년 MM월 dd일(E)', 'ko-KR')
                                      .format(DateTime.parse(
                                          _.exerciseStatData['best_session']
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
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text(
                                      '횟수',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: lightDarkSecondaryColor,
                                      ),
                                    ),
                                  ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          brightPrimaryColor.withOpacity(0.2),
                                    ),
                                    child: Row(
                                      children: () {
                                        List _recordData =
                                            _.exerciseStatData['best_set']
                                                ['record_data'];

                                        List<Widget> _children = [];

                                        _recordData.asMap().forEach(
                                          (i, val) {
                                            _children.add(
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    val.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: clearBlackColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                        return _children;
                                      }(),
                                    ),
                                  ),
                                ],
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
                                      buttonText: '1세트 최대',
                                      onPressed: () => _
                                          .updateExerciseBodyweightStatsCategory(
                                              0),
                                      isUnderlined: false,
                                      fontSize: 15,
                                      textColor:
                                          _.exerciseBodyweightStatsCategory == 0
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
                                      buttonText: '총 수행횟수',
                                      onPressed: () => _
                                          .updateExerciseBodyweightStatsCategory(
                                              1),
                                      isUnderlined: false,
                                      fontSize: 15,
                                      textColor:
                                          _.exerciseBodyweightStatsCategory == 1
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
                                  title: AxisTitle(
                                    text: '(회)',
                                    textStyle: const TextStyle(
                                      fontSize: 10,
                                      color: deepGrayColor,
                                    ),
                                    alignment: ChartAlignment.far,
                                  ),
                                  axisLabelFormatter:
                                      (AxisLabelRenderDetails args) {
                                    return ChartAxisLabel(
                                      args.value % 1 == 0 ? args.text : '',
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
                                    _.exerciseBodyweightStatsTrackballBehavior,
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
                                      width: 10,
                                      height: 10,
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
                              height: 140,
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
                                      .updateExerciseBodyweightCurrentRecordsIndex,
                                  itemBuilder: (context, page) {
                                    Map<String, dynamic> _data =
                                        _.exerciseStatData['current_records']
                                            [page];
                                    return Container(
                                      width: 340,
                                      margin: const EdgeInsets.fromLTRB(
                                          30, 20, 30, 5),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                        vertical: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: mainBackgroundColor,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                DateFormat('yyyy. MM. dd')
                                                    .format(
                                                  DateTime.parse(_data['date']),
                                                ),
                                                style: const TextStyle(
                                                  letterSpacing: -1,
                                                  fontSize: 20,
                                                  color: clearBlackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Expanded(child: SizedBox()),
                                              const Text(
                                                '총 수행횟수',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: deepGrayColor,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  _data['total_reps']
                                                          .toString() +
                                                      '회',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: brightPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          verticalSpacer(3),
                                          Row(
                                            children: [
                                              Text(
                                                _data['total_sets'].toString() +
                                                    '세트 | ',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: clearBlackColor,
                                                ),
                                              ),
                                              Text(
                                                formatTimeToText(
                                                    _data['exercise_time']),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: clearBlackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          verticalSpacer(10),
                                          Row(
                                            children: () {
                                              List<Widget> _children = [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    '횟수',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          lightDarkSecondaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ];

                                              for (int reps in _data['sets']) {
                                                _children.add(
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      reps.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            lightDarkSecondaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              return _children;
                                            }(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            IndexIndicator(
                              currentIndex:
                                  _.exerciseBodyweightCurrentRecordsIndex,
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
                );
              }(),
            ],
          );
        },
      ),
    );
  }
}
