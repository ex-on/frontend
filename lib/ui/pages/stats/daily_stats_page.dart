import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyStatsPage extends StatelessWidget {
  const DailyStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: lightBrightPrimaryColor,
      ),
      child: ListView(
        children: [
          const Center(
            child: Text(
              '11월 26일 (금)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
              children: [
                Text(
                  '일간 운동',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: clearBlackColor,
                  ),
                ),
                Row(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
