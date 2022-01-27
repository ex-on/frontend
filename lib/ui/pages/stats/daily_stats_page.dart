import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/calendar.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/exercise/exercise_stat_block.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyStatsPage extends GetView<StatsController> {
  const DailyStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onMemoCompletePressed() {
      controller.postDailyStatsMemo();
      Get.back();
    }

    void _onMemoInputChanged(String val) {
      controller.update();
    }

    Widget getMemoDialog() {
      if (controller.dailyExerciseStatData.isNotEmpty) {
        if (controller.dailyExerciseStatData['stats']['memo'] != '') {
          controller.memoTextController.text =
              controller.dailyExerciseStatData['stats']['memo'];
          controller.update();
        }
      }
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SizedBox(
            height: 375,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(top: 0, child: JumpingExcitedCharacter()),
                Positioned(
                  top: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: context.width - 80,
                      minHeight: 200,
                      maxHeight: 325,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 40,
                              height: 40,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                '메모',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: clearBlackColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Material(
                                type: MaterialType.transparency,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: lightGrayColor,
                                  ),
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  onPressed: () => Get.back(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: SizedBox(
                            height: 200,
                            child: MemoInputField(
                              controller: controller.memoTextController,
                              onChanged: _onMemoInputChanged,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 45,
                          child: GetBuilder<StatsController>(
                            builder: (_) {
                              return ElevatedActionButton(
                                buttonText: '완료',
                                borderRadius: 5,
                                onPressed: _onMemoCompletePressed,
                                backgroundColor: clearBlackColor,
                                activated: (_.memoTextController.text != '') &&
                                    (_.memoTextController.text !=
                                        _.dailyExerciseStatData['stats']
                                            ['memo']),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void _onMemoTap() {
      Get.dialog(getMemoDialog());
    }

    Widget getMemoDisplay() {
      const String _hintText = '여기를 눌러 메모를 작성해 보세요';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: GetBuilder<StatsController>(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    '메모',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: clearBlackColor,
                    ),
                  ),
                ),
                Material(
                  color: mainBackgroundColor,
                  child: InkWell(
                    onTap: _onMemoTap,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                        minWidth: context.width - 60,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          _.dailyExerciseStatData.isNotEmpty
                              ? (_.dailyExerciseStatData['stats']['memo'] ==
                                          "" ||
                                      _.dailyExerciseStatData['stats']
                                              ['memo'] ==
                                          null
                                  ? _hintText
                                  : _.dailyExerciseStatData['stats']['memo'])
                              : _hintText,
                          style: TextStyle(
                            color: _.dailyExerciseStatData.isNotEmpty
                                ? (_.dailyExerciseStatData['stats']['memo'] ==
                                            "" ||
                                        _.dailyExerciseStatData['stats']
                                                ['memo'] ==
                                            null
                                    ? lightGrayColor
                                    : clearBlackColor)
                                : lightGrayColor,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return ListView(
      children: [
        GetBuilder<StatsController>(
          builder: (_) {
            return Calendar(
              updateSelectedDate: _.updateDailyStatsSelectedDate,
              onMonthChanged: _.getMonthlyExerciseDates,
              exerciseDates: _.monthlyExerciseDates,
              selectMode: CalendarSelectMode.daily,
            );
          },
        ),
        GetBuilder<StatsController>(
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Text(
                DateFormat('MM월 dd일 (E)', 'ko-KR')
                    .format(_.selectedDate)
                    .toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: clearBlackColor,
                ),
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
            } else if (_.dailyExerciseStatData.isEmpty) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Text(
                      '운동 기록이 없습니다',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: lightGrayColor,
                      ),
                    ),
                  ),
                  const Divider(
                    color: mainBackgroundColor,
                    thickness: 10,
                    height: 10,
                  ),
                  getMemoDisplay(),
                ],
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                    child: GetBuilder<StatsController>(
                      builder: (_) {
                        List<int> hms = splitHMS(
                            _.dailyExerciseStatData['stats']
                                ['total_exercise_time']);
                        return SizedBox(
                          height: 50,
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
                                ],
                              ),
                              const VerticalDivider(
                                color: dividerColor,
                                thickness: 1,
                                width: 30,
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
                                            _.dailyExerciseStatData['stats']
                                                ['max_one_rm']),
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
                                ],
                              ),
                              const VerticalDivider(
                                color: dividerColor,
                                thickness: 1,
                                width: 30,
                              ),
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
                                        text: getCleanTextFromDouble(
                                            _.dailyExerciseStatData['stats']
                                                ['total_volume']),
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
                                ],
                              ),
                              const VerticalDivider(
                                color: dividerColor,
                                thickness: 1,
                                width: 30,
                              ),
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
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text.rich(
                                      TextSpan(
                                        text: _.dailyExerciseStatData['stats']
                                                ['total_sets']
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
                                              fontWeight: FontWeight.normal,
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
                              const VerticalDivider(
                                color: dividerColor,
                                thickness: 1,
                                width: 30,
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
                                            _.dailyExerciseStatData['stats']
                                                ['total_distance']),
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
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    color: mainBackgroundColor,
                    thickness: 10,
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 25),
                    child: GetBuilder<StatsController>(
                      builder: (_) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: () {
                            List<Widget> children = [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  '일간 운동 기록',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: clearBlackColor,
                                  ),
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
                      },
                    ),
                  ),
                  const Divider(
                    color: mainBackgroundColor,
                    thickness: 10,
                    height: 10,
                  ),
                  getMemoDisplay(),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
