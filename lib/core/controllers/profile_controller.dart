import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController
    with SingleGetTickerProviderMixin {
  static ProfileController to = Get.find();
  TabController? profileTabController;

  @override
  void onInit() {
    super.onInit();
    profileTabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    if (profileTabController != null) {
      profileTabController!.dispose();
    }
    super.onClose();
  }
}
