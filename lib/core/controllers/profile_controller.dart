import 'package:exon_app/core/services/community_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController
    with SingleGetTickerProviderMixin {
  static ProfileController to = Get.find();
  TabController? profileTabController;
  bool loading = false;
  int? totalQnaAnswerNum;
  int? totalPostNum;
  int currentPostIndex = 0;
  int currentQnaIndex = 0;
  List<dynamic> recentQnaList = [];
  List<dynamic> recentPostList = [];

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

  void updateCurrentQnaIndex(int index) {
    currentQnaIndex = index;
    update();
  }

  void updateCurrentPostIndex(int index) {
    currentPostIndex = index;
    update();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  Future<void> getUserRecentCommunityData() async {
    setLoading(true);
    var data = await CommunityApiService.getUserRecentCommunityData();
    totalQnaAnswerNum = data['answer_num'];
    totalPostNum = data['post_num'];
    recentQnaList = data['qna_data'];
    recentPostList = data['post_data'];
    update();
    setLoading(false);
    print(recentQnaList);
  }
}
