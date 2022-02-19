import 'package:exon_app/core/services/user_api_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileController extends GetxController
    with SingleGetTickerProviderMixin {
  static ProfileController to = Get.find();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool loading = false;
  int? totalQnaAnswerNum;
  int? totalPostNum;
  int currentPostIndex = 0;
  int currentQnaIndex = 0;
  Map<String, dynamic> profileData = {};

  void onRefresh() async {
    await getProfileStats();
    refreshController.refreshCompleted();
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

  Future<void> getProfileStats() async {
    setLoading(true);
    var resData = await UserApiService.getProfileStats();
    if (resData != null) {
      profileData = resData;
    }
    setLoading(false);
  }
}
