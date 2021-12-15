import 'package:exon_app/core/services/community_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController
    with SingleGetTickerProviderMixin {
  static CommunityController to = Get.find();
  TextEditingController searchPostController = TextEditingController();
  TextEditingController commentTextController = TextEditingController();
  FocusNode? commentTextFieldFocus;
  TabController? communityMainTabController;
  ScrollController scrollController = ScrollController();
  int page = 0;
  int? commentId;
  RxInt postCategory = 0.obs; //0: 전체, 1: HOT, 2: 자유, 3: 정보, 4: 운동인증
  RxInt listPage = 1.obs;
  bool loading = false;
  bool listPageLoading = false;
  bool postContentLoading = false;
  bool postCommentsLoading = false;
  bool apiPostLoading = false;
  bool postLiked = false;
  bool postSaved = false;
  List<dynamic> contentList = [];
  Map<String, dynamic> postContent = {};
  Map<String, dynamic> postCount = {};
  List<dynamic> postCommentList = [];
  List<dynamic>? savedPostsList;

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
    postCategory.listen((val) {
      callback(val);
    });
    scrollController.addListener(onScroll);
    commentTextFieldFocus = FocusNode();
  }

  @override
  void onClose() {
    if (communityMainTabController != null) {
      communityMainTabController!.dispose();
    }
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    if (commentTextFieldFocus != null) {
      commentTextFieldFocus!.dispose();
    }
    super.onClose();
  }

  // Page navigation control
  void jumpToPage(int index) {
    page = index;
    update();
  }

  void onScroll() {
    if (scrollController.position.extentAfter < 300 && !listPageLoading) {
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

  void setPostCommentsLoading(bool val) {
    postCommentsLoading = val;
    update();
  }

  void setApiPostLoading(bool val) {
    apiPostLoading = val;
    update();
  }

  void updateReplyCommentId(int? val) {
    commentId = val;
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
      var res = await CommunityApiService.getPostPreview(indexNum, 1, type);
      contentList = res;
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res =
          await CommunityApiService.getPostPreview(20, listPage.value, type);
      if (listPage.value == 1) {
        contentList.clear();
      }
      print(res);
      if (res == false) {
        listPage--;
      } else {
        contentList.addAll(res);
      }
      update();
      setListPageLoading(false);
    }
  }

  Future<void> getHotBoardPreview(int? indexNum) async {
    if (indexNum != null) {
      setLoading(true);
      var res = await CommunityApiService.getHotBoardPreview(indexNum, 1);
      contentList = res;
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res =
          await CommunityApiService.getHotBoardPreview(20, listPage.value);
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
    var res = await CommunityApiService.getPost(postId);
    postContent = res;
    update();
    setPostContentLoading(false);
  }

  Future<void> getPostComments(int postId) async {
    setPostCommentsLoading(true);
    var res = await CommunityApiService.getPostComments(postId);
    postCommentList = res;
    update();
    setPostCommentsLoading(false);
  }

  Future<void> updatePostCount() async {}

  Future<void> postPostComment(int postId, String content) async {
    if (content != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.postPostComment(postId, content);
      if (res == 200) {
        var res = await CommunityApiService.getPostComments(postId);
        postCommentList = res;
        update();
        getPostCount(postId);
      }
      setApiPostLoading(false);
    }
  }

  Future<void> postPostCommentReply(
      int postId, int postCommentId, String content) async {
    if (content != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.postPostCommentReply(
          postId, postCommentId, content);
      if (res == 200) {
        var res = await CommunityApiService.getPostComments(postId);
        postCommentList = res;
        update();
      }
      setApiPostLoading(false);
    }
  }

  Future<void> getPostUserStatus(int postId, String extent) async {
    var resData = await CommunityApiService.getPostUserStatus(postId, extent);
    if (resData['is_liked'] != null) {
      postLiked = resData['is_liked'];
    }
    if (resData['is_saved'] != null) {
      postSaved = resData['is_saved'];
    }
    update();
  }

  Future<void> updatePostCountLikes(int postId) async {
    postLiked = !postLiked;
    update();
    var res = await CommunityApiService.updatePostLikes(postId, postLiked);
    getPostUserStatus(postId, 'likes');
    getPostCount(postId);
  }

  Future<void> updatePostCommentCountLikes(int index) async {
    var isLiked = postCommentList[index]['comments']['liked'];
    postCommentList[index]['comments']['liked'] = !isLiked;
    postCommentList[index]['comments']['comment_count']['count_likes'] +=
        (isLiked ? -1 : 1);
    var postCommentId =
        postCommentList[index]['comments']['comment_data']['id'];
    update();
    var res = await CommunityApiService.updatePostCommentLikes(
        postCommentId, !isLiked);
    // getPostUserStatus(postId, 'likes');
    // getPostCount(postId);
  }

  Future<void> updatePostCommentReplyCountLikes(
      int index, int commentIndex) async {
    var isLiked = postCommentList[commentIndex]['replies'][index]['liked'];
    postCommentList[commentIndex]['replies'][index]['liked'] = !isLiked;
    postCommentList[commentIndex]['replies'][index]['reply_count']
        ['count_likes'] += (isLiked ? -1 : 1);
    var postCommentReplyId =
        postCommentList[commentIndex]['replies'][index]['reply_data']['id'];
    update();
    var res = await CommunityApiService.updatePostCommentReplyLikes(
        postCommentReplyId, !isLiked);
  }

  Future<void> updatePostCountSaved(int postId) async {
    postSaved = !postSaved;
    update();
    var res = await CommunityApiService.updatePostSaved(postId, postSaved);
    getPostUserStatus(postId, 'saved');
    getPostCount(postId);
  }

  Future<void> getPostCount(int postId) async {
    var resData = await CommunityApiService.getPostCount(postId);
    postCount = resData;
    update();
  }

  Future<void> getSavedPosts() async {
    setLoading(true);
    var resData = await CommunityApiService.getSavedPosts();
    savedPostsList = resData;
    update();
    setLoading(false);
  }
}
