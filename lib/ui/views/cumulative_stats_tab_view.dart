import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/ui/pages/stats/cumulative_stats_exercise_page.dart';
import 'package:exon_app/ui/pages/stats/cumulative_stats_time_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CumulativeStatsTabView extends GetView<StatsController> {
  const CumulativeStatsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: const BouncingScrollPhysics(),
      controller: controller.cumulativeStatsTabController,
      children: const [
        CumulativeStatsTimePage(),
        CumulativeStatsExercisePage(),
      ],
    );
  }
}
