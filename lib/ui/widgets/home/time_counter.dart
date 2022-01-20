import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:flutter/material.dart';

class ExerciseTimeCounter extends StatelessWidget {
  final ColorTheme theme;
  final int totalExerciseTime;
  const ExerciseTimeCounter({
    Key? key,
    required this.theme,
    required this.totalExerciseTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _timerLabel = '오늘의 운동시간';
    const String _timeCount = '00 : 00 : 00';
    Color primaryColor =
        theme == ColorTheme.day ? brightPrimaryColor : darkPrimaryColor;

    return Container(
      width: 330,
      height: 90,
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _timerLabel,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              Text(
                formatHHMMSS(totalExerciseTime),
                style: TextStyle(
                  fontSize: 28,
                  letterSpacing: -2,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  // letterSpacing: -2,
                ),
              )
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 8.0),
          //   child: Icon(
          //     Icons.verified,
          //     color: primaryColor,
          //     size: 23,
          //   ),
          // ),
        ],
      ),
    );
  }
}
