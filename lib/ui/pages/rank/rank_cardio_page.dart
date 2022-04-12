import 'dart:math';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/circle.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankCardioPage extends GetView<RankController> {
  const RankCardioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.cardioRankData.isEmpty) {
        controller.cardioRefreshController.requestRefresh();
      }
    });

    return GetBuilder<RankController>(
      builder: (_) {
        return SmartRefresher(
          controller: controller.cardioRefreshController,
          onRefresh: controller.onCardioRefresh,
          header: const MaterialClassicHeader(
            color: cardioColor,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: () {
              if (_.cardioRankData.isEmpty) {
                return <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      '정보를 불러오는 중이에요...',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ];
              } else {
                List<Widget> children = [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25,
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              EnergyIcon(),
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  '이달의 칼로리 소모',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: clearBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: mainBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                          width: context.width - 60,
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          child: GetBuilder<RankController>(builder: (_) {
                            return Text.rich(
                              TextSpan(
                                text: activityLevelIntToStr[AuthController
                                        .to.userInfo['activity_level']]! +
                                    ' ' +
                                    AuthController.to.userInfo['username'] +
                                    '님은 ' +
                                    DateFormat('yyyy년 MM월')
                                        .format(_.cardioRankSelectedMonth)
                                        .toString() +
                                    '에\n총 ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 22 / 14,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: getCleanTextFromDouble(_
                                        .cardioRankData['calories']
                                        .toDouble()),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 22 / 18,
                                      color: cardioColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' kcal를 소모했어요',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 22 / 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: () {
                            double _baseWidth = max<double>(
                                    _.cardioRankData['avg_calories'].toDouble(),
                                    _.cardioRankData['calories'].toDouble()) +
                                50;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      '나의 소모 kcal',
                                      style: TextStyle(
                                        color: cardioColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: (context.width - 150) *
                                          _.cardioRankData['calories'] /
                                          _baseWidth,
                                      height: 18,
                                      padding: const EdgeInsets.only(right: 10),
                                      margin: const EdgeInsets.only(left: 7),
                                      alignment: Alignment.centerRight,
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [
                                          Color(0xff8effbb),
                                          brightPrimaryColor
                                        ]),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        getCleanTextFromDouble(
                                            _.cardioRankData['calories']),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpacer(6),
                                Row(
                                  children: [
                                    const Text(
                                      '평균 소모 kcal',
                                      style: TextStyle(
                                        color: deepGrayColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: (context.width - 150) *
                                          _.cardioRankData['avg_calories'] /
                                          _baseWidth,
                                      height: 18,
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                      ),
                                      padding: const EdgeInsets.only(right: 10),
                                      margin: const EdgeInsets.only(left: 7),
                                      alignment: Alignment.centerRight,
                                      decoration: BoxDecoration(
                                        color: mainBackgroundColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        getCleanTextFromDouble(
                                            _.cardioRankData['avg_calories']),
                                        style: const TextStyle(
                                          color: deepGrayColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.5, color: lightGrayColor),
                  SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: brightPrimaryColor,
                              ),
                              splashRadius: 20,
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              onPressed:
                                  controller.subtractCardioRankSelectedMonth,
                            ),
                          ),
                          GetBuilder<RankController>(builder: (_) {
                            return Text(
                              DateFormat('yyyy년 MM월')
                                  .format(_.cardioRankSelectedMonth)
                                  .toString(),
                              style: const TextStyle(
                                color: deepGrayColor,
                                fontSize: 18,
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: GetBuilder<RankController>(builder: (_) {
                              bool _activated =
                                  _.cardioRankSelectedMonth.year !=
                                          DateTime.now().year ||
                                      _.cardioRankSelectedMonth.month !=
                                          DateTime.now().month;
                              return IconButton(
                                icon: RotatedBox(
                                  quarterTurns: 2,
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: _activated
                                        ? brightPrimaryColor
                                        : lightGrayColor,
                                  ),
                                ),
                                splashRadius: 20,
                                padding: EdgeInsets.zero,
                                iconSize: 20,
                                onPressed: _activated
                                    ? _.addCardioRankSelectedMonth
                                    : null,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Divider(
                      thickness: 0.5,
                      color: lightGrayColor,
                      height: 0.5,
                    ),
                  ),
                ];

                _.cardioRankData['rank_list'].asMap().forEach(
                  (index, data) {
                    late Widget _rankIcon;

                    switch (index) {
                      case 0:
                        _rankIcon = const SizedBox(
                          width: 45,
                          height: 50,
                          child: RankBadgeFirstIcon(
                            width: 50,
                            height: 50,
                          ),
                        );
                        break;
                      case 1:
                        _rankIcon = const SizedBox(
                          width: 45,
                          height: 50,
                          child: RankBadgeSecondIcon(
                            width: 50,
                            height: 50,
                          ),
                        );
                        break;
                      case 2:
                        _rankIcon = const SizedBox(
                          width: 45,
                          height: 50,
                          child: RankBadgeThirdIcon(
                            width: 50,
                            height: 50,
                          ),
                        );
                        break;
                      default:
                        _rankIcon = Circle(
                          width: 45,
                          height: 50,
                          color: index + 1 == _.cardioRankData['rank']
                              ? brightPrimaryColor.withOpacity(0.8)
                              : Colors.transparent,
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: index + 1 == _.cardioRankData['rank']
                                    ? Colors.white
                                    : brightPrimaryColor,
                              ),
                            ),
                          ),
                        );
                    }

                    children.add(
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: index + 1 == _.cardioRankData['rank']
                              ? brightPrimaryColor.withOpacity(0.15)
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: _rankIcon,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text: activityLevelIntToStr[
                                                data['activity_level']]!,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: lightGrayColor,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: ' ' + data['username'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: clearBlackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: getCleanTextFromDouble(
                                            data['calories']),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: clearBlackColor,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: ' kcal',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: clearBlackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: lightGrayColor,
                                height: 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                return children;
              }
            }(),
          ),
        );
      },
    );
  }
}
