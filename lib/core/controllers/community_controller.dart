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
  ScrollController postListScrollController = ScrollController();
  ScrollController postScrollController = ScrollController();
  int page = 0;
  int? commentId;
  int? postId;
  int? qnaId;
  int? answerId;
  int? postType;
  int? qnaType;
  RxInt postCategory = 0.obs; //0: 전체, 1: HOT, 2: 자유, 3: 정보, 4: 운동인증
  RxInt qnaCategory = 0.obs; // 0: HOT, 1: 전체, 2: 미해결, 3: 해결
  RxInt postListPage = 1.obs;
  RxInt qnaListPage = 1.obs;
  bool loading = false;
  bool listPageLoading = false;
  bool contentLoading = false;
  bool commentsLoading = false;
  bool apiPostLoading = false;
  bool postLiked = false;
  bool postSaved = false;
  bool qnaSaved = false;
  List<dynamic> postContentList = [];
  List<dynamic> qnaContentList = [];
  Map<String, dynamic> postContent = {};
  Map<String, dynamic> postCount = {};
  Map<String, dynamic> qnaContent = {};
  Map<String, dynamic> qnaCount = {};
  List<dynamic> postCommentList = [];
  List<dynamic> qnaAnswerList = [];
  List<dynamic> qnaAnswerCommentList = [];
  List<dynamic>? savedList;

  dynamic postListCallback(int postCategory) {
    if (postCategory == 0) {
      Future.delayed(Duration.zero, () => getPostPreview(5, postCategory));
    } else if (postCategory == 1) {
      Future.delayed(Duration.zero, () => getHotPostPreview(5));
    } else if (postCategory == 2 || postCategory == 3) {
      Future.delayed(Duration.zero, () => getPostPreview(5, postCategory - 1));
    }
  }

  dynamic qnaListCallback(int qnaCategory) {
    if (qnaCategory == 0) {
      Future.delayed(Duration.zero, () => getHotQnaPreview(5));
    } else if (qnaCategory == 1) {
      Future.delayed(Duration.zero, () => getQnaPreview(5, 0));
    } else {
      Future.delayed(Duration.zero, () => getQnaPreview(5, qnaCategory - 1));
    }
  }

  dynamic postListPageCallback(int listPage) {
    if (postCategory.value == 0) {
      Future.delayed(
          Duration.zero, () => getPostPreview(null, postCategory.value));
    } else if (postCategory.value == 1) {
      Future.delayed(Duration.zero, () => getHotPostPreview(null));
    } else if (postCategory.value == 2 || postCategory.value == 3) {
      Future.delayed(
          Duration.zero, () => getPostPreview(null, postCategory.value - 1));
    }
  }

  dynamic qnaListPageCallback(int listPage) {
    if (qnaCategory.value == 0) {
      Future.delayed(Duration.zero, () => getHotQnaPreview(null));
    } else if (qnaCategory.value == 1) {
      Future.delayed(Duration.zero, () => getQnaPreview(null, 0));
    } else {
      Future.delayed(
          Duration.zero, () => getQnaPreview(null, qnaCategory.value - 1));
    }
  }

  @override
  void onInit() {
    super.onInit();
    communityMainTabController = TabController(length: 3, vsync: this);
    postListCallback(postCategory.value);
    qnaListCallback(qnaCategory.value);
    postCategory.listen((val) {
      postListCallback(val);
    });
    qnaCategory.listen((val) {
      qnaListCallback(val);
    });
    postListScrollController.addListener(onScroll);

    commentTextFieldFocus = FocusNode();
  }

  @override
  void onClose() {
    if (communityMainTabController != null) {
      communityMainTabController!.dispose();
    }
    postListScrollController.removeListener(onScroll);
    postListScrollController.dispose();
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
    if (postListScrollController.position.extentAfter < 300 &&
        !listPageLoading) {
      postListPage++;
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

  void setContentLoading(bool val) {
    contentLoading = val;
    update();
  }

  void setCommentsLoading(bool val) {
    commentsLoading = val;
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

  void updatePostId(int? val) {
    postId = val;
    update();
  }

  void updateQnaId(int? val) {
    qnaId = val;
    update();
  }

  void updateAnswerId(int? val) {
    answerId = val;
    update();
  }

  void updatePostType(int? val) {
    postType = val;
    update();
  }

  void updateQnaType(int? val) {
    qnaType = val;
    update();
  }

  void resetContent() {
    postListPage.value = 1;
    postContentList = [];
    update();
  }

  void addListPage() {
    postListPage++;
  }

  Future<void> getPostPreview(int? indexNum, int type) async {
    if (indexNum != null) {
      setLoading(true);
      var res = await CommunityApiService.getPostPreview(indexNum, 1, type);
      try {
        postContentList = res;
      } catch (e) {}
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res = await CommunityApiService.getPostPreview(
          20, postListPage.value, type);
      if (postListPage.value == 1) {
        postContentList.clear();
      }
      print(res);
      if (res == false) {
        postListPage--;
      } else {
        postContentList.addAll(res);
      }
      update();
      setListPageLoading(false);
    }
  }

  Future<void> getQnaPreview(int? indexNum, int type) async {
    if (indexNum != null) {
      setLoading(true);
      var res = await CommunityApiService.getQnaPreview(indexNum, 1, type);
      qnaContentList = res;
      print(qnaContentList);
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res =
          await CommunityApiService.getQnaPreview(20, qnaListPage.value, type);
      if (qnaListPage.value == 1) {
        qnaContentList.clear();
      }
      print(res);
      if (res == false) {
        qnaListPage--;
      } else {
        qnaContentList.addAll(res);
      }
      update();
      setListPageLoading(false);
    }
  }

  Future<void> getHotPostPreview(int? indexNum) async {
    if (indexNum != null) {
      setLoading(true);
      var res = await CommunityApiService.getHotPostPreview(indexNum, 1);
      postContentList = res;
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res =
          await CommunityApiService.getHotPostPreview(20, postListPage.value);
      if (postListPage.value == 1) {
        postContentList.clear();
      }
      print(res.length);
      postContentList.addAll(res);
      update();
      setListPageLoading(false);
    }
  }

  Future<void> getHotQnaPreview(int? indexNum) async {
    if (indexNum != null) {
      setLoading(true);
      var res = await CommunityApiService.getHotQnaPreview(indexNum, 1);
      try {
        qnaContentList = res;
      } catch (e) {}
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res =
          await CommunityApiService.getHotQnaPreview(20, qnaListPage.value);
      if (qnaListPage.value == 1) {
        qnaContentList.clear();
      }
      print(res.length);
      qnaContentList.addAll(res);
      update();
      setListPageLoading(false);
    }
  }

  Future<void> getPost(int postId) async {
    setContentLoading(true);
    var res = await CommunityApiService.getPost(postId);
    postContent = res ?? postContent;
    update();
    setContentLoading(false);
  }

  Future<void> getQna(int qnaId) async {
    setContentLoading(true);
    var res = await CommunityApiService.getQna(qnaId);
    qnaContent = res;
    update();
    setContentLoading(false);
  }

  Future<void> getPostComments(int postId) async {
    setCommentsLoading(true);
    var res = await CommunityApiService.getPostComments(postId);
    postCommentList = res;
    update();
    setCommentsLoading(false);
  }

  Future<void> getQnaAnswers(int qnaId) async {
    setCommentsLoading(true);
    var res = await CommunityApiService.getQnaAnswers(qnaId);
    qnaAnswerList = res;
    update();
    setCommentsLoading(false);
  }

  Future<void> getQnaAnswerComments(int answerId) async {
    setCommentsLoading(true);
    var res = await CommunityApiService.getQnaAnswerComments(answerId);
    qnaAnswerCommentList = res;
    update();
    setCommentsLoading(false);
  }

  Future<void> updatePostCount() async {}

  Future<void> postPostComment(String content) async {
    if (content != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.postPostComment(postId!, content);
      if (res == 200) {
        var res = await CommunityApiService.getPostComments(postId!);
        postCommentList = res;
        update();
        getPostCount(postId!);
      }
      setApiPostLoading(false);
    }
  }

  Future<void> postPostCommentReply(int postCommentId, String content) async {
    if (content != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.postPostCommentReply(
          postId!, postCommentId, content);
      if (res == 200) {
        var res = await CommunityApiService.getPostComments(postId!);
        postCommentList = res;
        update();
      }
      setApiPostLoading(false);
    }
  }

  Future<void> postQnaComment(String content) async {
    if (content != '') {
      setApiPostLoading(true);
      var res =
          await CommunityApiService.postQnaAnswerComment(answerId!, content);
      if (res == 200) {
        var res = await CommunityApiService.getQnaAnswerComments(answerId!);
        qnaAnswerCommentList = res;
        update();
        getQnaCount(qnaId!);
      }
      setApiPostLoading(false);
    }
  }

  Future<void> postQnaCommentReply(int qnaCommentId, String content) async {
    if (content != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.postQnaAnswerCommentReply(
          answerId!, qnaCommentId, content);
      if (res == 200) {
        var res = await CommunityApiService.getQnaAnswerComments(answerId!);
        qnaAnswerCommentList = res;
        update();
      }
      setApiPostLoading(false);
    }
  }

  Future<void> getPostUserStatus(String extent) async {
    var resData = await CommunityApiService.getPostUserStatus(postId!, extent);
    if (resData['is_liked'] != null) {
      postLiked = resData['is_liked'];
    }
    if (resData['is_saved'] != null) {
      postSaved = resData['is_saved'];
    }
    update();
  }

  Future<void> getQnaUserStatus() async {
    if (qnaId != null) {
      var resData = await CommunityApiService.getQnaUserStatus(qnaId!);
      qnaSaved = resData['is_saved'];
      update();
    }
  }

  Future<void> updatePostCountLikes() async {
    postLiked = !postLiked;
    postCount['count_likes'] += (postLiked ? 1 : -1);
    update();
    var res = await CommunityApiService.updatePostLikes(postId!, postLiked);
    // getPostUserStatus(postId, 'likes');
    // getPostCount(postId);
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
      int commentIndex, int index) async {
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

  Future<void> updatePostCountSaved() async {
    postSaved = !postSaved;
    postCount['count_saved'] += (postSaved ? 1 : -1);
    update();
    var res = await CommunityApiService.updatePostSaved(postId!, postSaved);
    // getPostUserStatus(postId, 'saved');
    // getPostCount(postId);
  }

  Future<void> updateQnaCountSaved() async {
    qnaSaved = !qnaSaved;
    qnaCount['count_saved'] += (qnaSaved ? 1 : -1);
    update();
    var res = await CommunityApiService.updateQnaSaved(qnaId!, qnaSaved);
    // getPostUserStatus(postId, 'saved');
    // getPostCount(postId);
  }

  Future<void> updateQnaAnswerCountLikes(int index) async {
    var isLiked = qnaAnswerList[index]['liked'];
    qnaAnswerList[index]['liked'] = !isLiked;
    qnaAnswerList[index]['answer_count']['count_likes'] += (isLiked ? -1 : 1);
    var qnaAnswerId = qnaAnswerList[index]['answer_data']['id'];
    update();
    var res =
        await CommunityApiService.updateQnaAnswerLikes(qnaAnswerId, !isLiked);
  }

  Future<void> updateQnaAnswerCommentCountLikes(int index) async {
    var isLiked = qnaAnswerCommentList[index]['comment']['liked'];
    qnaAnswerCommentList[index]['comment']['liked'] = !isLiked;
    qnaAnswerCommentList[index]['comment']['comment_count']['count_likes'] +=
        (isLiked ? -1 : 1);
    var qnaAnswerCommentId =
        qnaAnswerCommentList[index]['comment']['comment_data']['id'];
    update();
    var res = await CommunityApiService.updateQnaAnswerCommentLikes(
        qnaAnswerCommentId, !isLiked);
  }

  Future<void> getPostCount(int postId) async {
    var resData = await CommunityApiService.getPostCount(postId);
    postCount = resData;
    update();
  }

  Future<void> getQnaCount(int qnaId) async {
    var resData = await CommunityApiService.getQnaCount(qnaId);
    qnaCount = resData;
    update();
  }

  Future<void> getSaved() async {
    setLoading(true);
    var resData = await CommunityApiService.getSaved();
    savedList = resData;
    update();
    setLoading(false);
  }
}
