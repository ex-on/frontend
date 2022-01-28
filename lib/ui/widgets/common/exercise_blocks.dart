import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExercisePlanBlock extends StatelessWidget {
  final Map<String, dynamic> exerciseData;
  final int id;
  final int numSets;
  final bool incomplete;
  const ExercisePlanBlock({
    Key? key,
    required this.exerciseData,
    required this.id,
    required this.numSets,
    required this.incomplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onPressed() async {
      Get.toNamed('add_exercise/update');
    }

    void _onStartPressed() async {
      await ExerciseBlockController.to.getExercisePlanWeightSets(id);
      ExerciseBlockController.to.startExercise(id, exerciseData);
    }

    return Container(
      height: 95,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: incomplete ? null : _onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 24,
              right: 18,
            ),
            child: Row(
              children: [
                incomplete
                    ? const IncompleteIcon()
                    : StartExerciseButton(onStartPressed: _onStartPressed),
                horizontalSpacer(15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseData['name'],
                      style: const TextStyle(
                        height: 1.0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    verticalSpacer(10),
                    TargetMuscleLabel(
                      targetMuscle: exerciseData['target_muscle'],
                      text:
                          '${targetMuscleIntToStr[exerciseData['target_muscle']]} / ${exerciseMethodIntToStr[exerciseData['exercise_method']]} / $numSets세트',
                    ),
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

class ExcerciseRecordBlock extends StatelessWidget {
  final Map<String, dynamic> exerciseData;
  final int totalSets;
  final double totalVolume;
  const ExcerciseRecordBlock({
    Key? key,
    required this.exerciseData,
    required this.totalSets,
    required this.totalVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onPressed() {}

    return Container(
      height: 95,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          // onTap: _onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 24,
              right: 18,
            ),
            child: Row(
              children: [
                const CompleteIcon(),
                horizontalSpacer(15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseData['name'],
                      style: const TextStyle(
                        height: 1.0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    verticalSpacer(10),
                    Row(
                      children: [
                        TargetMuscleLabel(
                          targetMuscle: exerciseData['target_muscle'],
                          text:
                              '${targetMuscleIntToStr[exerciseData['target_muscle']]}',
                          // $totalSets세트',
                        ),
                        horizontalSpacer(10),
                        ExerciseMethodLabel(
                          text:
                              '${exerciseMethodIntToStr[exerciseData['exercise_method']]}',
                        ),
                        horizontalSpacer(10),
                        ExerciseRecordLabel(
                          text:
                              '기록 / $totalSets세트 / ${getCleanTextFromDouble(totalVolume)}kg',
                        ),
                      ],
                    ),
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
