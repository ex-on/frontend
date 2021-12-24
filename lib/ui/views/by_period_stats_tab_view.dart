import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/ui/pages/stats/cumulative_stats_exercise_page.dart';
import 'package:exon_app/ui/pages/stats/daily_stats_page.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ByPeriodStatsTabView extends GetView<StatsController> {
  const ByPeriodStatsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: const BouncingScrollPhysics(),
      controller: controller.byPeriodStatsTabController,
      children: const [
        DailyStatsPage(),
        CumulativeStatsExercisePage(),
        LoadingIndicator(),
      ],
    );
  }
}
