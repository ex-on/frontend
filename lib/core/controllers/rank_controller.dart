import 'package:exon_app/core/controllers/connection_controller.dart';
import 'package:exon_app/core/services/rank_api_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankController extends GetxController
    with GetTickerProviderStateMixin {
  static RankController to = Get.find<RankController>();
  RefreshController proteinRefreshController = RefreshController();
  RefreshController cardioRefreshController = RefreshController();
  RefreshController weightRefreshController = RefreshController();
  TabController? rankMainTabController;
  DateTime cardioRankSelectedMonth = DateTime.now();
  DateTime weightRankSelectedMonth = DateTime.now();
  Map<String, dynamic> proteinRankData = {};
  Map<String, dynamic> cardioRankData = {};
  Map<String, dynamic> weightRankData = {};
  @override
  void onInit() {
    rankMainTabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    if (rankMainTabController != null) {
      rankMainTabController!.dispose();
    }
    super.onClose();
  }

  void onProteinRefresh() async {
    await getProteinRank();
    proteinRefreshController.refreshCompleted();
  }

  void onCardioRefresh() async {
    await getCardioRank();
    cardioRefreshController.refreshCompleted();
  }

  void onWeightRefresh() async {
    await getWeightRank();
    weightRefreshController.refreshCompleted();
  }

  void addCardioRankSelectedMonth() {
    cardioRankSelectedMonth = DateTime(
        cardioRankSelectedMonth.year, cardioRankSelectedMonth.month + 1, 1);
    cardioRefreshController.requestRefresh();

    update();
  }

  void subtractCardioRankSelectedMonth() {
    cardioRankSelectedMonth = DateTime(
        cardioRankSelectedMonth.year, cardioRankSelectedMonth.month - 1, 1);
    cardioRefreshController.requestRefresh();
    update();
  }

  void addWeightRankSelectedMonth() {
    weightRankSelectedMonth = DateTime(
        weightRankSelectedMonth.year, weightRankSelectedMonth.month + 1, 1);
    weightRefreshController.requestRefresh();
    update();
  }

  void subtractWeightRankSelectedMonth() {
    weightRankSelectedMonth = DateTime(
        weightRankSelectedMonth.year, weightRankSelectedMonth.month - 1, 1);
    weightRefreshController.requestRefresh();
    update();
  }

  Future<void> getProteinRank() async {
    ConnectionController.to.updateRefreshCategory(0);
    proteinRankData = await RankApiService.getProteinRank();
    update();
  }

  Future<void> getCardioRank() async {
    ConnectionController.to.updateRefreshCategory(1);
    cardioRankData =
        await RankApiService.getCardioRank(cardioRankSelectedMonth.month);
    update();
  }

  Future<void> getWeightRank() async {
    ConnectionController.to.updateRefreshCategory(2);
    weightRankData =
        await RankApiService.getWeightRank(weightRankSelectedMonth.month);
    update();
  }
}
