import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/settings_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/url_launcher.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String _headerText = '설정';
const String _accountSettingsLabelText = '계정';
const String _changePasswordLabelText = '비밀번호 변경';
const String _usernameLabelText = '닉네임';
const String _emailLabelText = '이메일';
const String _pushNotificationLabelText = '푸시 알림';
const String _signOutLabelText = '로그아웃';
const String _communicateLabelText = 'EXON과 소통하기';
const String _reviewLabelText = '간단하게 리뷰 남기기';
const String _instagramLabelText = 'EXON 이야기 팔로우';
const String _featureFeedbackLabelText = '업데이트 기능 제안하기';
const String _informationSettingsLabelText = '정보';
const String _privacyAllLabelText = '활동 내역 전체 공개';
const String _privacyCommunityLabelText = '커뮤니티 활동 공개';
const String _privacyPhysicalDataLabelText = '신체 기록 공개';
// const String _exonUserAgreementLabelText = '이용약관';
const String _privacyPolicyLabelText = '개인정보처리방침';
const String _appVersion = '앱 버전';

const String _privacyPolicyUrl = endPointUrl + '/user/policy/privacy';
const String _instagramUrl = 'https://www.instagram.com/official_exon/';
const String _nativeInstagramUrl = "instagram://user?username=official_exon";
const String _feedbackUrl = 'https://instagram.com/';
const String _nativeFeedbackUrl = "instagram://user?username=official_exon";
const String _appStoreId = '';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onBackPressed() {
      Get.back();
    }

    void _onUpdateUsernamePressed() {
      Get.toNamed('/settings/username');
    }

    void _onUpdatePasswordPressed() {
      Get.toNamed('/settings/password');
    }

    void _onPushNotificationPressed() {
      SettingsController.to.getUserNotiSettings();
      Get.toNamed('/settings/push_notification');
    }

    void _onStoreReviewPressed() {
      controller.inAppReview.openStoreListing(appStoreId: _appStoreId);
    }

    void _onInstagramPressed() {
      UrlLauncher.launchInApp(_instagramUrl, nativeUrl: _nativeInstagramUrl);
    }

    void _onFeedbackPressed() {
      UrlLauncher.launchInApp(_feedbackUrl, nativeUrl: _nativeFeedbackUrl);
    }

    void _onPrivacyPolicyPressed() {
      UrlLauncher.launchInApp(_privacyPolicyUrl);
    }

    void _onSignOutPressed() async {
      var signOutRes = await SettingsController.to.signOut();
      if (signOutRes) {
        Get.offAllNamed('/');
      }
    }

    Widget _getSettingsLabelItem(String labelText) {
      return SizedBox(
        height: 50,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              labelText,
              style: const TextStyle(
                color: clearBlackColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
    }

    Widget _getSettingsMenuItem(
      Function()? onTap,
      String labelText, {
      Widget trailing = const SizedBox(),
      double leftPadding = 0,
      Color textColor = clearBlackColor,
    }) {
      return SizedBox(
        height: 50,
        width: context.width,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: leftPadding),
                  child: Text(
                    labelText,
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      );
    }

    Widget _divider = Divider(
      color: Colors.grey[200],
      thickness: 2,
      height: 2,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Header(
                  onPressed: _onBackPressed,
                  title: _headerText,
                ),
                Expanded(
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 40),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      _getSettingsLabelItem(_accountSettingsLabelText),
                      _divider,
                      _getSettingsMenuItem(
                        null,
                        _usernameLabelText,
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GetBuilder<AuthController>(
                              builder: (_) {
                                if (_.userInfo.isNotEmpty) {
                                  return Text(activityLevelIntToStr[
                                          _.userInfo['activity_level']]! +
                                      ' ' +
                                      _.userInfo['username']);
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                            IconButton(
                              onPressed: _onUpdateUsernamePressed,
                              splashRadius: 20,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: lightGrayColor,
                                size: 19,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _getSettingsMenuItem(
                        null,
                        _emailLabelText,
                        trailing: Row(
                          children: [
                            () {
                              switch (
                                  AuthController.to.userInfo['auth_provider']) {
                                case 1:
                                  return const KakaoIcon(
                                    width: 18,
                                    height: 18,
                                  );
                                case 2:
                                  return const GoogleIcon(
                                    width: 18,
                                    height: 18,
                                  );
                                case 3:
                                  return const FacebookColorIcon(
                                    width: 18,
                                    height: 18,
                                  );
                                default:
                                  return const SizedBox.shrink();
                              }
                            }(),
                            horizontalSpacer(10),
                            Text(
                              AuthController.to.userInfo['email'],
                            ),
                          ],
                        ),
                      ),
                      _getSettingsMenuItem(
                          AuthController.to.userInfo['auth_provider'] == 0
                              ? _onUpdatePasswordPressed
                              : null,
                          _changePasswordLabelText,
                          textColor:
                              AuthController.to.userInfo['auth_provider'] == 0
                                  ? clearBlackColor
                                  : lightGrayColor),
                      _getSettingsMenuItem(
                        null,
                        _privacyAllLabelText,
                        trailing: GetBuilder<SettingsController>(
                          builder: (_) {
                            return Transform.scale(
                              scale: 0.9,
                              child: CupertinoSwitch(
                                value: _.communityActivityOpen &&
                                    _.physicalDataOpen,
                                onChanged: (bool val) => _.updatePrivacyAll(),
                                activeColor: brightPrimaryColor,
                                thumbColor: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      _getSettingsMenuItem(
                        null,
                        _privacyCommunityLabelText,
                        leftPadding: 30,
                        trailing: GetBuilder<SettingsController>(
                          builder: (_) {
                            return Transform.scale(
                              scale: 0.9,
                              child: CupertinoSwitch(
                                value: _.communityActivityOpen,
                                onChanged: (bool val) =>
                                    _.updatePrivacyCommunity(),
                                activeColor: brightPrimaryColor,
                                thumbColor: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      _getSettingsMenuItem(
                        null,
                        _privacyPhysicalDataLabelText,
                        leftPadding: 30,
                        trailing: GetBuilder<SettingsController>(
                          builder: (_) {
                            return Transform.scale(
                              scale: 0.9,
                              child: CupertinoSwitch(
                                value: _.physicalDataOpen,
                                onChanged: (bool val) =>
                                    _.updatePrivacyPhysicalData(),
                                activeColor: brightPrimaryColor,
                                thumbColor: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      _getSettingsMenuItem(
                        _onPushNotificationPressed,
                        _pushNotificationLabelText,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _getSettingsLabelItem(_communicateLabelText),
                      ),
                      _divider,
                      _getSettingsMenuItem(
                        _onStoreReviewPressed,
                        _reviewLabelText,
                        trailing: const Padding(
                          padding: EdgeInsets.only(right: 25),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                        ),
                      ),
                      _getSettingsMenuItem(
                        _onInstagramPressed,
                        _instagramLabelText,
                        trailing: const Padding(
                          padding: EdgeInsets.only(right: 25),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                        ),
                      ),
                      _getSettingsMenuItem(
                        _onFeedbackPressed,
                        _featureFeedbackLabelText,
                        trailing: const Padding(
                          padding: EdgeInsets.only(right: 25),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _getSettingsLabelItem(
                            _informationSettingsLabelText),
                      ),
                      _divider,
                      // _getSettingsMenuItem(
                      //     () => null, _exonUserAgreementLabelText),
                      _getSettingsMenuItem(
                          _onPrivacyPolicyPressed, _privacyPolicyLabelText),
                      _getSettingsMenuItem(
                        null,
                        _appVersion,
                        trailing: GetBuilder<SettingsController>(
                          builder: (_) {
                            return Text(
                              _.appVersion + '+' + _.buildNumber,
                            );
                          },
                        ),
                      ),
                      _getSettingsMenuItem(
                        () => _onSignOutPressed(),
                        _signOutLabelText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GetBuilder<SettingsController>(builder: (_) {
              if (_.loading) {
                return const LoadingIndicator();
              } else {
                return horizontalSpacer(0);
              }
            })
          ],
        ),
      ),
    );
  }
}
