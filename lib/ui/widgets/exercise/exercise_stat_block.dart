import 'dart:math';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';

class ExerciseStatBlock extends StatefulWidget {
  const ExerciseStatBlock({
    Key? key,
  }) : super(key: key);

  @override
  State<ExerciseStatBlock> createState() => _ExerciseStatBlockState();
}

class _ExerciseStatBlockState extends State<ExerciseStatBlock> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: mainBackgroundColor,
        ),
        constraints: const BoxConstraints(
          minHeight: 75,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                opened = !opened;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 22, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                '인클라인 벤치프레스',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: clearBlackColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                ColorBadge(
                                  text: '가슴',
                                  type: 'targetMuscle',
                                  fontSize: 12,
                                  height: 23,
                                ),
                                horizontalSpacer(8),
                                ColorBadge(
                                  text: '바벨',
                                  type: 'exerciseMethod',
                                  fontSize: 12,
                                  height: 23,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: '예상 1RM ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: deepGrayColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '70kg',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: brightPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '5세트 | 14분 21초',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: deepGrayColor,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3, left: 8),
                              child: AnimatedRotation(
                                duration: Duration(milliseconds: 200),
                                turns: opened ? 1 / 4 : -1 / 4,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 18,
                                  color: opened
                                      ? brightPrimaryColor
                                      : deepGrayColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: SizedBox(
                      height: opened ? null : 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              children: () {
                                List<Widget> children = [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      '중량',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff8A8AAA),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ];

                                children.add(DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color(0xff8A8AAA),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: SizedBox(
                                    height: 25,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        '40kg',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ));

                                return children;
                              }(),
                            ),
                            verticalSpacer(10),
                            Row(
                              children: () {
                                List<Widget> children = [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      '횟수',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff8A8AAA),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ];

                                children.add(
                                  SizedBox(
                                    height: 25,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        '15',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xff8A8AAA),
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                                return children;
                              }(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
