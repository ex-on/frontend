import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/helpers/utils.dart';

class ExercisePlanBlock extends StatelessWidget {
  final Map<String, dynamic> exerciseData;
  final Map<String, dynamic> planData;
  final bool incomplete;
  const ExercisePlanBlock({
    Key? key,
    required this.exerciseData,
    required this.planData,
    required this.incomplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onPressed() async {
      Get.toNamed('add_exercise/update');
    }

    void _onStartPressed() async {
      if (exerciseData['target_muscle'] != null) {
        await ExerciseBlockController.to
            .getExercisePlanWeightSets(planData['id']);
        ExerciseBlockController.to
            .startExerciseWeight(planData['id'], exerciseData);
      } else {
        ExerciseBlockController.to.updateExercisePlanCardio(planData);
        ExerciseBlockController.to
            .startExerciseCardio(planData['id'], exerciseData);
      }
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
                exerciseData['target_muscle'] != null
                    ? Column(
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
                                '${targetMuscleIntToStr[exerciseData['target_muscle']]} / ${exerciseMethodIntToStr[exerciseData['exercise_method']]} / ${planData['num_sets']}세트',
                          ),
                        ],
                      )
                    : Builder(builder: (context) {
                        String _targetDistance = '';
                        String _targetDuration = '';

                        if (planData['target_distance'] != null) {
                          _targetDistance = ' / ' +
                              getCleanTextFromDouble(
                                  planData['target_distance']) +
                              'km';
                        }

                        if (planData['target_duration'] != null) {
                          _targetDuration = ' / ' +
                              formatTimeToText(planData['target_duration']);
                        }

                        return Column(
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
                            CardioLabel(
                              text:
                                  '유산소 / ${cardioMethodIntToStr[exerciseData['exercise_method']]}$_targetDistance$_targetDuration',
                            ),
                          ],
                        );
                      }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseRecordBlock extends StatelessWidget {
  final Map<String, dynamic> exerciseData;
  final Map<String, dynamic> recordData;
  const ExerciseRecordBlock({
    Key? key,
    required this.exerciseData,
    required this.recordData,
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
                    (exerciseData['target_muscle'] != null)
                        ? Row(
                            children: [
                              TargetMuscleLabel(
                                text: targetMuscleIntToStr[
                                        exerciseData['target_muscle']]! +
                                    ' / ' +
                                    exerciseMethodIntToStr[
                                        exerciseData['exercise_method']]!,
                                targetMuscle: exerciseData['target_muscle'],
                              ),
                              horizontalSpacer(10),
                              ExerciseRecordLabel(
                                text: recordData['total_volume'] != 0
                                    ? '${recordData['total_sets']}세트 / ${getCleanTextFromDouble(recordData['total_volume'])}kg'
                                    : '${recordData['total_sets']}세트 / ${recordData['total_reps']}회',
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              CardioLabel(
                                text: '유산소 / ' +
                                    cardioMethodIntToStr[
                                        exerciseData['exercise_method']]!,
                              ),
                              horizontalSpacer(10),
                              Builder(builder: (context) {
                                String _recordDistance = '';
                                String _recordDuration = ' / ' +
                                    formatTimeToText(
                                        recordData['record_duration']);

                                if (recordData['record_distance'] != null) {
                                  _recordDistance = getCleanTextFromDouble(
                                          recordData['record_distance']) +
                                      'km';
                                }
                                return ExerciseRecordLabel(
                                  text: _recordDistance + _recordDuration,
                                );
                              }),
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
