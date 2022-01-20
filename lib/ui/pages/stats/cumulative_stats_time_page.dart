import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CumulativeStatsTimePage extends StatelessWidget {
  const CumulativeStatsTimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: mainBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '운동 기록',
                    style: TextStyle(
                      fontSize: 16,
                      color: clearBlackColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -2,
                    ),
                  ),
                  TextActionButton(
                    buttonText: '그래프 닫기',
                    onPressed: () {},
                    textColor: deepGrayColor,
                    fontSize: 12,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 14, bottom: 11),
                child: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: '2021년 12월 26일부터 지금까지\n총 ',
                        style: TextStyle(
                          color: darkPrimaryColor,
                          fontSize: 14,
                          letterSpacing: -2,
                          height: 22 / 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '252번',
                        style: TextStyle(
                          color: brightPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: -2,
                          height: 22 / 14,
                        ),
                      ),
                      TextSpan(
                        text: '의 운동 기록을 남겼어요',
                        style: TextStyle(
                          color: darkPrimaryColor,
                          fontSize: 14,
                          letterSpacing: -2,
                          height: 22 / 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const ColorBadge(
                          text: '총 기간',
                          width: 65,
                          height: 25,
                          color: Color(0xffFFC700),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        horizontalSpacer(20),
                        const Text.rich(
                          TextSpan(
                            text: '총 운동시간 ',
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: -1,
                              color: darkPrimaryColor,
                            ),
                            children: [
                              TextSpan(
                                text: '281',
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '시간 ',
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                ),
                              ),
                              TextSpan(
                                text: '35',
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '분',
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  verticalSpacer(12),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const ColorBadge(
                          text: '주별 평균',
                          width: 65,
                          height: 25,
                          color: Color(0xffA38EFF),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        horizontalSpacer(20),
                        const Text.rich(
                          TextSpan(
                            text: '일주일에 평균 ',
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: -1,
                              color: darkPrimaryColor,
                            ),
                            children: [
                              TextSpan(
                                text: '5.6',
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '번',
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  verticalSpacer(12),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const ColorBadge(
                          text: '1회 평균',
                          width: 65,
                          height: 25,
                          color: brightPrimaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        horizontalSpacer(20),
                        const Text.rich(
                          TextSpan(
                            text: '1회 평균 ',
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: -1,
                              color: darkPrimaryColor,
                            ),
                            children: [
                              TextSpan(
                                text: '1',
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '시간 ',
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                ),
                              ),
                              TextSpan(
                                text: '6',
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '분 운동했어요',
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: -1,
                                  color: darkPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          color: mainBackgroundColor,
          width: context.width,
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '신체변화 기록',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: clearBlackColor,
                      letterSpacing: -1,
                    ),
                  ),
                  TextActionButton(
                      buttonText: '더보기',
                      onPressed: () {},
                      textColor: darkSecondaryColor),
                ],
              ),
              const Text.rich(
                TextSpan(
                  text: 'exon_official 님은 2021년 12월 26일부터\n지금까지 총 ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: darkPrimaryColor,
                    fontSize: 14,
                    height: 22 / 14,
                    letterSpacing: -1,
                  ),
                  children: [
                    TextSpan(
                      text: '9',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: brightPrimaryColor,
                        fontSize: 18,
                        height: 22 / 18,
                        letterSpacing: -1,
                      ),
                    ),
                    TextSpan(
                      text: '번의 신체 기록을 남겼어요',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: darkPrimaryColor,
                        fontSize: 14,
                        height: 22 / 14,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(top: 15),
                width: context.width - 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        ColorBadge(
                          text: '인바디 최고기록',
                          color: darkSecondaryColor,
                          width: 90,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('2022년 8월 6일'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
