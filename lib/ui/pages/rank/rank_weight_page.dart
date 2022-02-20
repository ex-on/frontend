import 'dart:math';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/circle.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankWeightPage extends GetView<RankController> {
  const RankWeightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.weightRankData.isEmpty) {
        controller.weightRefreshController.requestRefresh();
      }
    });

    Widget _helpDialog = AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: const [
                    EnergyIcon(
                      color: darkSecondaryColor,
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.5),
                      child: Text(
                        '운동 볼륨',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: clearBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 20,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 20),
            child: Text(
              '운동 볼륨 산출 방법은 다음과 같습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: deepGrayColor,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 2, bottom: 20),
            child: Text.rich(
              TextSpan(
                text: '세트별 ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: deepGrayColor,
                ),
                children: [
                  TextSpan(
                    text: '"무게 x 횟수"',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: brightPrimaryColor,
                    ),
                  ),
                  TextSpan(
                    text: '의 총합',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: deepGrayColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    void _onHelpPressed() {
      Get.dialog(_helpDialog);
    }

    return GetBuilder<RankController>(
      builder: (_) {
        return SmartRefresher(
          controller: controller.weightRefreshController,
          onRefresh: controller.onWeightRefresh,
          header: const MaterialClassicHeader(
            color: darkSecondaryColor,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: () {
              if (_.weightRankData.isEmpty) {
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
                            children: [
                              const EnergyIcon(
                                color: darkSecondaryColor,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 6, right: 5),
                                child: Text(
                                  '이달의 총 운동 볼륨',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: clearBlackColor,
                                  ),
                                ),
                              ),
                              Material(
                                type: MaterialType.transparency,
                                child: HelpIconButton(
                                  onPressed: _onHelpPressed,
                                  size: 20,
                                  backgroundColor: mainBackgroundColor,
                                  overlayColor:
                                      brightPrimaryColor.withOpacity(0.1),
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
                                        .format(_.weightRankSelectedMonth)
                                        .toString() +
                                    '에\n총 ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 22 / 14,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: getCleanTextFromDouble(
                                        _.weightRankData['volume'].toDouble()),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 22 / 18,
                                      color: darkSecondaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'kg의 운동 볼륨을 소화했어요',
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
                                    _.weightRankData['avg_volume'].toDouble(),
                                    _.weightRankData['volume'].toDouble()) +
                                100;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      '나의 운동 볼륨',
                                      style: TextStyle(
                                        color: darkSecondaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: (context.width - 150) *
                                          _.weightRankData['volume'] /
                                          _baseWidth,
                                      height: 18,
                                      padding: const EdgeInsets.only(right: 10),
                                      margin: const EdgeInsets.only(left: 7),
                                      alignment: Alignment.centerRight,
                                      constraints: const BoxConstraints(
                                        minWidth: 30,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [
                                          darkSecondaryColor,
                                          brightPrimaryColor
                                        ]),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        getCleanTextFromDouble(_
                                            .weightRankData['volume']
                                            .toDouble()),
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
                                      '평균 운동 볼륨',
                                      style: TextStyle(
                                        color: deepGrayColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: (context.width - 150) *
                                          _.weightRankData['avg_volume'] /
                                          _baseWidth,
                                      height: 18,
                                      padding: const EdgeInsets.only(right: 10),
                                      margin: const EdgeInsets.only(left: 7),
                                      alignment: Alignment.centerRight,
                                      constraints: const BoxConstraints(
                                        minWidth: 30,
                                      ),
                                      decoration: BoxDecoration(
                                        color: mainBackgroundColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        getCleanTextFromDouble(_
                                            .weightRankData['avg_volume']
                                            .toDouble()),
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
                                  controller.subtractWeightRankSelectedMonth,
                            ),
                          ),
                          GetBuilder<RankController>(builder: (_) {
                            return Text(
                              DateFormat('yyyy년 MM월')
                                  .format(_.weightRankSelectedMonth)
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
                                  _.weightRankSelectedMonth.year !=
                                          DateTime.now().year ||
                                      _.weightRankSelectedMonth.month !=
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
                                    ? _.addWeightRankSelectedMonth
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

                _.weightRankData['rank_list'].asMap().forEach(
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
                          color: index + 1 == _.weightRankData['rank']
                              ? brightPrimaryColor.withOpacity(0.8)
                              : Colors.transparent,
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: index + 1 == _.weightRankData['rank']
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
                          color: index + 1 == _.weightRankData['rank']
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
                                            data['volume'].toDouble()),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: clearBlackColor,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: ' kg',
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
                                  height: 0.5),
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
