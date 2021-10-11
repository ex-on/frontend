import 'package:exon_app/constants/colors.dart';
import 'package:flutter/material.dart';

class TimeCounter extends StatelessWidget {
  const TimeCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _timerLabel = '오늘의 운동시간';
    const String _timeCount = '01:30:52';
    const String _completeIconText = '목표 달성';

    return Container(
      width: 330,
      height: 90,
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: deepPrimaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                _timerLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              Text(
                _timeCount,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  // letterSpacing: -2,
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              Text(
                _completeIconText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
