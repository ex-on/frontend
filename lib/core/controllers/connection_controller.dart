import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/controllers/profile_controller.dart';
import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  static ConnectionController to = Get.find<ConnectionController>();

  bool loading = false;
  int refreshCategory = 0;
  // 랭킹
  // 0: proteinRefreshController
  // 1: cardioRefreshController
  // 2: weightRefreshController
  // 커뮤니티

  // 홈
  // 3: refreshController
  // 통계
  // 4: dailyStatsefreshController
  // 5: weeklyStatsRefreshController
  // 6: monthlyStatsRefreshController
  // 7: cumulativeTimeStatsRefreshController
  // 8: cumulativeExerciseStatsRefreshController
  // 9: exerciseStatsRefreshController
  // 프로필
  // 10: refreshController

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void updateRefreshCategory(int category) {
    refreshCategory = category;
  }

  void completeRefresh() {
    switch (refreshCategory) {
      case 0:
        RankController.to.proteinRefreshController.refreshCompleted();
        break;
      case 1:
        RankController.to.cardioRefreshController.refreshCompleted();
        break;
      case 2:
        RankController.to.weightRefreshController.refreshCompleted();
        break;
      case 3:
        HomeController.to.refreshController.refreshCompleted();
        break;
      case 4:
        StatsController.to.dailyStatsRefreshController.refreshCompleted();
        break;
      case 5:
        StatsController.to.weeklyStatsRefreshController.refreshCompleted();
        break;
      case 6:
        StatsController.to.monthlyStatsRefreshController.refreshCompleted();
        break;
      case 7:
        StatsController.to.cumulativeTimeStatsRefreshController
            .refreshCompleted();
        break;
      case 8:
        StatsController.to.cumulativeExerciseStatsRefreshController
            .refreshCompleted();
        break;
      case 9:
        StatsController.to.exerciseStatsRefreshController.refreshCompleted();
        break;
      case 10:
        ProfileController.to.refreshController.refreshCompleted();
        break;
      default:
        break;
    }
  }
}
