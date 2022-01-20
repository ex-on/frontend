import 'dart:math' as Math;

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExcerciseStatBlock extends StatelessWidget {
  final int exerciseId;
  final String exerciseName;
  final int targetMuscle;
  final int exerciseMethod;
  const ExcerciseStatBlock({
    Key? key,
    required this.exerciseId,
    required this.exerciseName,
    required this.targetMuscle,
    required this.exerciseMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double _excerciseTextWidth = 130;

    void _onPressed() async {}

    return Container(
      height: 76,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: mainBackgroundColor,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _onPressed,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 24, right: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      exerciseName,
                      style: const TextStyle(
                        height: 1.0,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    Expanded(
                      child: verticalSpacer(0),
                    ),
                    const Text(
                      '예상 1RM ',
                      style: TextStyle(
                        fontSize: 10,
                        color: clearBlackColor,
                      ),
                    ),
                    const Text(
                      '70kg',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: brightPrimaryColor,
                      ),
                    ),
                    horizontalSpacer(5),
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: IconButton(
                        splashRadius: 25,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: Transform.rotate(
                          angle: -Math.pi * 90 / 180,
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 20,
                            color: softGrayColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 34,
                      height: 21,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFC700),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        targetMuscleIntToStr[targetMuscle] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    horizontalSpacer(10),
                    Container(
                      width: 34,
                      height: 21,
                      decoration: BoxDecoration(
                        color: brightPrimaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        exerciseMethodIntToStr[exerciseMethod] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(
                        height: 0,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 35),
                      child: Text(
                        '14분 21초',
                        style: TextStyle(
                          fontSize: 12,
                          color: deepGrayColor,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
