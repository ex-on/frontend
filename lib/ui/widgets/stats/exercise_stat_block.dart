import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseStatBlock extends GetView<StatsController> {
  final int exerciseId;
  final String exerciseName;
  final int targetMuscle;
  final int exerciseMethod;
  final int count;
  final int time;
  const ExerciseStatBlock({
    Key? key,
    required this.exerciseId,
    required this.exerciseName,
    required this.targetMuscle,
    required this.exerciseMethod,
    required this.count,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onPressed() {
      controller.updateSelectedExerciseInfo({
        'id': exerciseId,
        'name': exerciseName,
        'target_muscle': targetMuscle,
        'exercise_method': exerciseMethod,
      });
      Get.toNamed('/stats/exercise');
    }

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
                      '수행 횟수 ',
                      style: TextStyle(
                        fontSize: 11,
                        color: clearBlackColor,
                      ),
                    ),
                    Text(
                      count.toString() + '회',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: brightPrimaryColor,
                      ),
                    ),
                  ],
                ),
               targetMuscle != null ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TargetMuscleLabel(targetMuscle: targetMuscle),
                    horizontalSpacer(10),
                    ExerciseMethodLabel(
                      exerciseMethod: exerciseMethod,
                    ),
                    const Expanded(
                      child: SizedBox(
                        height: 0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Text(
                        formatTimeToText(time),
                        style: const TextStyle(
                          fontSize: 12,
                          color: deepGrayColor,
                        ),
                      ),
                    )
                  ],
                ) : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CardioLabel(),
                    horizontalSpacer(10),
                   CardioMethodLabel(
                      exerciseMethod: exerciseMethod,
                    ),
                    const Expanded(
                      child: SizedBox(
                        height: 0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Text(
                        formatTimeToText(time),
                        style: const TextStyle(
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
