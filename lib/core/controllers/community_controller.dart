import 'dart:developer';

import 'package:exon_app/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController
    with SingleGetTickerProviderMixin {
  static CommunityController to = Get.find();
  TextEditingController searchPostController = TextEditingController();
  TabController? communityMainTabController;
  ScrollController scrollController = ScrollController();
  int page = 0;
  RxInt postCategory = 0.obs; //0: 전체, 1: HOT, 2: 자유, 3: 정보, 4: 운동인증
  RxInt listPage = 1.obs;
  bool loading = false;
  bool listPageLoading = false;
  bool postContentLoading = false;
  bool postLiked = false;
  bool postSaved = false;
  List<dynamic> contentList = [];
  Map<String, dynamic> postContent = {};

  dynamic callback(int postCategory) {
    if (postCategory == 0) {
      Future.delayed(Duration.zero, () => getPostPreview(5, postCategory));
    } else if (postCategory == 1) {
      Future.delayed(Duration.zero, () => getHotBoardPreview(5));
    } else if (postCategory == 2 || postCategory == 3) {
      Future.delayed(Duration.zero, () => getPostPreview(5, postCategory - 1));
    }
  }

  dynamic listPageCallback(int listPage) {
    print(postCategory.value);
    if (postCategory.value == 0) {
      Future.delayed(
          Duration.zero, () => getPostPreview(null, postCategory.value));
    } else if (postCategory.value == 1) {
      Future.delayed(Duration.zero, () => getHotBoardPreview(null));
    } else if (postCategory.value == 2 || postCategory.value == 3) {
      Future.delayed(
          Duration.zero, () => getPostPreview(null, postCategory.value - 1));
    }
  }

  @override
  void onInit() {
    super.onInit();
    communityMainTabController = TabController(length: 3, vsync: this);
    callback(postCategory.value);
    scrollController.addListener(onScroll);
  }

  @override
  void onClose() {
    if (communityMainTabController != null) {
      communityMainTabController!.dispose();
    }
    scrollController.removeListener(onScroll);
    scrollController.dispose();

    super.onClose();
  }

  // Page navigation control
  void jumpToPage(int index) {
    page = index;
    update();
  }

  void onScroll() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {
      print('called' + listPage.toString());

      listPage++;
    }
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void setListPageLoading(bool val) {
    listPageLoading = val;
    update();
  }

  void setPostContentLoading(bool val) {
    postContentLoading = val;
    update();
  }

  void resetContent() {
    listPage.value = 1;
    contentList = [];
    update();
  }

  void addListPage() {
    listPage++;
  }

  Future<void> getPostPreview(int? indexNum, int type) async {
    if (indexNum != null) {
      setLoading(true);
      var res = await ApiService.getPostPreview(indexNum, 1, type);
      contentList = res;
      update();
      print(res.length);
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res = await ApiService.getPostPreview(10, listPage.value, type);
      if (listPage.value == 1) {
        contentList.clear();
      }
      print(res.length);
      contentList.addAll(res);
      update();
      setListPageLoading(false);
    }
  }

  Future<void> getHotBoardPreview(int? indexNum) async {
    if (indexNum != null) {
      setLoading(true);
      var res = await ApiService.getHotBoardPreview(indexNum, 1);
      contentList = res;
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res = await ApiService.getHotBoardPreview(10, listPage.value);
      if (listPage.value == 1) {
        contentList.clear();
      }
      print(res.length);
      contentList.addAll(res);
      update();
      setListPageLoading(false);
    }
  }

  Future<void> getPost(int postId) async {
    setPostContentLoading(true);
    var res = await ApiService.getPost(postId);
    postContent = res;
    update();
    setPostContentLoading(false);
  }

  Future<void> updatePostCount() async {
    
  }
}
