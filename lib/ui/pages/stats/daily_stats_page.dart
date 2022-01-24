import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/calendar.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/exercise/exercise_stat_block.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyStatsPage extends GetView<StatsController> {
  const DailyStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: lightBrightPrimaryColor,
      ),
      child: ListView(
        children: [
          Calendar(
            updateSelectedDate: controller.updateSelectedDate,
            onMonthChanged: controller.getMonthlyExerciseDate,
          ),
          Center(
            child: GetBuilder<StatsController>(
              builder: (_) {
                return Text(
                  DateFormat('MM월 dd일 (E)', 'ko-KR')
                      .format(_.selectedDate)
                      .toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          GetBuilder<StatsController>(
            builder: (_) {
              if (_.loading) {
                return const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: LoadingIndicator(icon: true),
                );
              } else if (_.dailyExerciseStatData.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    '운동 기록이 없습니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '일간 운동',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: clearBlackColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 3),
                            child: GetBuilder<StatsController>(
                              builder: (_) {
                                List<int> hms = splitHMS(
                                    _.dailyExerciseStatData['stats']
                                        ['total_exercise_time']);
                                return SizedBox(
                                  height: 45,
                                  width: context.width - 72,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            '총 운동 시간',
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                          color:
                                                              darkPrimaryColor,
                                                          fontFamily: 'Manrope',
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: hms[2].toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color:
                                                              darkPrimaryColor,
                                                          fontFamily: 'Manrope',
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                        text: '초',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              darkPrimaryColor,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                          color:
                                                              darkPrimaryColor,
                                                          fontFamily: 'Manrope',
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: hms[1].toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color:
                                                              darkPrimaryColor,
                                                          fontFamily: 'Manrope',
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                        text: '분',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              darkPrimaryColor,
                                                          fontFamily: 'Manrope',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }(),
                                          ),
                                        ],
                                      ),
                                      horizontalSpacer(30),
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
                                                    _.dailyExerciseStatData[
                                                        'stats']['max_one_rm']),
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
                                        ],
                                      ),
                                      horizontalSpacer(30),
                                      Column(
                                        children: [
                                          const Text(
                                            '총 운동 볼륨',
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
                                                        .dailyExerciseStatData[
                                                    'stats']['total_volume']),
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
                                        ],
                                      ),
                                      horizontalSpacer(30),
                                      Column(
                                        children: [
                                          const Text(
                                            '총 세트 수',
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
                                                text: _.dailyExerciseStatData[
                                                        'stats']['total_sets']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: darkPrimaryColor,
                                                  fontFamily: 'Manrope',
                                                ),
                                                children: const [
                                                  TextSpan(
                                                    text: ' set',
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
                                        ],
                                      ),
                                      horizontalSpacer(30),
                                      Column(
                                        children: [
                                          const Text(
                                            '주행 거리',
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
                                                        .dailyExerciseStatData[
                                                    'stats']['total_distance']),
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
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: GetBuilder<StatsController>(builder: (_) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: () {
                            List<Widget> children = [
                              const Text(
                                '일간 운동 기록',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: clearBlackColor,
                                ),
                              ),
                            ];
                            _.dailyExerciseStatData['records'].asMap().forEach(
                                  (index, record) => children.add(
                                    DailyExerciseStatBlock(index: index),
                                  ),
                                );
                            // children.add(ExerciseStatBlock());
                            return children;
                          }(),
                        );
                      }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: GetBuilder<StatsController>(builder: (_) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '오늘의 메모',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: clearBlackColor,
                                  ),
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: IconButton(
                                      onPressed: () {},
                                      splashRadius: 13,
                                      padding: EdgeInsets.zero,
                                      iconSize: 20,
                                      icon: const Icon(
                                        Icons.edit_rounded,
                                        color: deepGrayColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              _.dailyExerciseStatData['stats']['memo'] == "" ||
                                      _.dailyExerciseStatData['stats']
                                              ['memo'] ==
                                          null
                                  ? '메모를 작성해 보세요'
                                  : _.dailyExerciseStatData['stats']['memo'],
                              style: const TextStyle(
                                color: clearBlackColor,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
