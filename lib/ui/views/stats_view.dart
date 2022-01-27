import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/ui/views/by_period_stats_tab_view.dart';
import 'package:exon_app/ui/views/cumulative_stats_tab_view.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _cumulativeStatsHeaderTitle = '누적 통계';
    const String _byPeriodStatsHeaderTitle = '기간별 통계';

    final List<Widget> _pages = [
      const CumulativeStatsTabView(),
      const ByPeriodStatsTabView(),
    ];

    void _onCalendarPressed() {
      controller.jumpToPage(0);
    }

    void _onChartPressed() {
      controller.jumpToPage(1);
    }

    TabBar _cumulativeStatsTabBar = TabBar(
      controller: controller.cumulativeStatsTabController,
      indicatorColor: darkPrimaryColor,
      labelColor: darkPrimaryColor,
      tabs: const <Widget>[
        Tab(child: Text('시간순')),
        Tab(child: Text('운동별')),
      ],
    );

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

    Widget _header = SizedBox(
      height: 100,
      child: GetBuilder<StatsController>(
        builder: (_) {
          return AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            duration: const Duration(milliseconds: 500),
            child: StatsHeader(
              onCalendarPressed: _onCalendarPressed,
              onChartPressed: _onChartPressed,
              currentIndex: _.page,
              bottom:
                  _.page == 0 ? _cumulativeStatsTabBar : _byPeriodStatsTabBar,
              title: _.page == 0
                  ? _cumulativeStatsHeaderTitle
                  : _byPeriodStatsHeaderTitle,
            ),
          );
        },
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _header,
          Expanded(
            child: GetBuilder<StatsController>(
              builder: (_) {
                return _pages[_.page];
              },
            ),
          )
        ],
      ),
    );
  }
}
