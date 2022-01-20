import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
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

    void _onStartPressed(int id,Map<String,dynamic> exerciseData) async {
      await ExerciseBlockController.to.getExercisePlanWeightSets(id);
      ExerciseBlockController.to.startExercise(id, exerciseData);
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
                  HomeController.to.todayExercisePlanList.length.toString() +
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
                    .to.todayExercisePlanList[index]['exercise_data'];
                var planData =
                    HomeController.to.todayExercisePlanList[index]['plan_data'];
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
                              planData['id'],
                              exerciseData,
                            ),
                          ),
                          horizontalSpacer(15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exerciseData['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: clearBlackColor,
                                ),
                              ),
                              verticalSpacer(10),
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: brightSecondaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 2),
                                  child: Text(
                                    '${targetMuscleIntToStr[exerciseData['target_muscle']]} / ${exerciseMethodIntToStr[exerciseData['exercise_method']]} / ${planData['num_sets']}세트',
                                    style: const TextStyle(
                                      height: 1.0,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: clearBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => verticalSpacer(24),
              itemCount: HomeController.to.todayExercisePlanList.length,
            ),
          ),
        ],
      ),
    );
  }
}
