import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/rank_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/circle.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/rank/activity_level_info_dialog.dart';
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

    void _onHelpPressed() {
      Get.dialog(const ActivityLevelInfoDialog());
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
                                    getLevelRequiredProtein(
                                        _.proteinRankData['activity_level'] +
                                            1),
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
                            children: [
                              Text(
                                activityLevelIntToStr[
                                    _.proteinRankData['activity_level']]!,
                                style: const TextStyle(
                                  color: brightPrimaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                activityLevelIntToStr[
                                    _.proteinRankData['activity_level'] + 1]!,
                                style: const TextStyle(
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
