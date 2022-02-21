import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/physical_data_controller.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PhysicalDataPage extends GetView<PhysicalDataController> {
  const PhysicalDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _headerTitle = '신체 정보';
    const String _physicalDataLabel = '나의 신체 정보';
    const List<Color> _bmiGradientColors = <Color>[
      Color(0xff0D92DD),
      Color(0xff3AD29F),
      Color(0xffFFC700),
      Color(0xffD63E6C),
    ];

    Future.delayed(Duration.zero, () {
      if (controller.physicalStatData.isEmpty) {
        controller.getPhysicalData();
      }
      if (StatsController.to.cumulativeTimeStatData.isEmpty) {
        StatsController.to.getCumulativeTimeStats();
      }
    });

    void _onBackPressed() {
      Get.until((route) => Get.currentRoute == '/home');
    }

    void _onPhysicalDataCategoryButtonPressed(int val) {
      controller.updatePhysicalDataCategory(val);
    }

    void _onPhysicalDataRecordPressed() {
      Get.toNamed('/stats/physical_data/record');
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Header(
          onPressed: _onBackPressed,
          title: _headerTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder<PhysicalDataController>(
            builder: (_) {
              if (_.loading || _.physicalStatData.isEmpty) {
                return const LoadingIndicator();
              } else {
                Map physicalStatData = _.physicalStatData['cumulative_stat']
                    [physicalStatsCategoryIntToStrEng[_.physicalStatsCategory]];
                List physicalStatDataSource = [];

                physicalStatData.forEach(
                  (key, val) {
                    physicalStatDataSource.add([DateTime.parse(key), val]);
                  },
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: AuthController.to.userInfo['username'] +
                                ' 님은 ' +
                                DateFormat('yyyy년 MM월 dd일').format(
                                    DateTime.parse(StatsController
                                            .to.cumulativeTimeStatData[
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
                                text: StatsController
                                        .to
                                        .cumulativeTimeStatData['physical_stat']
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
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 30),
                      child: Text(
                        _physicalDataLabel,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: clearBlackColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 20, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const MaleAvatar(
                            height: 105,
                            width: 35,
                          ),
                          Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          '골격근량',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: clearBlackColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            getCleanTextFromDouble(_
                                                    .physicalStatData[
                                                'current_stat']['muscle_mass']),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: brightPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      width: 20,
                                      thickness: 1,
                                      color: dividerColor,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          '체지방률',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: clearBlackColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            getCleanTextFromDouble(
                                                _.physicalStatData[
                                                        'current_stat']
                                                    ['body_fat_percentage']),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: brightPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      width: 20,
                                      thickness: 1,
                                      color: dividerColor,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          '키',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: clearBlackColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            getCleanTextFromDouble(
                                                _.physicalStatData[
                                                    'current_stat']['height']),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: brightPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      width: 20,
                                      thickness: 1,
                                      color: dividerColor,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          '몸무게',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: clearBlackColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            getCleanTextFromDouble(
                                                _.physicalStatData[
                                                    'current_stat']['weight']),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: brightPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 260,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 5,
                                    left: 260 *
                                        ((_.physicalStatData['current_stat']
                                                ['bmi'] as double) -
                                            16) /
                                        (30 - 16),
                                  ),
                                  child: const SizedBox(
                                    width: 8,
                                    height: 8,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: brightPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 260,
                                height: 12.5,
                                margin:
                                    const EdgeInsets.only(right: 20, left: 20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: _bmiGradientColors),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              verticalSpacer(10),
                              SizedBox(
                                width: 260,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      '15',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: deepGrayColor,
                                      ),
                                    ),
                                    Text(
                                      '18.5',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: deepGrayColor,
                                      ),
                                    ),
                                    Text(
                                      '23',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: deepGrayColor,
                                      ),
                                    ),
                                    Text(
                                      '25',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: deepGrayColor,
                                      ),
                                    ),
                                    Text(
                                      '30',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: deepGrayColor,
                                      ),
                                    ),
                                  ],
                                ),
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
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                      child: SizedBox(
                        height: 30,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          children: List.generate(9, (index) {
                            if (index % 2 == 0) {
                              int idx = index ~/ 2;
                              if (idx == _.physicalStatsCategory) {
                                return ElevatedButton(
                                  onPressed: () =>
                                      _onPhysicalDataCategoryButtonPressed(idx),
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
                                    physicalStatsCategoryIntToStr[idx]!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                );
                              } else {
                                return TextActionButton(
                                  height: 23,
                                  buttonText:
                                      physicalStatsCategoryIntToStr[idx]!,
                                  onPressed: () =>
                                      _onPhysicalDataCategoryButtonPressed(idx),
                                  fontSize: 11,
                                  isUnderlined: false,
                                  fontWeight: FontWeight.w500,
                                  textColor: deepGrayColor,
                                  overlayColor:
                                      selectLabelColor.withOpacity(0.7),
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
                        // onTrackballPositionChanging: (TrackballArgs args) {
                        //   double yValue =
                        //       args.chartPointInfo.chartDataPoint!.yValue;
                        //   DateTime date = DateTime.fromMillisecondsSinceEpoch(
                        //       args.chartPointInfo.chartDataPoint!.xValue);
                        //   args.chartPointInfo.header = 'dsdfdsf';
                        //   args.chartPointInfo.label =
                        //       DateFormat('yyyy년\nMM월 dd일').format(date) +
                        //           '\n' +
                        //           yValue.toString() +
                        //           getPhysicalStatsUnit(_.physicalStatsCategory);
                        // },
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
                        ),
                        // primaryYAxis: NumericAxis(
                        //   majorGridLines: const MajorGridLines(
                        //       // width: 1,
                        //       // dashArray: [3, 3],
                        //       // color: lightGrayColor,
                        //       ),
                        //   majorTickLines: const MajorTickLines(size: 0),
                        //   axisLine: const AxisLine(width: 0),
                        // ),
                        primaryYAxis: NumericAxis(
                          axisLabelFormatter: (AxisLabelRenderDetails args) {
                            int label = args.value as int;

                            return ChartAxisLabel(
                              label.toString() +
                                  getPhysicalStatsUnit(_.physicalStatsCategory),
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
                        plotAreaBorderWidth: 0,
                        trackballBehavior: _.physicalStatsTrackballBehavior,
                        series: <ChartSeries>[
                          LineSeries<dynamic, DateTime>(
                            dataSource: physicalStatDataSource,
                            color: lightGrayColor,
                            width: 3,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                              color: brightPrimaryColor,
                              borderColor: Colors.white,
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Center(
                        child: ElevatedActionButton(
                          width: 220,
                          height: 60,
                          buttonText: '현재 신체 정보 기록',
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: mainBackgroundColor,
                          ),
                          onPressed: _onPhysicalDataRecordPressed,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
