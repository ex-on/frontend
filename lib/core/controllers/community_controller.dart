import 'package:exon_app/core/services/community_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommunityController extends GetxController
    with GetTickerProviderStateMixin {
  static CommunityController to = Get.find();
  TextEditingController commentTextController = TextEditingController();
  TextEditingController postTitleTextController = TextEditingController();
  TextEditingController postContentTextController = TextEditingController();
  TextEditingController qnaTitleTextController = TextEditingController();
  TextEditingController qnaContentTextController = TextEditingController();
  TextEditingController qnaAnswerContentTextController =
      TextEditingController();
  FocusNode? commentTextFieldFocus;
  late TabController communityMainTabController;
  late TabController bookmarkedListTabController;
  late TabController postActivityListTabController;
  late TabController qnaActivityListTabController;
  ScrollController postListScrollController = ScrollController();
  ScrollController postScrollController = ScrollController();
  ScrollController qnaListScrollController = ScrollController();
  RefreshController postCategoryRefreshController = RefreshController();
  RefreshController qnaCategoryRefreshController = RefreshController();
  RefreshController postListRefreshController = RefreshController();
  RefreshController qnaListRefreshController = RefreshController();
  RefreshController postRefreshController = RefreshController();
  RefreshController qnaRefreshController = RefreshController();
  RefreshController qnaAnswerCommentsRefreshController = RefreshController();
  RefreshController savedRefreshController = RefreshController();

  RefreshController bookmarkedPostsRefreshController = RefreshController();
  RefreshController bookmarkedQnasRefreshController = RefreshController();
  RefreshController savedUserPostsRefreshController = RefreshController();
  RefreshController savedUserCommentedPostsRefreshController =
      RefreshController();
  RefreshController savedUserQnasRefreshController = RefreshController();
  RefreshController savedUserAnsweredQnasRefreshController =
      RefreshController();
  PageController bookmarkPageController = PageController();
  PageController postActivityPageController = PageController();
  PageController qnaActivityPageController = PageController();
  int page = 0;
  int? commentId;
  int? postId;
  int? qnaId;
  int? answerId;
  int? answerNumComments;
  int? postType = 0;
  bool? qnaSolved = false;
  int bookmarkCategory = 0;
  int postActivityCategory = 0;
  int qnaActivityCategory = 0;
  int bookmarkedPostIndex = 0;
  int bookmarkedQnaIndex = 0;
  int userPostsIndex = 0;
  int userCommentedPostsIndex = 0;
  int userQnasIndex = 0;
  int userAnsweredQnasIndex = 0;
  int selectedAnswerIndex = -1;

  RxInt postCategory = 0.obs; //0: HOT, 1: 자유, 2: 정보
  RxInt qnaCategory = 0.obs; // 0: HOT, 1: 미해결, 2: 해결
  RxInt postListStartIndex = 0.obs;
  RxInt qnaListStartIndex = 0.obs;
  bool searchOpen = false;
  bool showScrollToTopButton = false;
  bool loading = false;
  bool listPageLoading = false;
  bool contentLoading = false;
  bool commentsLoading = false;
  bool apiPostLoading = false;
  bool postListInitialLoad = true;
  bool qnaListInitialLoad = true;
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
  Map<String, dynamic> savedData = {};
  List<dynamic> bookmarkedPostsList = [];
  List<dynamic> bookmarkedQnasList = [];
  List<dynamic> savedUserPostsList = [];
  List<dynamic> savedUserCommentedPostsList = [];
  List<dynamic> savedUserQnasList = [];
  List<dynamic> savedUserAnsweredQnasList = [];

  Future<void> postCategoryListCallback(int postCategory) async {
    if (postCategory == 0) {
      await getHotPostPreview(5);
    } else {
      await getPostPreview(5, postCategory);
    }
  }

  Future<void> qnaCategoryListCallback(int qnaCategory) async {
    if (qnaCategory == 0) {
      await getHotQnaPreview(5);
    } else {
      await getQnaPreview(5, qnaCategory == 1 ? false : true);
    }
  }

  Future<void> postListPageCallback(int listPage) async {
    if (postCategory.value == 0) {
      await getHotPostPreview(null);
    } else {
      await getPostPreview(null, postCategory.value);
    }
  }

  dynamic qnaListPageCallback(int listPage) {
    if (qnaCategory.value == 0) {
      Future.delayed(Duration.zero, () => getHotQnaPreview(null));
    } else {
      Future.delayed(Duration.zero,
          () => getQnaPreview(null, qnaCategory.value == 1 ? false : true));
    }
  }

  @override
  void onInit() {
    super.onInit();
    communityMainTabController = TabController(length: 3, vsync: this);
    bookmarkedListTabController = TabController(length: 2, vsync: this);
    postActivityListTabController = TabController(length: 2, vsync: this);
    qnaActivityListTabController = TabController(length: 2, vsync: this);
    communityMainTabController.addListener(() {
      update();
    });
    postCategory.listen((val) {
      postCategoryRefreshController.requestRefresh(needCallback: false);
      postCategoryListCallback(val);
      postCategoryRefreshController.refreshCompleted();
    });
    qnaCategory.listen((val) {
      qnaCategoryRefreshController.requestRefresh(needCallback: false);
      qnaCategoryListCallback(val);
      qnaCategoryRefreshController.refreshCompleted();
    });
    postListScrollController.addListener(onPostListScroll);
    qnaListScrollController.addListener(onQnaListScroll);
    commentTextFieldFocus = FocusNode();
  }

  @override
  void onClose() {
    communityMainTabController.dispose();
    bookmarkedListTabController.dispose();
    postActivityListTabController.dispose();
    qnaActivityListTabController.dispose();
    postListScrollController.removeListener(onPostListScroll);
    postListScrollController.dispose();
    qnaListScrollController.removeListener(onQnaListScroll);
    qnaListScrollController.dispose();
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

  void onPostListScroll() {
    if (postListScrollController.position.extentAfter < 300 &&
        !listPageLoading) {
      postListStartIndex.value = postContentList.length;
    }
    if (postListScrollController.offset >= 20) {
      showScrollToTopButton = true; // show the back-to-top button
    } else {
      showScrollToTopButton = false; // hide the back-to-top button
    }
    update();
  }

  void onQnaListScroll() {
    if (qnaListScrollController.position.extentAfter < 300 &&
        !listPageLoading) {
      qnaListStartIndex.value = qnaContentList.length;
    }
    if (qnaListScrollController.offset >= 20) {
      showScrollToTopButton = true; // show the back-to-top button
    } else {
      showScrollToTopButton = false; // hide the back-to-top button
    }
    update();
  }

  void onPostCategoryRefresh() async {
    await postCategoryListCallback(postCategory.value);
    postCategoryRefreshController.refreshCompleted();
  }

  void onQnaCategoryRefresh() async {
    await qnaCategoryListCallback(qnaCategory.value);
    qnaCategoryRefreshController.refreshCompleted();
  }

  void onPostListRefresh() async {
    postListStartIndex.value = 0;
    await postListPageCallback(postListStartIndex.value);
    postListRefreshController.refreshCompleted();
  }

  void onPostListLoadMore() async {
    await postListPageCallback(postListStartIndex.value);
    postListRefreshController.loadComplete();
  }

  void onQnaListRefresh() async {
    qnaListStartIndex.value = 0;
    await qnaListPageCallback(qnaListStartIndex.value);
    qnaListRefreshController.refreshCompleted();
  }

  void onQnaListLoadMore() async {
    await qnaListPageCallback(qnaListStartIndex.value);
    qnaListRefreshController.loadComplete();
  }

  void onPostRefresh() async {
    getPost(postId!);
    getPostCount(postId!);
    getPostComments(postId!);
    postRefreshController.refreshCompleted();
  }

  void onQnaRefresh() async {
    getQna(qnaId!);
    getQnaCount(qnaId!);
    getQnaAnswers(qnaId!);
    qnaRefreshController.refreshCompleted();
  }

  void onQnaAnswerCommentsRefresh() async {
    getQnaAnswerComments(answerId!);
    qnaAnswerCommentsRefreshController.refreshCompleted();
  }

  void onSavedRefresh() async {
    await getSaved();
    savedRefreshController.refreshCompleted();
  }

  void onBookmarkedPostsRefresh() async {
    setLoading(true);
    await getBookmarkedPosts();
    bookmarkedPostsRefreshController.refreshCompleted();
    setLoading(false);
  }

  void onBookmarkedQnasRefresh() async {
    setLoading(true);
    await getBookmarkedQnas();
    bookmarkedQnasRefreshController.refreshCompleted();
    setLoading(false);
  }

  void onSavedUserPostsRefresh() async {
    setLoading(true);
    await getSavedUserPosts();
    savedUserPostsRefreshController.refreshCompleted();
    setLoading(false);
  }

  void onSavedUserCommentedPostsRefresh() async {
    setLoading(true);
    await getSavedUserCommentedPosts();
    savedUserCommentedPostsRefreshController.refreshCompleted();
    setLoading(false);
  }

  void onSavedUserQnasRefresh() async {
    setLoading(true);
    await getSavedUserQnas();
    savedUserQnasRefreshController.refreshCompleted();
    setLoading(false);
  }

  void onSavedUserAnsweredQnasRefresh() async {
    setLoading(true);
    await getSavedUserAnsweredQnas();
    savedUserAnsweredQnasRefreshController.refreshCompleted();
    setLoading(false);
  }

  void setSearchOpen(bool val) {
    searchOpen = val;
    update();
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

  void setPostListInitialLoad(bool val) {
    postListInitialLoad = val;
    update();
  }

  void setQnaListInitialLoad(bool val) {
    qnaListInitialLoad = val;
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

  void updateAnswerNumComments(int? val) {
    answerNumComments = val;
    update();
  }

  void updatePostType(int? val) {
    postType = val;
    update();
  }

  void updateQnaSolved(bool? val) {
    qnaSolved = val;
    update();
  }

  void onPostPageInit(int id, int type) {
    getPost(id);
    getPostCount(id);
    getPostComments(id);
    updatePostId(id);
    updatePostType(type);
  }

  void onQnaPageInit(int id, bool solved) {
    getQna(id);
    getQnaCount(id);
    getQnaAnswers(id);
    updateQnaId(id);
    updateQnaSolved(solved);
  }

  void resetContent() {
    postListStartIndex.value = 0;
    postContentList = [];
    update();
  }

  void resetPostWrite() {
    postTitleTextController.clear();
    postContentTextController.clear();
  }

  void resetQnaWrite() {
    qnaTitleTextController.clear();
    qnaContentTextController.clear();
  }

  void resetQnaAnswerWrite() {
    qnaAnswerContentTextController.clear();
  }

  void addListPage() {
    postListStartIndex++;
  }

  void updateBookmarkCategory(int val) {
    bookmarkCategory = val;
    update();
  }

  void updateBookmarkedPostIndex(int val) {
    if (bookmarkCategory == 0) {
      bookmarkedPostIndex = val;
    }
    update();
  }

  void updateBookmarkedQnaIndex(int val) {
    bookmarkedQnaIndex = val;
    update();
  }

  void updatePostActivityCategory(int val) {
    postActivityCategory = val;
    update();
  }

  void updateUserPostsIndex(int val) {
    userPostsIndex = val;
    update();
  }

  void updateUserCommentedPostsIndex(int val) {
    userCommentedPostsIndex = val;
    update();
  }

  void updateQnaActivityCategory(int val) {
    qnaActivityCategory = val;

    update();
  }

  void updateUserQnasIndex(int val) {
    userQnasIndex = val;
    update();
  }

  void updateUserAnsweredQnasIndex(int val) {
    userAnsweredQnasIndex = val;
    update();
  }

  void updateSelectedAnswerIndex(int? val) {
    selectedAnswerIndex = val!;
    update();
  }

  Future<void> getPostPreview(int? indexNum, int type) async {
    if (indexNum != null) {
      setLoading(true);
      var res = await CommunityApiService.getPostPreview(indexNum, 0, type);
      try {
        postContentList = res;
      } catch (e) {}
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res = await CommunityApiService.getPostPreview(
          20, postListStartIndex.value, type);
      if (postListStartIndex.value == 0) {
        postContentList.clear();
      }
      print(res);
      if (res == false) {
        // postListStartIndex--;
      } else {
        postContentList.addAll(res);
      }
      update();
      setListPageLoading(false);
    }
  }

  Future<void> getQnaPreview(int? indexNum, bool solved) async {
    if (indexNum != null) {
      setLoading(true);
      var res = await CommunityApiService.getQnaPreview(indexNum, 0, solved);
      qnaContentList = res;
      print(qnaContentList);
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res = await CommunityApiService.getQnaPreview(
          20, qnaListStartIndex.value, solved);
      if (qnaListStartIndex.value == 0) {
        qnaContentList.clear();
      }
      print(res);
      if (res == false) {
        // qnaListStartIndex--;
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
      var res = await CommunityApiService.getHotPostPreview(indexNum, 0);
      postContentList = res;
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res = await CommunityApiService.getHotPostPreview(
          20, postListStartIndex.value);
      if (postListStartIndex.value == 0) {
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
      var res = await CommunityApiService.getHotQnaPreview(indexNum, 0);
      try {
        qnaContentList = res;
      } catch (e) {}
      update();
      setLoading(false);
    } else {
      setListPageLoading(true);
      var res = await CommunityApiService.getHotQnaPreview(
          20, qnaListStartIndex.value);
      if (qnaListStartIndex.value == 0) {
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

  Future<void> postPost() async {
    if (postTitleTextController.text != '' &&
        postContentTextController.text != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.postPost(postTitleTextController.text,
          postContentTextController.text, postCategory.value);
      setApiPostLoading(false);
    }
  }

  Future<void> updatePost() async {
    if (postTitleTextController.text != '' &&
        postContentTextController.text != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.updatePost(postId!,
          postTitleTextController.text, postContentTextController.text);
      setApiPostLoading(false);
    }
  }

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

  Future<void> postQna() async {
    if (qnaTitleTextController.text != '' &&
        qnaContentTextController.text != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.postQna(
          qnaTitleTextController.text, qnaContentTextController.text, 1);
      setApiPostLoading(false);
    }
  }

  Future<void> updateQna() async {
    if (qnaTitleTextController.text != '' &&
        qnaContentTextController.text != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.updateQna(qnaId!,
          qnaTitleTextController.text, qnaContentTextController.text, 1);
      setApiPostLoading(false);
    }
  }

  Future<void> postQnaAnswer() async {
    if (qnaAnswerContentTextController.text != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.postQnaAnswer(
          qnaAnswerContentTextController.text, qnaId!);
      setApiPostLoading(false);
    }
  }

  Future<void> updateQnaAnswer(int answerId) async {
    if (qnaAnswerContentTextController.text != '') {
      setApiPostLoading(true);
      var res = await CommunityApiService.updateQnaAnswer(
          answerId, qnaAnswerContentTextController.text);
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
    await CommunityApiService.updatePostSaved(postId!, postSaved);
    // getPostUserStatus(postId, 'saved');
    // getPostCount(postId);
  }

  Future<void> updateQnaCountSaved() async {
    qnaSaved = !qnaSaved;
    qnaCount['count_saved'] += (qnaSaved ? 1 : -1);
    update();
    await CommunityApiService.updateQnaSaved(qnaId!, qnaSaved);
    // getPostUserStatus(postId, 'saved');
    // getPostCount(postId);
  }

  Future<void> updateQnaAnswerCountLikes(int index) async {
    var isLiked = qnaAnswerList[index]['liked'];
    qnaAnswerList[index]['liked'] = !isLiked;
    qnaAnswerList[index]['answer_count']['count_likes'] += (isLiked ? -1 : 1);
    qnaCount['count_likes'] += (isLiked ? -1 : 1);
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
    if (postContentList.isNotEmpty) {
      postContentList.firstWhere(
          (element) => element['post_data']['id'] == postId)['count'] = resData;
    }
    update();
  }

  Future<void> getQnaCount(int qnaId) async {
    var resData = await CommunityApiService.getQnaCount(qnaId);
    qnaCount = resData;
    if (qnaContentList.isNotEmpty) {
      qnaContentList.firstWhere(
          (element) => element['qna_data']['id'] == qnaId)['count'] = resData;
    }
    update();
  }

  Future<void> getSaved() async {
    setLoading(true);
    var resData = await CommunityApiService.getSaved();
    savedData = resData;
    update();
    setLoading(false);
  }

  Future<void> getBookmarkedPosts() async {
    var resData = await CommunityApiService.getBookmarkedPosts();
    bookmarkedPostsList = resData;
    update();
  }

  Future<void> getBookmarkedQnas() async {
    var resData = await CommunityApiService.getBookmarkedQnas();
    bookmarkedQnasList = resData;
    update();
  }

  Future<void> getSavedUserPosts() async {
    var resData = await CommunityApiService.getSavedUserPosts();
    savedUserPostsList = resData;
    update();
  }

  Future<void> getSavedUserCommentedPosts() async {
    var resData = await CommunityApiService.getSavedUserCommentedPosts();
    savedUserCommentedPostsList = resData;
    update();
  }

  Future<void> getSavedUserQnas() async {
    var resData = await CommunityApiService.getSavedUserQnas();
    savedUserQnasList = resData;
    update();
  }

  Future<void> getSavedUserAnsweredQnas() async {
    var resData = await CommunityApiService.getSavedUserAnsweredQnas();
    savedUserAnsweredQnasList = resData;
    update();
  }

  Future<void> postQnaSelectedAnswer(int answerId) async {
    var res = await CommunityApiService.postQnaSelectedAnswer(answerId);
    update();
  }

  Future<dynamic> delete(int id, String category) async {
    var resCode = await CommunityApiService.delete(id, category);
    print(resCode);
    if (resCode == 200) {
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> report(int id, String category) async {
    var resCode = await CommunityApiService.report(id, category);
    print(resCode);
    if (resCode == 200) {
      update();
      return true;
    } else if (resCode == 208) {
      update();
      return 208;
    } else {
      return false;
    }
  }
}
