import 'dart:math';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WeeklyStatsPage extends GetView<StatsController> {
  const WeeklyStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return SafeArea(
          child: SmartRefresher(
            controller: controller.weeklyStatsRefreshController,
            onRefresh: controller.onWeeklyStatsRefresh,
            header: const MaterialClassicHeader(
              color: brightPrimaryColor,
              distance: 100,
            ),
            child: CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: GetBuilder<StatsController>(
                    builder: (_) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 20, right: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_.selectedDate.month}월 ${_.selectedDate.weekOfMonth}주차 (${_.selectedDate.firstDateOfWeek.day}일 ~ ${_.selectedDate.lastDateOfWeek.day}일)',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: clearBlackColor,
                              ),
                            ),
                            const Text(
                              '(전주 대비)',
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
                ),
                SliverToBoxAdapter(
                  child: GetBuilder<StatsController>(
                    builder: (_) {
                      if (_.loading) {
                        return const SizedBox();
                      } else if (_.weeklyExerciseStatData.isEmpty) {
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
                            _.weeklyExerciseStatData['avg_exercise_time']
                                ['current']);
                        BarChartGroupData makeGroupData(
                          int x,
                          double y, {
                          bool isTouched = false,
                          // Color barColor = Colors.white,
                          double width = 15,
                          List<int> showTooltips = const [],
                        }) {
                          return BarChartGroupData(
                            x: x,
                            barRods: [
                              BarChartRodData(
                                y: isTouched ? y + 1 : y,
                                colors: isTouched
                                    ? [brightPrimaryColor]
                                    : [lightBrightPrimaryColor],
                                width: width,
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  y: 20,
                                  colors: [const Color(0xffEAE9EF)],
                                ),
                              ),
                            ],
                            showingTooltipIndicators: showTooltips,
                          );
                        }

                        int _largerExerciseTime = max(
                            _.weeklyExerciseStatData[
                                'total_exercise_time_compared'][0],
                            _.weeklyExerciseStatData[
                                'total_exercise_time_compared'][1]);

                        int _exerciseTimeDiff = _.weeklyExerciseStatData[
                                'total_exercise_time_compared'][1] -
                            _.weeklyExerciseStatData[
                                'total_exercise_time_compared'][0];

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

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
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
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Text.rich(
                                            TextSpan(
                                              text: _.weeklyExerciseStatData[
                                                      'exercise_days']
                                                      ['current']
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: darkPrimaryColor,
                                                    fontFamily: 'Manrope',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        diffIndicatorBuilder(
                                          _.weeklyExerciseStatData[
                                              'exercise_days']['diff'],
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
                                          padding:
                                              const EdgeInsets.only(top: 3),
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
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: darkPrimaryColor,
                                                        fontFamily: 'Manrope',
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: hms[2].toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: darkPrimaryColor,
                                                        fontFamily: 'Manrope',
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                      text: '초',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: darkPrimaryColor,
                                                        fontFamily: 'Manrope',
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: hms[1].toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: darkPrimaryColor,
                                                        fontFamily: 'Manrope',
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                      text: '분',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                          _.weeklyExerciseStatData[
                                              'avg_exercise_time']['diff'],
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
                                                  _.weeklyExerciseStatData[
                                                          'avg_exercise_volume']
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: darkPrimaryColor,
                                                    fontFamily: 'Manrope',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        diffIndicatorBuilder(
                                          _.weeklyExerciseStatData[
                                              'avg_exercise_volume']['diff'],
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
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Text.rich(
                                            TextSpan(
                                              text: getCleanTextFromDouble(
                                                  _.weeklyExerciseStatData[
                                                      'max_one_rm']['current']),
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: darkPrimaryColor,
                                                    fontFamily: 'Manrope',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        diffIndicatorBuilder(
                                          _.weeklyExerciseStatData['max_one_rm']
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
                                              text: getCleanTextFromDouble(_
                                                      .weeklyExerciseStatData[
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
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: darkPrimaryColor,
                                                    fontFamily: 'Manrope',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        diffIndicatorBuilder(
                                          _.weeklyExerciseStatData[
                                              'avg_distance']['diff'],
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
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 25),
                              child: Text(
                                '요일별 운동시간',
                                style: TextStyle(
                                  fontSize: statsLabelFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: clearBlackColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
                              child: SizedBox(
                                height: 200,
                                width: context.width - 60,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: mainBackgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: BarChart(
                                      BarChartData(
                                        barTouchData: BarTouchData(
                                          touchTooltipData: BarTouchTooltipData(
                                              tooltipPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              tooltipBgColor:
                                                  const Color(0xff7C8C97),
                                              getTooltipItem: (group,
                                                  groupIndex, rod, rodIndex) {
                                                DateTime indexDate = _
                                                    .selectedDate
                                                    .firstDateOfWeek
                                                    .add(Duration(
                                                        days: group.x.toInt()));
                                                String weekDay =
                                                    weekdayIntToStr[
                                                        group.x.toInt() + 1]!;
                                                return BarTooltipItem(
                                                  DateFormat('MM월 dd일\n')
                                                      .format(indexDate),
                                                  const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: formatTimeToText(
                                                          _.weeklyExerciseStatData[
                                                                  'weekly_exercise_time_list']
                                                              [
                                                              group.x.toInt()]),
                                                      style: const TextStyle(
                                                        color:
                                                            lightBrightPrimaryColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                          touchCallback: (FlTouchEvent event,
                                              barTouchResponse) {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                barTouchResponse == null ||
                                                barTouchResponse.spot == null) {
                                              _.updateWeeklyStatsTouchIndex(-1);
                                              return;
                                            }
                                            _.updateWeeklyStatsTouchIndex(
                                                barTouchResponse.spot!
                                                    .touchedBarGroupIndex);
                                          },
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          rightTitles:
                                              SideTitles(showTitles: false),
                                          topTitles:
                                              SideTitles(showTitles: false),
                                          bottomTitles: SideTitles(
                                            showTitles: true,
                                            getTextStyles: (context, value) =>
                                                TextStyle(
                                              color: value == 6
                                                  ? softRedColor
                                                  : deepGrayColor,
                                              fontSize: 13,
                                            ),
                                            margin: 16,
                                            getTitles: (double value) =>
                                                weekdayIntToStr[
                                                    value.toInt() + 1]!,
                                          ),
                                          leftTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        barGroups: List.generate(7, (index) {
                                          return makeGroupData(
                                              index,
                                              (20 *
                                                  _.weeklyExerciseStatData[
                                                          'weekly_exercise_time_list']
                                                      [index] /
                                                  5400),
                                              isTouched: index ==
                                                  _.weeklyStatsTouchIndex);
                                        }),
                                        gridData: FlGridData(show: false),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: mainBackgroundColor,
                              thickness: 10,
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 25, 30, 10),
                              child: Row(
                                children: [
                                  const Text(
                                    '이번주 총 운동시간',
                                    style: TextStyle(
                                      fontSize: statsLabelFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  horizontalSpacer(10),
                                  Text(
                                    formatTimeToText(_.weeklyExerciseStatData[
                                        'total_exercise_time_compared'][1]),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: brightPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: [
                                  const Text(
                                    '이번주',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: brightPrimaryColor,
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: brightPrimaryColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                    ),
                                    padding: const EdgeInsets.only(right: 10),
                                    width: 250 *
                                        _.weeklyExerciseStatData[
                                            'total_exercise_time_compared'][1] /
                                        _largerExerciseTime /
                                        1.4,
                                    height: 20,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      formatTimeToText(_.weeklyExerciseStatData[
                                          'total_exercise_time_compared'][1]),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 7),
                              child: Row(
                                children: [
                                  const Text(
                                    '지난주',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: mainBackgroundColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                    ),
                                    padding: const EdgeInsets.only(right: 10),
                                    width: 250 *
                                        _.weeklyExerciseStatData[
                                            'total_exercise_time_compared'][0] /
                                        _largerExerciseTime /
                                        1.4,
                                    height: 20,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      formatTimeToText(_.weeklyExerciseStatData[
                                          'total_exercise_time_compared'][0]),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: deepGrayColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 25),
                              child: Text.rich(
                                TextSpan(
                                  text: '지난주보다 운동 시간이 ',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: clearBlackColor,
                                    height: 25 / 17,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          formatTimeToText(_exerciseTimeDiff) +
                                              ((_exerciseTimeDiff < 0)
                                                  ? ' 감소'
                                                  : ' 증가'),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: brightPrimaryColor,
                                        height: 25 / 17,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '했어요\n',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: clearBlackColor,
                                        height: 25 / 17,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '이번주는 ',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: clearBlackColor,
                                        height: 25 / 17,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _.weeklyExerciseStatData[
                                                  'exercise_days']['current']
                                              .toString() +
                                          '일',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: brightPrimaryColor,
                                        height: 25 / 17,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' 운동하셨네요',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: clearBlackColor,
                                        height: 25 / 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
