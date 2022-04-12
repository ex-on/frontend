import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/ui/widgets/exercise/exercise_blocks.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseStatsListPage extends StatelessWidget {
  const ExerciseStatsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _headerTitle = '제일 많이 한 운동';

    void _onBackPressed() {
      Get.back();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Header(
          onPressed: _onBackPressed,
          title: _headerTitle,
        ),
      ),
      body: SafeArea(
        child: GetBuilder<StatsController>(
          builder: (_) {
            return ListView.builder(
              itemCount: _.cumulativeExerciseStatData['exercise_stats'].length,
              itemBuilder: (context, index) => ExerciseStatBlock(
                exerciseId: _.cumulativeExerciseStatData['exercise_stats']
                    [index]['exercise']['id'],
                exerciseName: _.cumulativeExerciseStatData['exercise_stats']
                    [index]['exercise']['name'],
                targetMuscle: _.cumulativeExerciseStatData['exercise_stats']
                    [index]['exercise']['target_muscle'],
                exerciseMethod: _.cumulativeExerciseStatData['exercise_stats']
                    [index]['exercise']['exercise_method'],
                count: _.cumulativeExerciseStatData['exercise_stats'][index]
                    ['count'],
                time: _.cumulativeExerciseStatData['exercise_stats'][index]
                    ['time'],
              ),
            );
          },
        ),
      ),
    );
  }
}
