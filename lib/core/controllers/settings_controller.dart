import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/core/services/notification_api_service.dart';
import 'package:exon_app/core/services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  static SettingsController to = Get.find();
  final authFormKey = GlobalKey<FormState>();
  final updateFormKey = GlobalKey<FormState>();
  final InAppReview inAppReview = InAppReview.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordAuthorizeController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  bool loading = false;
  bool communityActivityOpen = false;
  bool physicalDataOpen = false;
  bool isUsernameAvailable = true;
  bool isUsernameValid = false;
  bool isAuthorized = false;
  bool passwordAuthorizeVisible = false;
  bool passwordInputVisible = false;
  bool passwordCheckVisible = false;
  bool passwordInvalidError = false;
  bool isPasswordRegexValid = false;
  bool isPasswordFormValid = false;
  bool passwordCheckInput = false;
  // 푸시 알림 설정
  // 프로틴 획득 알림
  bool exerciseAttendanceNoti = false; // 0
  bool dailyExerciseCompleteNoti = false; // 1
  bool weeklyExerciseProteinNoti = false; // 2
  bool hotPostNoti = false; // 3
  bool hotQnaNoti = false; // 4
  bool qnaBestAnswerNoti = false; // 5
  bool qnaSelectedAnswerNoti = false; // 6
  // 등급업 알림
  bool activityLevelUpNoti = false; // 7
  bool get proteinNoti =>
      exerciseAttendanceNoti &&
      dailyExerciseCompleteNoti &&
      weeklyExerciseProteinNoti &&
      hotPostNoti &&
      hotQnaNoti &&
      qnaBestAnswerNoti &&
      qnaSelectedAnswerNoti &&
      activityLevelUpNoti;
  // 게시판 알림
  bool get postNoti => postCommentNoti && postReplyNoti;
  bool postCommentNoti = false; // 8
  bool postReplyNoti = false; // 9
  // Q&A 알림
  bool get qnaNoti => qnaAnswerNoti && qnaCommentNoti && qnaReplyNoti;
  bool qnaAnswerNoti = false; // 10
  bool qnaCommentNoti = false; // 11
  bool qnaReplyNoti = false; // 12
  // 기타 알림
  bool generalNoti = false; // 13

  int updatePasswordPage = 0;

  late String appVersion;
  late String buildNumber;

  @override
  void onInit() async {
    super.onInit();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    // getProfilePrivacy();
    // getUserNotiSettings();
  }

  String? usernameValidator(String? text) {
    const pattern =
        r'^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣._\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]]+(?<![_.])$';
    final regExp = RegExp(pattern);
    if (text == null || text.isEmpty) {
      return '닉네임을 입력해주세요';
    } else if (text.length < 3) {
      return '3글자 이상 입력해주세요';
    } else if (text.length > 20) {
      return '20자 이내로 입력해주세요';
    } else if (!regExp.hasMatch(text)) {
      return '닉네임 형식이 올바르지 않습니다';
    } else {
      if (!isUsernameAvailable) {
        if (usernameController.text != AuthController.to.userInfo['username'] &&
            !loading) {
          return '이미 존재하는 닉네임이에요';
        } else {
          return '현재 닉네임과 동일해요';
        }
      } else {
        return null;
      }
    }
  }

  String? passwordAuthorizeValidator(String? text) {
    const pattern = r'^([A-Za-z0-9!@#\$&*~]){8,}$';
    final regExp = RegExp(pattern);
    if (text == null || text.isEmpty) {
      return '비밀번호를 입력해주세요';
    } else if (text.length < 8) {
      return '비밀번호가 너무 짧아요';
    }
    if (!regExp.hasMatch(text)) {
      return '비밀번호 형식이 올바르지 않아요';
    } else if (passwordInvalidError) {
      return '비밀번호가 일치하지 않아요';
    } else {
      return null;
    }
  }

  String? updatePasswordInputValidator(String? text) {
    const pattern = r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regExp = RegExp(pattern);
    print(passwordAuthorizeController.text);
    if (text == null || text.isEmpty) {
      return '비밀번호를 입력해주세요';
    } else if (text.length < 8) {
      return '8자 이상의 비밀번호를 입력해주세요';
    }
    if (!regExp.hasMatch(text)) {
      return '비밀번호 형식이 올바르지 않아요';
    } else if (text == passwordAuthorizeController.text) {
      return '현재 비밀번호와 동일해요';
    } else {
      return null;
    }
  }

  String? updatePasswordCheckValidator(String? text) {
    print('yo');
    if (text != passwordInputController.text && passwordCheckInput) {
      return '비밀번호가 일치하지 않아요';
    } else {
      return null;
    }
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void passwordJumpToPage(int val) {
    updatePasswordPage = val;
    update();
  }

  void togglePasswordAuthorizeVisibility() {
    passwordAuthorizeVisible = !passwordAuthorizeVisible;
    update();
  }

  void togglePasswordInputVisibility() {
    passwordInputVisible = !passwordInputVisible;
    update();
  }

  void togglePasswordCheckVisibility() {
    passwordCheckVisible = !passwordCheckVisible;
    update();
  }

  void setPasswordInvalidError(bool val) {
    passwordInvalidError = val;
    update();
  }

  void setPasswordRegexValid(bool val) {
    isPasswordRegexValid = val;
    update();
  }

  void setPasswordFormValid(bool val) {
    isPasswordFormValid = val;
    update();
  }

  void resetPasswordAuthorize() {
    passwordAuthorizeController.clear();
    isAuthorized = false;
    passwordAuthorizeVisible = false;
    isPasswordRegexValid = false;
    passwordInvalidError = false;
  }

  void resetPasswordUpdate() {
    passwordInputController.clear();
    passwordCheckController.clear();
    passwordInputVisible = false;
    passwordCheckVisible = false;
    isPasswordFormValid = false;
    passwordCheckInput = false;
    updatePasswordPage = 0;
  }

  void setUsernameValid(bool val) {
    isUsernameValid = val;
    update();
  }

  void onUsernameChanged(String text) async {
    if (usernameController.text.length >= 3 &&
        usernameController.text.length <= 20) {
      setLoading(true);
      await checkAvailableUsername();
      setLoading(false);
    }
    if (authFormKey.currentState != null) {
      bool isValid = authFormKey.currentState!.validate();
      setUsernameValid(isValid);
    }
  }

  void resetUsername() {
    usernameController.clear();
  }

  void updatePrivacyAll() async {
    bool _allOpen = communityActivityOpen && physicalDataOpen;
    if (_allOpen) {
      communityActivityOpen = false;
      physicalDataOpen = false;
    } else {
      communityActivityOpen = true;
      physicalDataOpen = true;
    }
    update();
    await UserApiService.postProfilePrivacy(0);
  }

  void updatePrivacyCommunity() async {
    communityActivityOpen = !communityActivityOpen;
    update();
    await UserApiService.postProfilePrivacy(1);
  }

  void updatePrivacyPhysicalData() async {
    physicalDataOpen = !physicalDataOpen;
    update();
    await UserApiService.postProfilePrivacy(2);
  }

  // 푸시 알림
  void updateProteinNotiAll() {
    if (!proteinNoti) {
      exerciseAttendanceNoti = true;
      dailyExerciseCompleteNoti = true;
      weeklyExerciseProteinNoti = true;
      hotPostNoti = true;
      hotQnaNoti = true;
      qnaBestAnswerNoti = true;
      qnaSelectedAnswerNoti = true;
      activityLevelUpNoti = true;
      NotificationApiService.postUserNotiSettings(-1, true);
    } else {
      exerciseAttendanceNoti = false;
      dailyExerciseCompleteNoti = false;
      weeklyExerciseProteinNoti = false;
      hotPostNoti = false;
      hotQnaNoti = false;
      qnaBestAnswerNoti = false;
      qnaSelectedAnswerNoti = false;
      activityLevelUpNoti = false;
      NotificationApiService.postUserNotiSettings(-1, false);
    }
    update();
  }

  void updateExerciseAttendanceNoti() {
    exerciseAttendanceNoti = !exerciseAttendanceNoti;
    NotificationApiService.postUserNotiSettings(0, exerciseAttendanceNoti);
    update();
  }

  void updateDailyExerciseCompleteNoti() {
    dailyExerciseCompleteNoti = !dailyExerciseCompleteNoti;
    NotificationApiService.postUserNotiSettings(1, exerciseAttendanceNoti);
    update();
  }

  void updateWeeklyExerciseProteinNoti() {
    weeklyExerciseProteinNoti = !weeklyExerciseProteinNoti;
    NotificationApiService.postUserNotiSettings(2, exerciseAttendanceNoti);
    update();
  }

  void updateHotPostNoti() {
    hotPostNoti = !hotPostNoti;
    NotificationApiService.postUserNotiSettings(3, exerciseAttendanceNoti);
    update();
  }

  void updateHotQnaNoti() {
    hotQnaNoti = !hotQnaNoti;
    NotificationApiService.postUserNotiSettings(4, exerciseAttendanceNoti);
    update();
  }

  void updateQnaBestAnswerNoti() {
    qnaBestAnswerNoti = !qnaBestAnswerNoti;
    NotificationApiService.postUserNotiSettings(5, exerciseAttendanceNoti);
    update();
  }

  void updateQnaSelectedAnswerNoti() {
    qnaSelectedAnswerNoti = !qnaSelectedAnswerNoti;
    NotificationApiService.postUserNotiSettings(6, exerciseAttendanceNoti);
    update();
  }

  void updateActivityLevelUpNoti() {
    activityLevelUpNoti = !activityLevelUpNoti;
    NotificationApiService.postUserNotiSettings(7, exerciseAttendanceNoti);
    update();
  }

  void updatePostNotiAll() {
    if (!postNoti) {
      postCommentNoti = true;
      postReplyNoti = true;
      NotificationApiService.postUserNotiSettings(-2, true);
    } else {
      postCommentNoti = false;
      postReplyNoti = false;
      NotificationApiService.postUserNotiSettings(-2, false);
    }
    update();
  }

  void updatePostCommentNoti() {
    postCommentNoti = !postCommentNoti;
    NotificationApiService.postUserNotiSettings(8, postCommentNoti);
    update();
  }

  void updatePostReplyNoti() {
    postReplyNoti = !postReplyNoti;
    NotificationApiService.postUserNotiSettings(9, postReplyNoti);
    update();
  }

  void updateQnaNotiAll() {
    if (!qnaNoti) {
      qnaAnswerNoti = true;
      qnaCommentNoti = true;
      qnaReplyNoti = true;
      NotificationApiService.postUserNotiSettings(-3, true);
    } else {
      qnaAnswerNoti = false;
      qnaCommentNoti = false;
      qnaReplyNoti = false;
      NotificationApiService.postUserNotiSettings(-3, false);
    }
    update();
  }

  void updateQnaAnswerNoti() {
    qnaAnswerNoti = !qnaAnswerNoti;
    NotificationApiService.postUserNotiSettings(10, qnaAnswerNoti);
    update();
  }

  void updateQnaCommentNoti() {
    qnaCommentNoti = !qnaCommentNoti;
    NotificationApiService.postUserNotiSettings(11, qnaCommentNoti);
    update();
  }

  void updateQnaReplyNoti() {
    qnaReplyNoti = !qnaReplyNoti;
    print(qnaReplyNoti);
    NotificationApiService.postUserNotiSettings(12, qnaReplyNoti);
    update();
  }

  void updateGeneralNoti() {
    generalNoti = !generalNoti;
    NotificationApiService.postUserNotiSettings(13, generalNoti);
    update();
  }

  Future<void> checkAvailableUsername() async {
    isUsernameAvailable =
        await UserApiService.checkUsernameAvailable(usernameController.text);
    update();
  }

  Future<bool> updateUsername() async {
    setLoading(true);
    var res = await UserApiService.updateUsername(usernameController.text);
    setLoading(false);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkPassword() async {
    var valid = await AmplifyService.authenticateUser(
        AuthController.to.userInfo['email'], passwordAuthorizeController.text);
    setPasswordInvalidError(!valid);
    return valid;
  }

  Future<bool> updatePassword() async {
    var success = await AmplifyService.updateCognitoPassword(
        passwordAuthorizeController.text, passwordInputController.text);

    return success;
  }

  Future<void> getProfilePrivacy() async {
    var res = await UserApiService.getProfilePrivacy();
    switch (res) {
      case 0:
        communityActivityOpen = true;
        physicalDataOpen = true;
        break;
      case 1:
        communityActivityOpen = true;
        physicalDataOpen = false;
        break;
      case 2:
        communityActivityOpen = false;
        physicalDataOpen = true;
        break;
      case 3:
        communityActivityOpen = false;
        physicalDataOpen = false;
        break;
      default:
        break;
    }
    update();
  }

  Future<void> getUserNotiSettings() async {
    var notiSettings = await NotificationApiService.getUserNotiSettings();
    exerciseAttendanceNoti = notiSettings[0];
    dailyExerciseCompleteNoti = notiSettings[1];
    weeklyExerciseProteinNoti = notiSettings[2];
    hotPostNoti = notiSettings[3];
    hotQnaNoti = notiSettings[4];
    qnaBestAnswerNoti = notiSettings[5];
    qnaSelectedAnswerNoti = notiSettings[6];
    activityLevelUpNoti = notiSettings[7];
    postCommentNoti = notiSettings[8];
    postReplyNoti = notiSettings[9];
    qnaAnswerNoti = notiSettings[10];
    qnaCommentNoti = notiSettings[11];
    qnaReplyNoti = notiSettings[12];
    generalNoti = notiSettings[13];
    update();
  }

  Future<bool> signOut() async {
    setLoading(true);
    var signOutRes = await AmplifyService.signOut(
        RegisterController.to.emailController.text);
    AuthController.to.reset();
    HomeNavigationController.to.reset();
    setLoading(false);
    return signOutRes;
  }
}
