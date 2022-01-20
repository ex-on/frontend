import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RankController extends GetxController with SingleGetTickerProviderMixin {
  static RankController to = Get.find<RankController>();
  TabController? rankMainTabController;
  DateTime aerobicRankSelectedMonth = DateTime.now();
  DateTime weightRankSelectedMonth = DateTime.now();

  @override
  void onInit() {
    rankMainTabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    if (rankMainTabController != null) {
      rankMainTabController!.dispose();
    }
  }

  void addAerobicRankSelectedMonth() {
    aerobicRankSelectedMonth = DateTime(
        aerobicRankSelectedMonth.year, aerobicRankSelectedMonth.month + 1, 1);
    update();
  }

  void subtractAerobicRankSelectedMonth() {
    aerobicRankSelectedMonth = DateTime(
        aerobicRankSelectedMonth.year, aerobicRankSelectedMonth.month - 1, 1);
    update();
  }
  void addWeightRankSelectedMonth() {
    weightRankSelectedMonth = DateTime(
        weightRankSelectedMonth.year, weightRankSelectedMonth.month + 1, 1);
    update();
  }

  void subtractWeightRankSelectedMonth() {
    weightRankSelectedMonth = DateTime(
        weightRankSelectedMonth.year, weightRankSelectedMonth.month - 1, 1);
    update();
  }
}
