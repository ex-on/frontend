import 'package:exon_app/core/services/api_service.dart';

class CommunityApiService extends ApiService {
  static Future<dynamic> getPostPreview(
      int indexNum, int startIndex, int type) async {
    String path = '/community/post_list';

    Map<String, dynamic> parameters = {
      'index_num': indexNum,
      // 'page_num': pageNum,
      'start_index': startIndex,
      'type': type,
    };

    try {
      var res = await ApiService.get(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getHotPostPreview(int indexNum, int startIndex) async {
    String path = '/community/post_list/hot';

    Map<String, dynamic> parameters = {
      'index_num': indexNum,
      'start_index': startIndex,
    };

    try {
      var res = await ApiService.get(path, parameters);
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Post API
  static Future<dynamic> getPost(int postId) async {
    String path = '/community/getpost';

    Map<String, dynamic> parameters = {
      'post_id': postId,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      // return false;
    }
  }

  static Future<dynamic> getQna(int qnaId) async {
    String path = '/community/getQna';

    Map<String, dynamic> parameters = {
      'qna_id': qnaId,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getPostComments(int postId) async {
    String path = '/community/getpostcomments';

    Map<String, dynamic> parameters = {
      'post_id': postId,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getQnaAnswers(int qnaId) async {
    String path = '/community/getQnaAnswers';

    Map<String, dynamic> parameters = {
      'qna_id': qnaId,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getQnaAnswerComments(int answerId) async {
    String path = '/community/get_qna_answer_comments';

    Map<String, dynamic> parameters = {
      'answer_id': answerId,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postPost(
      String title, String content, int type) async {
    String path = '/community/post';

    Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'type': type,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postPostComment(int postId, String content) async {
    String path = '/community/postcomment';

    Map<String, dynamic> data = {
      'post_id': postId,
      'content': content,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postPostCommentReply(
      int postId, int postCommentId, String content) async {
    String path = '/community/postcommentreply';

    Map<String, dynamic> data = {
      'post_id': postId,
      'post_comment_id': postCommentId,
      'content': content,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postQna(String title, String content, int type) async {
    String path = '/community/qna';

    Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'type': type,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postQnaAnswer(
     String content, int qnaId) async {
    String path = '/community/qna_answer';

    Map<String, dynamic> data = {
      'qna_id': qnaId,
      'content': content,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postQnaAnswerComment(
      int answerId, String content) async {
    String path = '/community/qna_answer_comment';

    Map<String, dynamic> data = {
      'answer_id': answerId,
      'content': content,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> postQnaAnswerCommentReply(
      int answerId, int answerCommentId, String content) async {
    String path = '/community/qna_answer_comment_reply';

    Map<String, dynamic> data = {
      'answer_id': answerId,
      'qna_answer_comment_id': answerCommentId,
      'content': content,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getPostUserStatus(int postId, String extent) async {
    String path = '/community/get_post_user_status';

    Map<String, dynamic> parameters = {
      'post_id': postId,
      'extent': extent,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getQnaUserStatus(int qnaId) async {
    String path = '/community/get_qna_user_status';

    Map<String, dynamic> parameters = {
      'qna_id': qnaId,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getPostCount(int postId) async {
    String path = '/community/get_post_count';

    Map<String, dynamic> parameters = {
      'post_id': postId,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getQnaCount(int qnaId) async {
    String path = '/community/get_qna_count';

    Map<String, dynamic> parameters = {
      'qna_id': qnaId,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updatePostLikes(int postId, bool add) async {
    String path = '/community/update_post_count/likes';

    Map<String, dynamic> data = {
      'post_id': postId,
      'add': add,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updatePostCommentLikes(
      int postCommentId, bool add) async {
    String path = '/community/update_post_comment_count/likes';

    Map<String, dynamic> data = {
      'post_comment_id': postCommentId,
      'add': add,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updatePostCommentReplyLikes(
      int postCommentReplyId, bool add) async {
    String path = '/community/update_post_comment_reply_count/likes';

    Map<String, dynamic> data = {
      'post_comment_reply_id': postCommentReplyId,
      'add': add,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updatePostSaved(int postId, bool add) async {
    String path = '/community/update_post_count/saved';

    Map<String, dynamic> data = {
      'post_id': postId,
      'add': add,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updateQnaSaved(int qnaId, bool add) async {
    String path = '/community/update_qna_count/saved';

    Map<String, dynamic> data = {
      'qna_id': qnaId,
      'add': add,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updateQnaAnswerLikes(int qnaAnswerId, bool add) async {
    String path = '/community/update_qna_answer_count/likes';

    Map<String, dynamic> data = {
      'qna_answer_id': qnaAnswerId,
      'add': add,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> updateQnaAnswerCommentLikes(
      int qnaAnswerCommentId, bool add) async {
    String path = '/community/update_qna_answer_comment_count/likes';

    Map<String, dynamic> data = {
      'qna_answer_comment_id': qnaAnswerCommentId,
      'add': add,
    };

    try {
      var res = await ApiService.post(path, data);
      return res.statusCode;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getUserRecentCommunityData() async {
    String path = '/community/user_recent_community';

    try {
      var res = await ApiService.get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getSaved() async {
    String path = '/community/saved';

    try {
      var res = await ApiService.get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Qna API
  static Future<dynamic> getQnaPreview(
      int indexNum, int startIndex, int type) async {
    String path = '/community/qna_list';

    Map<String, dynamic> parameters = {
      'index_num': indexNum,
      'start_index': startIndex,
      'type': type,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<dynamic> getHotQnaPreview(int indexNum, int startIndex) async {
    String path = '/community/qna_list/hot';

    Map<String, dynamic> parameters = {
      'index_num': indexNum,
      'start_index': startIndex,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
