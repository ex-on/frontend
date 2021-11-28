import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _headerText = '설정';
    const String _account = '계정';
    const String _changePassword = '비밀번호 변경';
    const String _phoneNumber = '전화번호';
    const String _email = '이메일';
    const String _privateAccount = '비공개 계정';
    const String _pushAlarm = '푸시 알람';
    const String _logout = '로그아웃';
    const String _support = '지원';
    const String _notice = '공지사항';
    const String _frequentlyAskedQuestions = 'FAQ';
    const String _emailInquiry = '이메일 문의';
    const String _information = '정보';
    const String _aboutExon = 'About EXON';
    const String _exonUsingGuide = 'EXON 이용 가이드';
    const String _exonUserAgreement = 'Exon 이용약관';
    const String _personalInformationHandlingPolicy = '개인정보처리방침';
    const String _appVersion = '앱 버전';

    return Scaffold(
      body: Column(
        children: [
          Header(
            onPressed: () {
              Get.back();
            },
            title: _headerText,
          ),
          Divider(color: Colors.grey[300], thickness: 2),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                const Text(
                  _account,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Divider(color: Colors.grey[200], thickness: 2),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: context.width,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(_changePassword,
                                style: TextStyle(fontSize: 18))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _phoneNumber,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _email,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _privateAccount,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _pushAlarm,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _logout,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[200], thickness: 2),
                verticalSpacer(8),
                const Text(
                  _support,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                verticalSpacer(8),
                Divider(color: Colors.grey[200], thickness: 2),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _notice,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _frequentlyAskedQuestions,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _emailInquiry,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[200], thickness: 2),
                verticalSpacer(8),
                const Text(
                  _information,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                verticalSpacer(8),
                Divider(color: Colors.grey[200], thickness: 2),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _aboutExon,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _exonUsingGuide,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _exonUserAgreement,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _personalInformationHandlingPolicy,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 40,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizontalSpacer(25),
                            const Text(
                              _appVersion,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
