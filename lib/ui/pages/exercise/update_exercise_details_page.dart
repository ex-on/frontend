import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_labels.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:exon_app/helpers/transformers.dart';

class UpdateExerciseDetailsPage extends GetView<AddExerciseController> {
  const UpdateExerciseDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _totalExercisePlanNumText = '총 운동 ';

    void _onBackPressed() {
      Get.back();
    }

    void _onStartPressed(Map<String, dynamic> planData,
        Map<String, dynamic> exerciseData) async {
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

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            onPressed: _onBackPressed,
            title: DateFormat('yyyy년 MM월 dd일').format(DateTime.now()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
              _totalExercisePlanNumText +
                  HomeController.to.indexDayExercisePlanList.length.toString() +
                  '개',
              style: const TextStyle(
                color: softGrayColor,
                fontSize: 13.7,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              itemBuilder: (context, index) {
                var exerciseData = HomeController
                    .to.indexDayExercisePlanList[index]['exercise_data'];
                var planData = HomeController.to.indexDayExercisePlanList[index]
                    ['plan_data'];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          StartExerciseButton(
                            onStartPressed: () => _onStartPressed(
                              planData,
                              exerciseData,
                            ),
                          ),
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
                                      targetMuscle:
                                          exerciseData['target_muscle'],
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
                                        formatTimeToText(
                                            planData['target_duration']);
                                  }

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => verticalSpacer(24),
              itemCount: HomeController.to.indexDayExercisePlanList.length,
            ),
          ),
        ],
      ),
    );
  }
}
