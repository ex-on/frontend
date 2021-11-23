import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController
    with SingleGetTickerProviderMixin {
  static CommunityController to = Get.find();
  TextEditingController searchPostController = TextEditingController();
  TabController? communityMainTabController;
  int postCategory = 0; //0: 전체, 1: HOT, 2: 자유, 3: 정보, 4: 운동인증

  @override
  void onInit() {
    super.onInit();
    communityMainTabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    if (communityMainTabController != null) {
      communityMainTabController!.dispose();
    }
    super.onClose();
  }

  void updatePostCategory(int index) {
    postCategory = index;
    update();
  }

}
