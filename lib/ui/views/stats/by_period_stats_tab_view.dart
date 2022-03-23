import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/ui/pages/stats/daily_stats_page.dart';
import 'package:exon_app/ui/pages/stats/monthly_stats_page.dart';
import 'package:exon_app/ui/pages/stats/weekly_stats_page.dart';
import 'package:exon_app/ui/widgets/common/calendar.dart';
import 'package:exon_app/ui/widgets/common/sliver_app_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ByPeriodStatsTabView extends GetView<StatsController> {
  const ByPeriodStatsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TabBar _byPeriodStatsTabBar = TabBar(
      controller: controller.byPeriodStatsTabController,
      indicatorColor: darkPrimaryColor,
      labelColor: darkPrimaryColor,
      tabs: const <Widget>[
        Tab(child: Text('일간')),
        Tab(child: Text('주간')),
        Tab(child: Text('월간')),
      ],
    );

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(
            child: GetBuilder<StatsController>(
              builder: (_) {
                return Calendar(
                  updateSelectedDate: _.updateSelectedDate,
                  onMonthChanged: _.getMonthlyExerciseDates,
                  exerciseDates: _.monthlyExerciseDates,
                  selectMode: CalendarSelectMode.daily,
                );
              },
            ),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                _byPeriodStatsTabBar,
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        physics: const ClampingScrollPhysics(),
        controller: controller.byPeriodStatsTabController,
        children: const [
          DailyStatsPage(),
          WeeklyStatsPage(),
          MonthlyStatsPage(),
        ],
      ),
    );
  }
}
