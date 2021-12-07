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
const String _phoneNumberLabelText = '전화번호';
const String _emailLabelText = '이메일';
const String _privateAccountLabelText = '비공개 계정';
const String _pushAlarmLabelText = '푸시 알림';
const String _signOutLabelText = '로그아웃';
const String _support = '지원';
const String _noticeLabelText = '공지사항';
const String _faqLabelText = 'FAQ';
const String _emailInquiryLabelText = '이메일 문의';
const String _informationSettingsLabelText = '정보';
const String _aboutExonLabelText = 'About EXON';
const String _exonUserGuideLabelText = 'EXON 이용 가이드';
const String _exonUserAgreementLabelText = 'Exon 이용약관';
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
        height: 50,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              labelText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
      );
    }

    Widget _getSettingsMenuItem(Function() onTap, String labelText) {
      return SizedBox(
        height: 50,
        width: context.width,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: Text(
                  labelText,
                  style: const TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
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
                  Divider(color: Colors.grey[200], thickness: 2, height: 2),
                  _getSettingsMenuItem(() => null, _changePasswordLabelText),
                  _getSettingsMenuItem(() => null, _phoneNumberLabelText),
                  _getSettingsMenuItem(() => null, _emailLabelText),
                  _getSettingsMenuItem(() => null, _privateAccountLabelText),
                  _getSettingsMenuItem(() => null, _pushAlarmLabelText),
                  _getSettingsMenuItem(
                      () => _onSignOutPressed(), _signOutLabelText),
                  Divider(color: Colors.grey[200], thickness: 2, height: 2),
                  _getSettingsLabelItem(_support),
                  Divider(color: Colors.grey[200], thickness: 2, height: 2),
                  _getSettingsMenuItem(() => null, _noticeLabelText),
                  _getSettingsMenuItem(() => null, _faqLabelText),
                  _getSettingsMenuItem(() => null, _emailInquiryLabelText),
                  Divider(color: Colors.grey[200], thickness: 2, height: 2),
                  _getSettingsLabelItem(_informationSettingsLabelText),
                  Divider(color: Colors.grey[200], thickness: 2, height: 2),
                  _getSettingsMenuItem(() => null, _aboutExonLabelText),
                  _getSettingsMenuItem(() => null, _exonUserGuideLabelText),
                  _getSettingsMenuItem(() => null, _exonUserAgreementLabelText),
                  _getSettingsMenuItem(
                      () => null, _personalInformationHandlingPolicy),
                  _getSettingsMenuItem(() => null, _appVersion),
                ],
              ),
            ),
          ],
        ),
        GetBuilder<SettingsController>(builder: (_) {
          if (_.loading) {
            return LoadingIndicator();
          } else {
            return horizontalSpacer(0);
          }
        })
      ]),
    );
  }
}
