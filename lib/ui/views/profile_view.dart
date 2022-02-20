import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/profile_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/bubble_tooltips.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/circle.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _activityLevelLabelText = '내 레벨';
    const String _monthlyExerciseLabelText = '이번달 운동 수행';
    const String _communityActivityLabelText = '커뮤니티 활동';
    const String _physicalDataLabelText = '신체 정보';
    const String _privateLabelText = '비공개';
    const List<Color> _bmiGradientColors = <Color>[
      Color(0xff0D92DD),
      Color(0xff3AD29F),
      Color(0xffFFC700),
      Color(0xffD63E6C),
    ];

    Future.delayed(
      Duration.zero,
      () {
        if (AuthController.to.userInfo.isEmpty) {
          AuthController.to.getUserInfo();
        }
        if (controller.profileData.isEmpty) {
          controller.getProfileStats();
        }
      },
    );

    void _onMenuPressed() {
      Get.toNamed('/settings');
    }

    void _onActivityLevelHelpPressed() {}

    void _onMonthlyExerciseHelpPressed() {}

    return Column(
      children: [
        ProfileHeader(onPressed: _onMenuPressed),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
          child: Row(
            children: [
              const Circle(
                color: brightPrimaryColor,
                width: 50,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FistIcon(),
                ),
              ),
              horizontalSpacer(15),
              GetBuilder<AuthController>(builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _.userInfo.isNotEmpty
                            ? activityLevelIntToStr[
                                    _.userInfo['activity_level']]! +
                                ' ' +
                                _.userInfo['username']
                            : '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: clearBlackColor,
                        ),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'EXON과 함께한지 ',
                        style: const TextStyle(
                          color: softBlackColor,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: _.userInfo.isNotEmpty
                                ? DateTime.now()
                                    .difference(DateTime.parse(
                                        _.userInfo['created_at']))
                                    .inDays
                                    .toString()
                                : '-',
                            style: const TextStyle(
                              color: brightPrimaryColor,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(
                            text: '일',
                            style: TextStyle(
                              color: softBlackColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        Expanded(
          child: GetBuilder<ProfileController>(
            builder: (_) {
              if (_.profileData.isEmpty) {
                return const LoadingIndicator();
              } else {
                int _currentLevel = _.profileData['activity_level']['level'];
                int _protein = _.profileData['activity_level']['protein'];
                DateTime _today = DateTime.now();

                return SmartRefresher(
                  controller: _.refreshController,
                  onRefresh: _.onRefresh,
                  header: CustomHeader(
                    height: 80,
                    builder: (context, mode) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: LoadingIndicator(icon: true),
                      );
                    },
                  ),
                  child: ListView(
                    children: [
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          color: mainBackgroundColor,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, bottom: 15),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 7.5),
                                    child: Text(
                                      _activityLevelLabelText,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: clearBlackColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  HelpIconButton(
                                    onPressed: _onActivityLevelHelpPressed,
                                    overlayColor:
                                        brightPrimaryColor.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: context.width - 60,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: '지금 나는 Lv' +
                                          (_currentLevel + 1).toString() +
                                          '. ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: darkPrimaryColor,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: activityLevelIntToStr[
                                              _.profileData['activity_level']
                                                  ['level']]!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: brightPrimaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 15),
                                    child: Text(
                                      'Lv' +
                                          (_currentLevel + 2).toString() +
                                          '. ' +
                                          activityLevelIntToStr[
                                              _currentLevel + 1]! +
                                          '까지 ' +
                                          (getLevelRequiredProtein(
                                                      _currentLevel + 1) -
                                                  _protein)
                                              .toString() +
                                          ' 프로틴 남았어요.',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: darkPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: mainBackgroundColor,
                                        ),
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        width: 180,
                                        height: 13,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: brightPrimaryColor,
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 18,
                                              ),
                                              width: 180 *
                                                  _protein /
                                                  getLevelRequiredProtein(
                                                      _currentLevel + 1),
                                              height: 13,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  _protein.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Text(
                                                getLevelRequiredProtein(
                                                        _currentLevel + 1)
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: deepGrayColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        activityLevelIntToStr[
                                            _currentLevel + 1]!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: deepGrayColor,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 15),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 7),
                                    child: Text(
                                      _monthlyExerciseLabelText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: clearBlackColor,
                                      ),
                                    ),
                                  ),
                                  HelpIconButton(
                                    onPressed: _onMonthlyExerciseHelpPressed,
                                    backgroundColor: mainBackgroundColor,
                                    overlayColor:
                                        brightPrimaryColor.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                width: context.width - 60,
                                height: (_today.day ~/ 11 + 1) *
                                    ((context.width - 160) / 11 + 10),
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 11,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  children: List.generate(
                                    _today.day,
                                    (index) {
                                      DateTime indexDate = DateTime(
                                          _today.year, _today.month, index + 1);
                                      bool dataExists =
                                          _.profileData['monthly_exercise'][
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(indexDate)] !=
                                              null;
                                      int _exerciseStatus = 0;
                                      late String _exerciseStatusText;

                                      if (dataExists) {
                                        _exerciseStatus =
                                            _.profileData['monthly_exercise'][
                                                DateFormat('yyyy-MM-dd')
                                                    .format(indexDate)];
                                      }

                                      switch (_exerciseStatus) {
                                        case 1:
                                          _exerciseStatusText = '운동 계획이 있어요';
                                          break;
                                        case 2:
                                          _exerciseStatusText =
                                              '운동 계획을 일부 진행했어요';
                                          break;
                                        case 3:
                                          _exerciseStatusText = '운동을 모두 완료했어요';
                                          break;
                                        default:
                                          _exerciseStatusText = '운동 기록이 없습니다';
                                          break;
                                      }

                                      return BubbleTooltip(
                                        message: DateFormat('yyyy년 MM월 dd일')
                                                .format(indexDate) +
                                            '\n' +
                                            _exerciseStatusText,
                                        backgroundColor: brightPrimaryColor,
                                        arrowHeight: () {
                                          double pos = indexDate.day % 11;
                                          if (pos < 3 || pos > 9 || pos == 0) {
                                            return 0.0;
                                          } else {
                                            return 8.0;
                                          }
                                        }(),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: Border.all(
                                              color: (dataExists
                                                  ? profileExerciseStatusIntToColor[
                                                      _exerciseStatus]!
                                                  : mainBackgroundColor),
                                            ),
                                            color: dataExists
                                                ? profileExerciseStatusIntToColor[
                                                    _exerciseStatus]
                                                : mainBackgroundColor,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 15),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 7),
                                    child: Text(
                                      _communityActivityLabelText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: clearBlackColor,
                                      ),
                                    ),
                                  ),
                                  () {
                                    if (_.profileData['community']['privacy']) {
                                      return const Text(
                                        _privateLabelText,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: lightGrayColor,
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        _.totalPostNum != null
                                            ? _.totalPostNum.toString()
                                            : '---',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: brightPrimaryColor,
                                        ),
                                      );
                                    }
                                  }(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
                              child: SizedBox(
                                width: context.width - 60,
                                height: 50,
                                child: _.profileData['community']['privacy']
                                    ? const PrivacyCharacter()
                                    : ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          late String _labelText;
                                          late String _dataText;

                                          switch (index) {
                                            case 1:
                                              _labelText = '채택률';
                                              _dataText =
                                                  getCleanTextFromDouble(_
                                                                  .profileData[
                                                              'community']
                                                          ['acception_rate']) +
                                                      '%';
                                              break;
                                            case 2:
                                              _labelText = '게시글 수';
                                              _dataText = _
                                                  .profileData['community']
                                                      ['posts']
                                                  .toString();
                                              break;
                                            case 3:
                                              _labelText = '질문 수';
                                              _dataText = _
                                                  .profileData['community']
                                                      ['qnas']
                                                  .toString();
                                              break;
                                            case 4:
                                              _labelText = '답변 수';
                                              _dataText = _
                                                  .profileData['community']
                                                      ['answers']
                                                  .toString();
                                              break;
                                            default:
                                              _labelText = '채택 답변';
                                              _dataText = _
                                                  .profileData['community']
                                                      ['accepted_answers']
                                                  .toString();
                                              break;
                                          }
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text(
                                                  _labelText,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: clearBlackColor,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _dataText,
                                                style: const TextStyle(
                                                  color: clearBlackColor,
                                                  fontFamily: 'Manrope',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const VerticalDivider(
                                          color: dividerColor,
                                          width: 32,
                                          thickness: 1,
                                        ),
                                        itemCount: 5,
                                      ),
                              ),
                            ),
                            const Divider(
                              color: mainBackgroundColor,
                              thickness: 13,
                              height: 13,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 7),
                                    child: Text(
                                      _physicalDataLabelText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: clearBlackColor,
                                      ),
                                    ),
                                  ),
                                  _.profileData['physical_data']['privacy']
                                      ? const Text(
                                          _privateLabelText,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: lightGrayColor,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 10, 20, 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const MaleAvatar(
                                    height: 105,
                                    width: 35,
                                  ),
                                  Column(
                                    children: [
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                const Text(
                                                  '골격근량',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: clearBlackColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    _.profileData['physical_data']
                                                                [
                                                                'muscle_mass'] ==
                                                            null
                                                        ? '--'
                                                        : getCleanTextFromDouble(_
                                                                    .profileData[
                                                                'physical_data']
                                                            ['muscle_mass']),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: brightPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const VerticalDivider(
                                              width: 20,
                                              thickness: 1,
                                              color: dividerColor,
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                  '체지방률',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: clearBlackColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    _.profileData['physical_data']
                                                                [
                                                                'body_fat_percentage'] ==
                                                            null
                                                        ? '--'
                                                        : getCleanTextFromDouble(_
                                                                    .profileData[
                                                                'physical_data']
                                                            [
                                                            'body_fat_percentage']),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: brightPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const VerticalDivider(
                                              width: 20,
                                              thickness: 1,
                                              color: dividerColor,
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                  '키',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: clearBlackColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    getCleanTextFromDouble(
                                                        _.profileData[
                                                                'physical_data']
                                                            ['height']),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: brightPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const VerticalDivider(
                                              width: 20,
                                              thickness: 1,
                                              color: dividerColor,
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                  '몸무게',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: clearBlackColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    getCleanTextFromDouble(
                                                        _.profileData[
                                                                'physical_data']
                                                            ['weight']),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: brightPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 260,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 5,
                                            left: 260 *
                                                ((_.profileData['physical_data']
                                                        ['bmi'] as double) -
                                                    16) /
                                                (30 - 16),
                                          ),
                                          child: const SizedBox(
                                            width: 8,
                                            height: 8,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: brightPrimaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 260,
                                        height: 12.5,
                                        margin: const EdgeInsets.only(
                                            right: 20, left: 20),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: _bmiGradientColors),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      verticalSpacer(10),
                                      SizedBox(
                                        width: 260,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text(
                                              '15',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: deepGrayColor,
                                              ),
                                            ),
                                            Text(
                                              '18.5',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: deepGrayColor,
                                              ),
                                            ),
                                            Text(
                                              '23',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: deepGrayColor,
                                              ),
                                            ),
                                            Text(
                                              '25',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: deepGrayColor,
                                              ),
                                            ),
                                            Text(
                                              '30',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: deepGrayColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
