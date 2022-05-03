import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/connection_controller.dart';
import 'package:exon_app/core/services/user_api_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ProfileController to = Get.find();
  RefreshController refreshController = RefreshController();
  bool loading = false;
  int? totalQnaAnswerNum;
  int? totalPostNum;
  int currentPostIndex = 0;
  int currentQnaIndex = 0;
  Map<String, dynamic> myProfileData = {};
  Map<String, dynamic> userProfileData = {};

  void onRefresh() async {
    await AuthController.to.getUserInfo();
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

  void onUserProfileTap(String username) {
    Get.toNamed('/profile');
    getUserProfileStats(username);
  }

  void resetUserProfileData() {
    userProfileData = {};
  }

  Future<void> getProfileStats() async {
    ConnectionController.to.updateRefreshCategory(10);
    setLoading(true);
    var resData = await UserApiService.getProfileStats();
    if (resData != null) {
      myProfileData = resData;
    }
    setLoading(false);
  }

  Future<void> getUserProfileStats(String username) async {
    setLoading(true);
    var resData = await UserApiService.getUserProfileStats(username);
    if (resData != null) {
      userProfileData = resData;
    }
    setLoading(false);
  }
}
