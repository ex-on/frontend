import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/bubble_tooltips.dart';
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

class ExerciseWeightStatsPage extends GetView<StatsController> {
  const ExerciseWeightStatsPage({Key? key}) : super(key: key);

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
      
                            if (_.exerciseWeightStatsCategory == 0) {
                              _.exerciseStatData['max_one_rm_stat']
                                  .forEach((date, oneRm) {
                                _chartData.add([DateTime.parse(date), oneRm]);
                              });
                            } else {
                              _.exerciseStatData['total_volume_stat']
                                  .forEach((date, volume) {
                                _chartData.add([DateTime.parse(date), volume]);
                              });
                            }
      
                            return [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  '최고 1RM',
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
                                            _.exerciseStatData['best_one_rm']
                                                ['date'])),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: clearBlackColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' 운동의 ' +
                                            _.exerciseStatData['best_one_rm']
                                                    ['set_num']
                                                .toString() +
                                            '번째 세트 기록입니다.',
                                        style: const TextStyle(
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
                                              '예상 1RM',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            getCleanTextFromDouble(_
                                                        .exerciseStatData[
                                                    'best_one_rm']['one_rm']) +
                                                'kg',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: chestMuscleColor,
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
                                              '중량',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            getCleanTextFromDouble(
                                                    _.exerciseStatData[
                                                            'best_one_rm']
                                                        ['record_weight']) +
                                                'kg',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: darkSecondaryColor,
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
                                              '반복 횟수',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _.exerciseStatData['best_one_rm']
                                                        ['record_reps']
                                                    .toString() +
                                                '회',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: brightPrimaryColor,
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
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  '최고 운동 볼륨',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: clearBlackColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                                child: Text.rich(
                                  TextSpan(
                                    text: DateFormat('yyyy년 MM월 dd일(E)', 'ko-KR')
                                        .format(DateTime.parse(
                                            _.exerciseStatData['best_volume']
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
                                padding: const EdgeInsets.only(left: 30),
                                child: Row(
                                  children: [
                                    const Text(
                                      '운동 볼륨 합산 | ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: lightDarkSecondaryColor,
                                      ),
                                    ),
                                    Text(
                                      getCleanTextFromDouble(
                                              _.exerciseStatData['best_volume']
                                                  ['total_volume']) +
                                          'kg',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: brightPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                                child: SizedBox(
                                  width: context.width - 60,
                                  height: 60,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Padding(
                                              padding:
                                                  EdgeInsets.fromLTRB(0, 5, 5, 5),
                                              child: Text(
                                                '중량',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: lightDarkSecondaryColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.fromLTRB(0, 5, 5, 5),
                                              child: Text(
                                                '횟수',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: lightDarkSecondaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: () {
                                            List _setData =
                                                _.exerciseStatData['best_volume']
                                                    ['sets'];
      
                                            List<Widget> _children = [];
      
                                            _setData.asMap().forEach(
                                              (i, data) {
                                                _children.add(
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(horizontal: 5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(5),
                                                            color:
                                                                brightPrimaryColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Text(
                                                              getCleanTextFromDouble(
                                                                      data[
                                                                          'record_weight']) +
                                                                  'kg',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Text(
                                                            data['record_reps']
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.5,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color:
                                                                  lightDarkSecondaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                                        buttonText: '1RM',
                                        onPressed: () => _
                                            .updateExerciseWeightStatsCategory(0),
                                        isUnderlined: false,
                                        fontSize: 15,
                                        textColor:
                                            _.exerciseWeightStatsCategory == 0
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
                                        buttonText: '운동볼륨',
                                        onPressed: () => _
                                            .updateExerciseWeightStatsCategory(1),
                                        isUnderlined: false,
                                        fontSize: 15,
                                        textColor:
                                            _.exerciseWeightStatsCategory == 1
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
                                    rangePadding: ChartRangePadding.round,
                                    maximumLabels: 1,
                                    intervalType: DateTimeIntervalType.months,
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
                                    // intervalType: DateTimeIntervalType.months,
                                    majorGridLines:
                                        const MajorGridLines(width: 0),
                                    majorTickLines: const MajorTickLines(size: 0),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    title: AxisTitle(
                                      text: '(kg)',
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
                                      _.exerciseWeightStatsTrackballBehavior,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      '운동 기록',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: clearBlackColor,
                                      ),
                                    ),
                                    TooltipHelpIconButton(
                                      arrowPosition: 0.86,
                                      message: '운동 기록이 최대 5개까지만 표시됩니다',
                                      backgroundColor: mainBackgroundColor,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200,
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
                                        .updateExerciseWeightCurrentRecordsIndex,
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
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        DateFormat('yyyy. MM. dd')
                                                            .format(
                                                          DateTime.parse(
                                                              _data['date']),
                                                        ),
                                                        style: const TextStyle(
                                                          letterSpacing: -1,
                                                          fontSize: 20,
                                                          color: clearBlackColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            _data['total_sets']
                                                                    .toString() +
                                                                '세트',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color:
                                                                  clearBlackColor,
                                                            ),
                                                          ),
                                                          const Text(
                                                            ' | ',
                                                            style: TextStyle(
                                                              color:
                                                                  lightDarkSecondaryColor,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          Text(
                                                            formatTimeToText(_data[
                                                                'exercise_time']),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color:
                                                                  clearBlackColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const Expanded(
                                                      child: SizedBox()),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            '최대 1RM',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  deepGrayColor,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              getCleanTextFromDouble(
                                                                      _data[
                                                                          'max_one_rm']) +
                                                                  'kg',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    brightPrimaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            '운동 볼륨',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  deepGrayColor,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              getCleanTextFromDouble(
                                                                      _data[
                                                                          'total_volume']) +
                                                                  'kg',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    brightPrimaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            verticalSpacer(20),
                                            SizedBox(
                                              height: 60,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: const [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.fromLTRB(
                                                                  0, 5, 5, 5),
                                                          child: Text(
                                                            '중량',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  lightDarkSecondaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.fromLTRB(
                                                                  0, 5, 5, 5),
                                                          child: Text(
                                                            '횟수',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  lightDarkSecondaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: () {
                                                        List<Widget> _children =
                                                            [];
      
                                                        _data['sets']
                                                            .asMap()
                                                            .forEach(
                                                          (i, data) {
                                                            _children.add(
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    DecoratedBox(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        color:
                                                                            lightDarkSecondaryColor,
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          getCleanTextFromDouble(data['record_weight']) +
                                                                              'kg',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14.5,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(5),
                                                                      child: Text(
                                                                        data['record_reps']
                                                                            .toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              14.5,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              lightDarkSecondaryColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
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
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              IndexIndicator(
                                currentIndex: _.exerciseWeightCurrentRecordsIndex,
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
      ),
    );
  }
}
