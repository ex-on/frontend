import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/calendar.dart';
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: const [
                          Text(
                            '총 운동 시간',
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
                                text: '1',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: darkPrimaryColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: '시간 ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: brightPrimaryColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '43',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: darkPrimaryColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '분',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: brightPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            '최고 1RM',
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
                                text: '110',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: darkPrimaryColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'kg',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: brightPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
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
                                text: '3800',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: darkPrimaryColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'kg',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: brightPrimaryColor,
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
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: GetBuilder<StatsController>(builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: () {
                  List<Widget> children = [
                    const Text(
                      '오늘의 운동',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                  ];
                  children.add(ExerciseStatBlock());
                  return children;
                }(),
              );
            }),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                    'EXON의 누적 가입자 수가 1만 명을 돌파했습니다!! 안녕하세요 :) 프로토타입을 출시한 지 어느덧 2달이 되어가고 있습니다 그동안... 블라블라3줄까지만 적기 ...',
                    style: TextStyle(
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
      ),
    );
  }
}
