import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/index_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/stats/exercise_stat_block.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CumulativeStatsExercisePage extends GetView<StatsController> {
  const CumulativeStatsExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String exonWatermark = 'assets/exonWatermark.svg';

    List<PieChartSectionData> _piChartSectionBuilder() {
      return List.generate(
        4,
        (i) {
          final isTouched = false;
          final fontSize = isTouched ? 25.0 : 16.0;
          final radius = isTouched ? 60.0 : 50.0;
          switch (i) {
            case 0:
              return PieChartSectionData(
                color: brightPrimaryColor,
                value: 40,
                showTitle: false,
                radius: radius,
              );
            case 1:
              return PieChartSectionData(
                color: const Color(0xff6DBED1),
                value: 30,
                showTitle: false,
                radius: radius,
              );
            case 2:
              return PieChartSectionData(
                color: const Color(0xff9AD9E8),
                value: 15,
                showTitle: false,
                radius: radius,
              );
            case 3:
              return PieChartSectionData(
                color: const Color(0xffD3F7FF),
                value: 15,
                showTitle: false,
                radius: radius,
              );
            default:
              throw Error();
          }
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 30),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '제일 많이 한 운동',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextActionButton(
                buttonText: '전체보기',
                onPressed: () {},
                textColor: deepGrayColor,
                fontSize: 13,
              )
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
              itemCount: (16 / 3).ceil(),
              onPageChanged: controller.updateCurrentCumulativeExerciseIndex,
              itemBuilder: (context, index) {
                int lastPageItemNum = (16 % 3 == 0) ? 3 : (16 % 3);
                List<Widget> children = List.generate(
                  (16 / 3).ceil() - 1 == index ? lastPageItemNum : 3,
                  (index) => const ExcerciseStatBlock(
                    // id: id,
                    exerciseId: 117,
                    exerciseName: '바벨 인클라인 벤치프레스',
                    targetMuscle: 1,
                    exerciseMethod: 5,
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
                totalLength: (16 / 3).ceil());
          },
        ),
        verticalSpacer(50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: const [
              Text(
                '운동 비율 그래프',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                    sections: _piChartSectionBuilder(),
                  ),
                ),
                Positioned(
                  child: SvgPicture.asset(
                    exonWatermark,
                    height: 45,
                    width: 70,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: mainBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '운동 비율 그래프',
                        style: TextStyle(
                          color: clearBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text.rich(
                          TextSpan(
                            text: '가장 많이 운동한 종류는\n',
                            style: TextStyle(
                              fontSize: 14,
                              height: 22 / 14,
                              color: darkPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: '바벨 ',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 22 / 14,
                                  color: darkPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '운동이네요',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 22 / 14,
                                  color: darkPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        children: [
                          Material(
                            type: MaterialType.transparency,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            child: InkWell(
                              splashColor: darkSecondaryColor,
                              highlightColor: Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                              ),
                              onTap: () {},
                              child: const SizedBox(
                                width: 70,
                                height: 35,
                                child: Center(
                                  child: Text(
                                    '종류별',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                            height: 2,
                            color: unselectedIconColor,
                            indent: 16,
                            endIndent: 16,
                          ),
                          Material(
                            type: MaterialType.transparency,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            child: InkWell(
                              splashColor: darkSecondaryColor,
                              highlightColor: Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                              ),
                              onTap: () {},
                              child: const SizedBox(
                                width: 70,
                                height: 35,
                                child: Center(
                                  child: Text(
                                    '부위별',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      color: deepGrayColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
