import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String profileName = 'aschung01';
    const String nickName = '정순호영상이나올려라';
    const String profileIntroText = '헬스가 제일 쉬웠어요\n벤치, 데드, 스쾃으로만 운동했어요';
    void _onMenuPressed() {
      Get.toNamed('/settings');
    }

    void _onProfileEditPressed() {}

    return Column(
      children: [
        ProfileHeader(onPressed: _onMenuPressed, profileName: profileName),
        Expanded(
          child: DisableGlowListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: CircleAvatar(
                        backgroundColor: Color(0xffC4C4C4),
                        radius: 50,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          nickName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        verticalSpacer(10),
                        const Text(
                          profileIntroText,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: _ProfileEditButton(onPressed: _onProfileEditPressed),
              ),
              const _UserMainActivityBlock(
                numSelectedAnswers: 1294,
                selectedAnswersRatio: 97.3,
                points: 3034254,
                activityRanking: 1,
                physicalRanking: 23,
                dailyAverageExerciseTime:
                    Duration(hours: 1, minutes: 6, seconds: 35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileEditButton extends StatelessWidget {
  final void Function() onPressed;
  const _ProfileEditButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _buttonText = '프로필 편집';
    final deviceWidth = context.width;
    ButtonStyle _style = OutlinedButton.styleFrom(
      fixedSize: Size(deviceWidth - 50, 34),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      side: const BorderSide(color: Color(0xff999999), width: 1),
      padding: const EdgeInsets.all(5),
    );

    return OutlinedButton(
      style: _style,
      onPressed: onPressed,
      child: const Text(
        _buttonText,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _UserMainActivityBlock extends StatelessWidget {
  final int numSelectedAnswers;
  final double selectedAnswersRatio;
  final int points;
  final int activityRanking;
  final int physicalRanking;
  final Duration dailyAverageExerciseTime;
  const _UserMainActivityBlock({
    Key? key,
    required this.numSelectedAnswers,
    required this.selectedAnswersRatio,
    required this.points,
    required this.activityRanking,
    required this.physicalRanking,
    required this.dailyAverageExerciseTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _titleText = '주요 활동';
    const String _buttonText = '전체 보기';
    const String _numSelectedAnswersLabel = '채택 답변';
    const String _selectedAnswersRatioLabel = '채택률';
    const String _pointLabel = 'Point';
    const String _activityRankingLabel = '활동 랭킹';
    const String _physicalRankingLabel = '운동 랭킹';
    const String _dailyAverageExerciseTimeLabel = '일평균 운동';
    const double _buttonFontSize = 13;

    void _onButtonPressed() {
      // Get.toNamed('/');
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: textFieldFillColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                _titleText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: -1.5,
                ),
              ),
              TextActionButton(
                buttonText: _buttonText,
                onPressed: _onButtonPressed,
                fontSize: _buttonFontSize,
              ),
            ],
          ),
          verticalSpacer(10),
          Row(
            children: [
              const ColorBadge(
                type: 'activityRank',
                text: '초수',
              ),
              horizontalSpacer(8),
              const ColorBadge(
                type: 'physicalRank',
                text: '헬스꼬마',
              ),
            ],
          ),
          const Divider(
            color: lightBlackColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        _numSelectedAnswersLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: lightBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      horizontalSpacer(8),
                      Text(
                        numSelectedAnswers.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: lightBlackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(5),
                  Row(
                    children: [
                      const Text(
                        _selectedAnswersRatioLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: lightBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      horizontalSpacer(8),
                      Text(
                        selectedAnswersRatio.toString() + '%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: lightBlackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(5),
                  Row(
                    children: [
                      const Text(
                        _pointLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: lightBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      horizontalSpacer(8),
                      Text(
                        NumberFormat().format(points),
                        style: const TextStyle(
                          fontSize: 12,
                          color: lightBlackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.star_rounded,
                          color: brightPrimaryColor, size: 15),
                    ],
                  ),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  // activity Ranking
                  children: [
                    const Text(
                      _activityRankingLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: lightBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    horizontalSpacer(8),
                    Text(
                      activityRanking.toString() + '위',
                      style: const TextStyle(
                        fontSize: 12,
                        color: brightPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                verticalSpacer(5),
                Row(
                  children: [
                    const Text(
                      _physicalRankingLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: lightBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    horizontalSpacer(8),
                    Text(
                      physicalRanking.toString() + '위',
                      style: const TextStyle(
                        fontSize: 12,
                        color: brightPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                verticalSpacer(5),
                Row(
                  children: [
                    const Text(
                      _dailyAverageExerciseTimeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: lightBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    horizontalSpacer(8),
                    Text(
                      durationToString(dailyAverageExerciseTime),
                      style: const TextStyle(
                        fontSize: 12,
                        color: lightBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
