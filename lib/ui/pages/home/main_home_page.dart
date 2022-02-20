import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/exercise_blocks.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/home/exercise_time_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:exon_app/dummy_data_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainHomePage extends GetView<HomeController> {
  const MainHomePage({Key? key}) : super(key: key);

  void _onAddPressed() {
    AddExerciseController.to.jumpToPage(0);
    Get.toNamed('/add_exercise');
  }

  @override
  Widget build(BuildContext context) {
    bool isDaytime = ColorTheme.day == controller.theme;
    String _welcomeText = isDaytime
        ? DummyDataController.to.dailyExercisePlanList.isEmpty
            ? 'EXON과 함께\n운동을 시작해요.'
            : '아침 운동하기\n참 좋은 날이에요'
        : '더 어두워지기 전에\n운동을 시작할까요?';
    // const String _phraseOfTheDay = '"인생의 가장 아름다운 순간은 돌아오지 않는다."';
    const String _totalExercisePlanNumText = '총 운동 ';
    const String _daytimeIcon = 'assets/DaytimeIcon.svg';
    const String _nighttimeIcon = 'assets/NighttimeIcon.svg';

    String _dayNightIcon = isDaytime ? _daytimeIcon : _nighttimeIcon;
    Color backgroundColor =
        isDaytime ? lightBrightPrimaryColor : darkPrimaryColor;
    Color indexColor = isDaytime ? brightPrimaryColor : darkSecondaryColor;
    String _todayMonthDate = controller.currentMD;
    double _weekdayProgress = (weekDayStrToInt[controller.weekDay] ?? 0) / 7;

    void _onDatePressed(DateTime indexDate) {
      controller.updateSelectedDay(indexDate);
    }

    Widget _titleBanner = SizedBox(
      width: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _todayMonthDate,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            AuthController.to.userInfo.isNotEmpty
                ? AuthController.to.userInfo['username'] + '님,'
                : '',
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 27.15,
            ),
          ),
          Text(
            _welcomeText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27.15,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );

    Widget _weekdaySelectBar = DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: GetBuilder<HomeController>(
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.only(bottom: 7),
                width: (_weekdayProgress - 1 / 14) * context.width,
                height: 10,
                decoration: BoxDecoration(
                  color: indexColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: List.generate(
                    7,
                    (index) {
                      DateTime indexDate = DateTime(
                          _.currentDay.year,
                          _.currentDay.month,
                          _.currentDay.day - _.currentDay.weekday + 1 + index);

                      Color getTextColor() {
                        if (indexDate.weekday == _.currentDay.weekday) {
                          return indexColor;
                        } else {
                          if (indexDate.weekday > _.currentDay.weekday) {
                            return unselectedIconColor;
                          } else {
                            if (_.weekExerciseStatus.isNotEmpty) {
                              if (_
                                      .weekExerciseStatus[
                                          DateFormat('yyyy/MM/dd')
                                              .format(indexDate)]['plans']
                                      .isEmpty &&
                                  _
                                      .weekExerciseStatus[
                                          DateFormat('yyyy/MM/dd')
                                              .format(indexDate)]['records']
                                      .isEmpty) {
                                return unselectedIconColor;
                              }
                            }
                            return deepGrayColor;
                          }
                        }
                      }

                      return Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: indexDate.isBefore(_.currentDay)
                              ? () => _onDatePressed(indexDate)
                              : null,
                          highlightColor: indexColor.withOpacity(0.1),
                          overlayColor: MaterialStateProperty.all(
                              indexColor.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: (context.width - 20) / 7,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    weekdayIntToStr[index + 1] ?? '',
                                    style: TextStyle(
                                      color: indexDate.weekday ==
                                              _.currentDay.weekday
                                          ? indexColor
                                          : indexDate.weekday >
                                                  _.currentDay.weekday
                                              ? unselectedIconColor
                                              : deepGrayColor,
                                      fontSize: 13,
                                      fontWeight: index + 1 ==
                                              weekDayStrToInt[
                                                  controller.weekDay]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  verticalSpacer(5),
                                  Text(
                                    indexDate.day.toString(),
                                    style: TextStyle(
                                      color: getTextColor(),
                                      fontSize: indexDate.weekday ==
                                              _.selectedDay.weekday
                                          ? 16
                                          : 13,
                                      fontWeight: indexDate.weekday ==
                                              _.selectedDay.weekday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: context.width,
          height: 310,
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Stack(
            children: [
              Positioned(
                right: isDaytime ? 53 : 20,
                top: isDaytime ? 66 : 50,
                child: SvgPicture.asset(
                  _dayNightIcon,
                ),
              ),
              Positioned(
                top: 45,
                left: 30,
                child: _titleBanner,
              ),
              Positioned(
                bottom: 25,
                left: 30,
                child: GetBuilder<HomeController>(
                  builder: (_) {
                    return ExerciseTimeCounter(
                      theme: _.theme,
                      totalExerciseTime: (_.weekExerciseStatus.isEmpty)
                          ? 0
                          : _.weekExerciseStatus[DateFormat('yyyy/MM/dd')
                              .format(_.currentDay)]['total_exercise_time'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        _weekdaySelectBar,
        verticalSpacer(20),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: GetBuilder<HomeController>(
            builder: (_) {
              return Text(
                _totalExercisePlanNumText +
                    _.indexDayExercisePlanList.length.toString() +
                    '개',
                style: const TextStyle(
                  color: softGrayColor,
                  fontSize: 13.7,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              GetBuilder<HomeController>(
                builder: (_) {
                  bool _isEmpty = _.indexDayExercisePlanList.isEmpty &&
                      _.indexDayExerciseRecordList.isEmpty;
                  List<Widget> _children = List.generate(
                    _.indexDayExercisePlanList.length,
                    (index) {
                      return ExercisePlanBlock(
                          exerciseData: _.indexDayExercisePlanList[index]
                              ['exercise_data'],
                          planData: _.indexDayExercisePlanList[index]
                              ['plan_data'],
                          incomplete:
                              !compareSameDate(_.selectedDay, _.currentDay));
                    },
                  );
                  _.indexDayExerciseRecordList.asMap().forEach(
                    (index, element) {
                      _children.add(
                        ExerciseRecordBlock(
                          exerciseData: _.indexDayExerciseRecordList[index]
                              ['exercise_data'],
                          recordData: _.indexDayExerciseRecordList[index]
                              ['record_data'],
                        ),
                      );
                    },
                  );

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
                        _isEmpty
                            ? Column(
                                children: [
                                  verticalSpacer(20),
                                  Text(
                                    compareSameDate(_.selectedDay, _.currentDay)
                                        ? '근손실이 오고 있어요ㅠㅠ'
                                        : '운동 기록이 없습니다',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: lightGrayColor,
                                    ),
                                  ),
                                  verticalSpacer(15),
                                  const TiredCharacter(),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 90),
                                child: Column(
                                  children: _children,
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 35 + context.mediaQueryPadding.bottom,
                right: 35,
                child: FloatingIconButton(
                  heroTag: 'add_exercise',
                  onPressed: _onAddPressed,
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 50,
                  ),
                  // SvgPicture.asset(_addIcon, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
