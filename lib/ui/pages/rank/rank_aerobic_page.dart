import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RankAerobicPage extends GetView<RankController> {
  const RankAerobicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onHelpPressed() {}

    return Builder(builder: (context) {
      List<Widget> children = [
        Container(
          color: Colors.white,
          width: context.width,
          padding: const EdgeInsets.only(
            top: 25,
            bottom: 30,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                    Material(
                      type: MaterialType.transparency,
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          icon: const HelpIcon(),
                          splashRadius: 15,
                          splashColor: mainBackgroundColor,
                          highlightColor: mainBackgroundColor,
                          onPressed: _onHelpPressed,
                          padding: EdgeInsets.zero,
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
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: GetBuilder<RankController>(builder: (_) {
                  return Text.rich(
                    TextSpan(
                      text: '헬스세포 김근육님은 ' +
                          DateFormat('yyyy년 MM월')
                              .format(_.aerobicRankSelectedMonth)
                              .toString() +
                          '에\n총 ',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 22 / 14,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '11,651 ',
                          style: TextStyle(
                            fontSize: 18,
                            height: 22 / 18,
                            color: cardioColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'kcal를 소모했어요',
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
                child: Column(
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
                          width: (context.width - 130) * 11651 / 15000,
                          height: 18,
                          padding: const EdgeInsets.only(right: 10),
                          margin: const EdgeInsets.only(left: 7),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xff8effbb),
                              brightPrimaryColor
                            ]),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            '11,651',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpacer(7),
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
                          width: (context.width - 130) * 8349 / 15000,
                          height: 18,
                          padding: const EdgeInsets.only(right: 10),
                          margin: const EdgeInsets.only(left: 7),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: mainBackgroundColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            '8,349',
                            style: const TextStyle(
                              color: deepGrayColor,
                              fontSize: 14,
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
                    onPressed: controller.subtractAerobicRankSelectedMonth,
                  ),
                ),
                GetBuilder<RankController>(builder: (_) {
                  return Text(
                    DateFormat('yyyy년 MM월')
                        .format(_.aerobicRankSelectedMonth)
                        .toString(),
                    style: const TextStyle(
                      color: deepGrayColor,
                      fontSize: 18,
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: IconButton(
                    icon: const RotatedBox(
                      quarterTurns: 2,
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: brightPrimaryColor,
                      ),
                    ),
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    onPressed: controller.addAerobicRankSelectedMonth,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 0.5, color: lightGrayColor),
      ];

      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: RankBadgeFirstIcon(),
                    ),
                    Text.rich(
                      TextSpan(
                        text: '헬스세포',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: lightGrayColor,
                        ),
                        children: [
                          TextSpan(
                            text: ' 김근육',
                            style: TextStyle(
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
                const Text.rich(
                  TextSpan(
                    text: '14,918',
                    style: TextStyle(
                      fontSize: 16,
                      color: clearBlackColor,
                    ),
                    children: [
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
            const Divider(thickness: 0.5, color: lightGrayColor),
          ],
        ),
      ));

      return ListView(
        padding: EdgeInsets.zero,
        children: children,
      );
    });
  }
}
