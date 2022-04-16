import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/settings_controller.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PushNotificationsSettingsPage extends GetView<SettingsController> {
  const PushNotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _getPrimaryItem(
      String labelText,
      bool value,
      Function() onChanged,
    ) {
      return SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18,
            right: 24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labelText,
                style: const TextStyle(
                  color: clearBlackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              GetBuilder<SettingsController>(
                builder: (_) {
                  return Transform.scale(
                    scale: 0.9,
                    alignment: Alignment.centerRight,
                    child: CupertinoSwitch(
                      value: value,
                      onChanged: (bool val) => onChanged(),
                      activeColor: brightPrimaryColor,
                      thumbColor: Colors.white,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    }

    Widget _getSecondaryItem(
      String labelText,
      bool value,
      Function() onChanged,
    ) {
      return SizedBox(
        height: 50,
        width: context.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 54, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labelText,
                style: const TextStyle(fontSize: 16, color: clearBlackColor),
              ),
              GetBuilder<SettingsController>(
                builder: (_) {
                  return Transform.scale(
                    scale: 0.9,
                    alignment: Alignment.centerRight,
                    child: CupertinoSwitch(
                      value: value,
                      onChanged: (bool val) => onChanged(),
                      activeColor: brightPrimaryColor,
                      thumbColor: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    void _onBackPressed() {
      Get.back();
    }

    Widget _divider = Divider(
      color: Colors.grey[200],
      thickness: 2,
      height: 2,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<SettingsController>(
          builder: (_) {
            return SizedBox(
              height: context.height * 0.92,
              child: Column(
                children: [
                  Header(
                      onPressed: _onBackPressed,
                      title: '푸시 알림 설정',
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      )),
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        _getPrimaryItem(
                            '프로틴 획득 알림', _.proteinNoti, _.updateProteinNotiAll),
                        _divider,
                        _getSecondaryItem(
                          '출석 (일일 첫 운동 기록)',
                          _.exerciseAttendanceNoti,
                          _.updateExerciseAttendanceNoti,
                        ),
                        _getSecondaryItem(
                          '일일 운동 계획 모두 수행',
                          _.dailyExerciseCompleteNoti,
                          _.updateDailyExerciseCompleteNoti,
                        ),
                        _getSecondaryItem(
                          '주간 운동 정산',
                          _.weeklyExerciseProteinNoti,
                          _.updateWeeklyExerciseProteinNoti,
                        ),
                        _getSecondaryItem(
                          'HOT 게시물 선정',
                          _.hotPostNoti,
                          _.updateHotPostNoti,
                        ),
                        _getSecondaryItem(
                          'HOT Q&A 선정',
                          _.hotQnaNoti,
                          _.updateHotQnaNoti,
                        ),
                        _getSecondaryItem(
                          'Q&A 인기 답변 선정',
                          _.qnaBestAnswerNoti,
                          _.updateQnaBestAnswerNoti,
                        ),
                        _getSecondaryItem(
                          'Q&A 질문자 채택',
                          _.qnaSelectedAnswerNoti,
                          _.updateQnaSelectedAnswerNoti,
                        ),
                        _getSecondaryItem(
                          '프로틴 등급업',
                          _.activityLevelUpNoti,
                          _.updateActivityLevelUpNoti,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: _getPrimaryItem(
                              '게시판 알림', _.postNoti, _.updatePostNotiAll),
                        ),
                        _divider,
                        _getSecondaryItem(
                          '댓글',
                          _.postCommentNoti,
                          _.updatePostCommentNoti,
                        ),
                        _getSecondaryItem(
                          '대댓글',
                          _.postReplyNoti,
                          _.updatePostReplyNoti,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: _getPrimaryItem(
                              'Q&A 알림', _.qnaNoti, _.updateQnaNotiAll),
                        ),
                        _divider,
                        _getSecondaryItem(
                          '답변',
                          _.qnaAnswerNoti,
                          _.updateQnaAnswerNoti,
                        ),
                        _getSecondaryItem(
                          '댓글',
                          _.qnaCommentNoti,
                          _.updateQnaCommentNoti,
                        ),
                        _getSecondaryItem(
                          '대댓글',
                          _.qnaReplyNoti,
                          _.updateQnaReplyNoti,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: _getPrimaryItem(
                            '기타 알림',
                            _.generalNoti,
                            _.updateGeneralNoti,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
