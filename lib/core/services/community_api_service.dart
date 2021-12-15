import 'package:exon_app/core/services/api_service.dart';

class CommunityApiService extends ApiService {
  static Future<dynamic> getPostPreview(
      int indexNum, int pageNum, int type) async {
    String path = '/community/postmain';

    Map<String, dynamic> parameters = {
      'index_num': indexNum,
      'page_num': pageNum,
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

  static Future<dynamic> getHotBoardPreview(int indexNum, int pageNum) async {
    String path = '/community/hotboardmain';

    Map<String, dynamic> parameters = {
      'index_num': indexNum,
      'page_num': pageNum,
    };

    try {
      var res = await ApiService.get(path, parameters);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }

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

  static Future<dynamic> getSavedPosts() async {
    String path = '/community/get_saved_posts';

    try {
      var res = await ApiService.get(path, null);
      return res.data;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
