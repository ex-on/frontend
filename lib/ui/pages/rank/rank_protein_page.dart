import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/circle.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankProteinPage extends GetView<RankController> {
  const RankProteinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.proteinRankData.isEmpty) {
        controller.proteinRefreshController.requestRefresh();
      }
    });

    Widget _helpDialog = AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: const [
                    ProteinIcon(),
                    Padding(
                      padding: EdgeInsets.only(left: 6.5),
                      child: Text(
                        '프로틴 등급',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: clearBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 20,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 20),
            child: Text(
              '프로틴은 EXON의 포인트를 의미합니다',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: deepGrayColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Column(
              children: List.generate(activityLevelIntToStr.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activityLevelIntToStr[index]!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: brightPrimaryColor,
                        ),
                      ),
                      Text(
                        index == activityLevelIntToStr.length - 1
                            ? formatNumberFromInt(
                                    getLevelRequiredProtein(index)) +
                                ' 이상'
                            : '${formatNumberFromInt(getLevelRequiredProtein(index))}~${formatNumberFromInt(getLevelRequiredProtein(index + 1))}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: deepGrayColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 6.5),
                child: CommentIconTrailing(
                  width: 20,
                  height: 20,
                ),
              ),
              Text(
                '프로틴 부여기준',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: clearBlackColor,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: List.generate(7, (index) {
                late String _labelText;
                late int protein;

                switch (index) {
                  case 1:
                    _labelText = '일일 운동 계획 모두 수행';
                    protein = 10;
                    break;
                  case 2:
                    _labelText = '주간 운동 정산';
                    protein = 10;
                    break;
                  case 3:
                    _labelText = 'HOT 게시물 선정';
                    protein = 50;
                    break;
                  case 4:
                    _labelText = 'Q&A 인기 답변 선정';
                    protein = 20;
                    break;
                  case 5:
                    _labelText = 'Q&A 질문자 채택';
                    protein = 30;
                    break;
                  case 6:
                    _labelText = 'HOT Q&A 선정';
                    protein = 50;
                    break;
                  default:
                    _labelText = '출석 (일일 첫 운동 기록)';
                    protein = 5;
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _labelText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: brightPrimaryColor,
                        ),
                      ),
                      Text(
                        index == 2 ? '운동한 일수 * $protein 프로틴' : '$protein 프로틴',
                        style: const TextStyle(
                          fontSize: 12,
                          color: deepGrayColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );

    void _onHelpPressed() {
      Get.dialog(_helpDialog);
    }

    return GetBuilder<RankController>(
      builder: (_) {
        return SmartRefresher(
          controller: controller.proteinRefreshController,
          onRefresh: controller.onProteinRefresh,
          header: const MaterialClassicHeader(
            color: brightPrimaryColor,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: () {
              if (_.proteinRankData.isEmpty) {
                return <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      '정보를 불러오는 중이에요...',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ];
              } else {
                int _nextLevelLeftProtein = getLevelRequiredProtein(
                        _.proteinRankData['activity_level'] + 1) -
                    _.proteinRankData['protein'] as int;

                int _currentProtein = _.proteinRankData['protein'];

                List<Widget> children = [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25,
                      bottom: 25,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const ProteinIcon(),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 6, right: 5),
                                    child: Text(
                                      '내 프로틴',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: clearBlackColor,
                                      ),
                                    ),
                                  ),
                                  Material(
                                    type: MaterialType.transparency,
                                    child: HelpIconButton(
                                      onPressed: _onHelpPressed,
                                      size: 20,
                                      backgroundColor: mainBackgroundColor,
                                      overlayColor:
                                          brightPrimaryColor.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                              Text.rich(
                                TextSpan(
                                  text: activityLevelIntToStr[
                                      _.proteinRankData['activity_level'] + 1],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: darkSecondaryColor,
                                    letterSpacing: -1,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: '까지 ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: clearBlackColor,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _nextLevelLeftProtein.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: darkSecondaryColor,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' 프로틴 남았어요',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: clearBlackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: mainBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                          width: context.width - 60,
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          child: Text.rich(
                            TextSpan(
                              text: AuthController.to.userInfo['username'] +
                                  '님은 지금까지 총 ',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 22 / 14,
                                color: Colors.black,
                                letterSpacing: -1,
                              ),
                              children: [
                                TextSpan(
                                  text: _currentProtein.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 22 / 18,
                                    color: brightPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' 프로틴을 획득했고,\n내 랭킹은 ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 22 / 14,
                                    color: Colors.black,
                                    letterSpacing: -1,
                                  ),
                                ),
                                TextSpan(
                                  text: _.proteinRankData['rank'].toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 22 / 18,
                                    color: brightPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const TextSpan(
                                  text: '위입니다',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 22 / 14,
                                    color: Colors.black,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width: context.width - 60,
                                height: 20,
                                padding: const EdgeInsets.only(right: 10),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: mainBackgroundColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  _nextLevelLeftProtein.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: lightGrayColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: (context.width - 60) *
                                    _currentProtein /
                                    _nextLevelLeftProtein,
                                height: 20,
                                constraints: const BoxConstraints(minWidth: 40),
                                padding: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: brightPrimaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const WhiteProteinIcon(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Text(
                                        _currentProtein.toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '헬스세포',
                                style: TextStyle(
                                  color: brightPrimaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '헬린이',
                                style: TextStyle(
                                  color: lightGrayColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.5, color: lightGrayColor),
                  SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 40),
                            child: Text(
                              '순위',
                              style: TextStyle(
                                color: deepGrayColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '닉네임',
                            style: TextStyle(
                              color: deepGrayColor,
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 35),
                            child: Text(
                              '프로틴',
                              style: TextStyle(
                                color: deepGrayColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Divider(
                      thickness: 0.5,
                      color: lightGrayColor,
                      height: 0.5,
                    ),
                  ),
                ];

                _.proteinRankData['rank_list'].asMap().forEach(
                  (index, data) {
                    late Widget _rankIcon;

                    switch (index) {
                      case 0:
                        _rankIcon = const SizedBox(
                          width: 45,
                          height: 50,
                          child: RankBadgeFirstIcon(
                            width: 50,
                            height: 50,
                          ),
                        );
                        break;
                      case 1:
                        _rankIcon = const SizedBox(
                          width: 45,
                          height: 50,
                          child: RankBadgeSecondIcon(
                            width: 50,
                            height: 50,
                          ),
                        );
                        break;
                      case 2:
                        _rankIcon = const SizedBox(
                          width: 45,
                          height: 50,
                          child: RankBadgeThirdIcon(
                            width: 50,
                            height: 50,
                          ),
                        );
                        break;
                      default:
                        _rankIcon = Circle(
                          width: 45,
                          height: 50,
                          color: index + 1 == _.proteinRankData['rank']
                              ? brightPrimaryColor.withOpacity(0.8)
                              : Colors.transparent,
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: index + 1 == _.proteinRankData['rank']
                                    ? Colors.white
                                    : brightPrimaryColor,
                              ),
                            ),
                          ),
                        );
                    }

                    children.add(
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: index + 1 == _.proteinRankData['rank']
                              ? brightPrimaryColor.withOpacity(0.15)
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: _rankIcon,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: activityLevelIntToStr[
                                            data['activity_level']]!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: lightGrayColor,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ' ' + data['username'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: clearBlackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Text(
                                      data['protein'].toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: clearBlackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                  thickness: 0.5,
                                  color: lightGrayColor,
                                  height: 0.5),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                return children;
              }
            }(),
          ),
        );
      },
    );
  }
}
