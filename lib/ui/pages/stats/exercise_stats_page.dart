import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseStatsPage extends GetView<StatsController> {
  const ExerciseStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.exerciseStatData.isEmpty) {
        controller.getExerciseStats();
      }
    });

    void _onBackPressed() {
      Get.back();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Header(
          onPressed: _onBackPressed,
        ),
      ),
      body: GetBuilder<StatsController>(
        builder: (_) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 26, bottom: 30),
                child: Row(
                  children: [
                    Text(
                      _.selectedExerciseInfo['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 20),
                      child: TargetMuscleLabel(
                          targetMuscle:
                              _.selectedExerciseInfo['target_muscle']),
                    ),
                    ExerciseMethodLabel(
                        exerciseMethod:
                            _.selectedExerciseInfo['exercise_method']),
                  ],
                ),
              ),
              () {
                if (_.loading || _.exerciseStatData.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: LoadingIndicator(icon: true),
                  );
                } else {
                  return Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 10),
                      children: [
                        Text.rich(
                          TextSpan(
                              text: '한 세트 최고 기록은 ',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: clearBlackColor,
                              ),
                              children: [
                                TextSpan(
                                  text: _.exerciseStatData['best_set']['reps'] +
                                      '회',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: brightPrimaryColor,
                                  ),
                                ),
                                const TextSpan(
                                  text: '에요',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: clearBlackColor,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  );
                }
              }(),
            ],
          );
        },
      ),
    );
  }
}
