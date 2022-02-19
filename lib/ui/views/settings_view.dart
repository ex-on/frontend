import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/settings_controller.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String _headerText = '설정';
const String _accountSettingsLabelText = '계정';
const String _changePasswordLabelText = '비밀번호 변경';
const String _usernameLabelText = '닉네임';
const String _emailLabelText = '이메일';
const String _accountPrivacyLabelText = '공개 여부 설정';
const String _pushAlarmLabelText = '푸시 알림';
const String _signOutLabelText = '로그아웃';
const String _communicateSettingsLabelText = 'EXON과 소통하기';
const String _reviewLabelText = '간단하게 리뷰 남기기';
const String _instagramLabelText = 'EXON 이야기 팔로우';
const String _featureFeedbackLabelText = '업데이트 기능 제안하기';
const String _informationSettingsLabelText = '정보';
const String _aboutExonLabelText = 'About EXON';
const String _exonUserAgreementLabelText = '이용약관';
const String _personalInformationHandlingPolicy = '개인정보처리방침';
const String _appVersion = '앱 버전';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onBackPressed() {
      Get.back();
    }

    void _onTap() {}

    void _onSignOutPressed() async {
      var signOutRes = await SettingsController.to.signOut();
      if (signOutRes) {
        Get.offAllNamed('/');
      }
    }

    Widget _getSettingsLabelItem(String labelText) {
      return SizedBox(
        height: 40,
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

    Widget _getSettingsMenuItem(Function() onTap, String labelText,
        {Widget trailing = const SizedBox()}) {
      return SizedBox(
        height: 40,
        width: context.width,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  labelText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              trailing,
            ],
          ),
        ),
      );
    }

    Widget _divider =
        Divider(color: Colors.grey[200], thickness: 2, height: 16);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              Header(
                onPressed: _onBackPressed,
                title: _headerText,
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    _getSettingsLabelItem(_accountSettingsLabelText),
                    _divider,
                    _getSettingsMenuItem(() => null, _usernameLabelText),
                    _getSettingsMenuItem(() => null, _emailLabelText),
                    _getSettingsMenuItem(() => null, _changePasswordLabelText),
                    _getSettingsMenuItem(() => null, _accountPrivacyLabelText),
                    _getSettingsMenuItem(() => null, _pushAlarmLabelText),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child:
                          _getSettingsLabelItem(_communicateSettingsLabelText),
                    ),
                    _divider,
                    _getSettingsMenuItem(
                      () => null,
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
                      () => null,
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
                      () => null,
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
                      child:
                          _getSettingsLabelItem(_informationSettingsLabelText),
                    ),
                    _divider,
                    _getSettingsMenuItem(
                        () => null, _exonUserAgreementLabelText),
                    _getSettingsMenuItem(
                        () => null, _personalInformationHandlingPolicy),
                    _getSettingsMenuItem(() => null, _appVersion),
                    _getSettingsMenuItem(
                        () => _onSignOutPressed(), _signOutLabelText),
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
        ]),
      ),
    );
  }
}
