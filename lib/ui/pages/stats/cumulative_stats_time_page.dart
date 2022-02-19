import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CumulativeStatsTimePage extends GetView<StatsController> {
  const CumulativeStatsTimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.cumulativeTimeStatData.isEmpty) {
        controller.getCumulativeTimeStats();
      }
    });

    void _onPhysicalDataRecordPressed() {
      Get.toNamed('/stats/physical_data/record');
    }

    void _toPhysicalDataPagePressed() {
      Get.toNamed('/stats/physical_data');
    }

    return GetBuilder<StatsController>(builder: (_) {
      if (_.cumulativeTimeStatData.isEmpty || _.loading) {
        return const LoadingIndicator(icon: true);
      } else {
        List exerciseTimeStatData = [];
        _.cumulativeTimeStatData['exercise_time_stat'].forEach((key, val) {
          exerciseTimeStatData.add([DateTime.parse(key), val]);
        });

        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '운동 기록',
                    style: TextStyle(
                      fontSize: statsLabelFontSize,
                      color: clearBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: _.cumulativeTimeStatData['cumulative_stat']
                                    ['first_stat_date'] +
                                '부터 지금까지 총 ',
                            style: const TextStyle(
                              color: darkPrimaryColor,
                              fontSize: 16,
                              height: 1.26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: _.cumulativeTimeStatData['cumulative_stat']
                                        ['num_stats']
                                    .toString() +
                                '번',
                            style: const TextStyle(
                              color: brightPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              height: 1.26,
                            ),
                          ),
                          const TextSpan(
                            text: '의 운동 기록을 남겼어요',
                            style: TextStyle(
                              color: darkPrimaryColor,
                              fontSize: 16,
                              height: 1.26,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 3),
                              child: Text(
                                '총 기간',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              formatTimeToText(
                                  _.cumulativeTimeStatData['cumulative_stat']
                                      ['sum_time']),
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
                                '주별 평균',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              getCleanTextFromDouble(_.cumulativeTimeStatData[
                                      'cumulative_stat']['avg_exercise_week']) +
                                  '번',
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
                                '1회 평균',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              formatTimeToText(
                                  _.cumulativeTimeStatData['cumulative_stat']
                                      ['avg_time']),
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
                ],
              ),
            ),
            const Divider(
              color: mainBackgroundColor,
              height: 13,
              thickness: 13,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      '운동시간 변화',
                      style: TextStyle(
                        fontSize: statsLabelFontSize,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                  ),
                  SfCartesianChart(
                    zoomPanBehavior: _.cumulativeTimeStatsZoomPanBehavior,
                    primaryXAxis: DateTimeAxis(
                      axisLabelFormatter: (AxisLabelRenderDetails args) {
                        late String label;
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                            args.value as int);
                        if (date.year != DateTime.now().year) {
                          label = DateFormat('yyyy년 MM월 dd일').format(date);
                        } else {
                          label = DateFormat('MM월 dd일').format(date);
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
                      majorGridLines: const MajorGridLines(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: '(시간)',
                        textStyle: const TextStyle(
                          fontSize: 10,
                          color: deepGrayColor,
                        ),
                        alignment: ChartAlignment.far,
                      ),
                      axisLabelFormatter: (AxisLabelRenderDetails args) {
                        String label = formatTimeToText(args.value as int);
                        return ChartAxisLabel(
                          // label,
                          '',
                          const TextStyle(
                            fontSize: 12,
                            color: deepGrayColor,
                          ),
                        );
                      },
                      majorGridLines: const MajorGridLines(
                        width: 1,
                        // dashArray: [3, 3],
                        // color: lightGrayColor,
                      ),
                      majorTickLines: const MajorTickLines(size: 0),
                      axisLine: const AxisLine(width: 0),
                    ),
                    trackballBehavior: _.cumulativeTimeStatsTrackballBehavior,
                    series: <ChartSeries>[
                      LineSeries<dynamic, DateTime>(
                        dataSource: exerciseTimeStatData,
                        color: darkSecondaryColor,
                        width: 3,
                        xValueMapper: (dynamic data, _) {
                          // // print(data);
                          // DateTime date = data[0];
                          // if (date.day == 1) {
                          //   if (date.year == DateTime.now().year) {
                          //     return date;
                          //   } else {
                          //     return date;
                          //   }
                          // } else {
                          //   return date;
                          // }
                          return data[0];
                        },
                        yValueMapper: (dynamic data, _) {
                          // print(data[1]);
                          return data[1];
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: mainBackgroundColor,
              height: 13,
              thickness: 13,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      '신체변화 기록',
                      style: TextStyle(
                        fontSize: statsLabelFontSize,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                  ),
                  _.cumulativeTimeStatData['physical_stat'][0] == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: Column(
                              children: const [
                                DumbellCharacter(),
                                Text(
                                  '신체 변화를 기록하세요!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: lightGrayColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Text.rich(
                            TextSpan(
                              text: AuthController.to.userInfo['username'] +
                                  ' 님은 ' +
                                  DateFormat('yyyy년 MM월 dd일').format(
                                      DateTime.parse(_.cumulativeTimeStatData[
                                          'physical_stat'][1]['created_at'])) +
                                  '에\n',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: darkPrimaryColor,
                                fontSize: 16,
                                height: 1.26,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      _.cumulativeTimeStatData['physical_stat']
                                                  [0]
                                              .toString() +
                                          '번째',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: brightPrimaryColor,
                                    fontSize: 16,
                                    height: 1.26,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' 신체 기록을 남겼어요',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: darkPrimaryColor,
                                    fontSize: 16,
                                    height: 1.26,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: _.cumulativeTimeStatData['physical_stat'][0] == 0
                          ? ElevatedActionButton(
                              width: 220,
                              height: 60,
                              buttonText: '현재 신체 정보 기록',
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: mainBackgroundColor,
                              ),
                              onPressed: _onPhysicalDataRecordPressed,
                            )
                          : ElevatedActionButton(
                              width: 220,
                              height: 60,
                              buttonText: '신체 정보 보러가기',
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: mainBackgroundColor,
                              ),
                              onPressed: _toPhysicalDataPagePressed,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    });
  }
}
