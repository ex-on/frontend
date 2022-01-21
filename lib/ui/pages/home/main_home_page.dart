import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/exercise_blocks.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:exon_app/ui/widgets/home/time_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:exon_app/dummy_data_controller.dart';
import 'package:exon_app/helpers/transformers.dart';

class MainHomePage extends GetView<HomeController> {
  const MainHomePage({Key? key}) : super(key: key);

  void _onAddPressed() {
    AddExerciseController.to.jumpToPage(0);
    Get.toNamed('/add_exercise');
    // Get.toNamed('/exercise_summary');
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
    Color secondaryColor =
        isDaytime ? brightSecondaryColor : darkSecondaryColor;
    String _todayMonthDate = controller.currentMD;
    double _weekdayProgress = (weekDayStrToInt[controller.weekDay] ?? 0) / 7;

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
            (AuthController.to.userInfo.length != 0)
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

    Widget _weekdayProgressBar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.only(bottom: 7),
          width: (_weekdayProgress - 1 / 14) * context.width,
          height: 10,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
        Row(
          children: List.generate(
            7,
            (index) => SizedBox(
              width: context.width / 7,
              child: Center(
                child: Text(
                  weekdayIntToStr[index + 1] ?? '',
                  style: TextStyle(
                    color: index + 1 == weekDayStrToInt[controller.weekDay]
                        ? secondaryColor
                        : softBlackColor,
                    fontSize: 13,
                    fontWeight: index + 1 == weekDayStrToInt[controller.weekDay]
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return GetBuilder<HomeController>(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.width,
            height: 350,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: isDaytime ? 53 : 64,
                  top: isDaytime ? 66 : 52,
                  child: SvgPicture.asset(
                    _dayNightIcon,
                  ),
                ),
                Positioned(
                  top: 82,
                  left: 30,
                  child: _titleBanner,
                ),
                Positioned(
                  bottom: 27,
                  left: 30,
                  child: ExerciseTimeCounter(
                    theme: _.theme,
                    totalExerciseTime: _.totalExerciseTime,
                  ),
                ),
              ],
            ),
          ),
          _weekdayProgressBar,
          verticalSpacer(30),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
              _totalExercisePlanNumText +
                  _.todayExercisePlanList.length.toString() +
                  '개',
              style: const TextStyle(
                color: softGrayColor,
                fontSize: 13.7,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GetBuilder<HomeController>(
                  builder: (_) {
                    bool _isEmpty = _.todayExercisePlanList.isEmpty &&
                        _.todayExerciseRecordList.isEmpty;
                    List<Widget> _children = List.generate(
                      _.todayExercisePlanList.length,
                      (index) {
                        return ExercisePlanBlock(
                          exerciseData: _.todayExercisePlanList[index]
                              ['exercise_data'],
                          id: _.todayExercisePlanList[index]['plan_data']['id'],
                          numSets: _.todayExercisePlanList[index]['plan_data']
                              ['num_sets'],
                        );
                      },
                    );
                    _.todayExerciseRecordList.asMap().forEach((index, element) {
                      _children.add(
                        ExcerciseRecordBlock(
                          exerciseData: _.todayExerciseRecordList[index]
                              ['exercise_data'],
                          totalSets: _.todayExerciseRecordList[index]
                              ['record_data']['total_sets'],
                          totalVolume: _.todayExerciseRecordList[index]
                              ['record_data']['total_volume'],
                        ),
                      );
                    });

                    return ListView(
                      children: [
                        _.loading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: LoadingIndicator(icon: true),
                              )
                            : _isEmpty
                                ? Column(
                                    children: [
                                      verticalSpacer(20),
                                      const Text(
                                        '근손실이 오고 있어요ㅠㅠ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: lightGrayColor,
                                        ),
                                      ),
                                      verticalSpacer(15),
                                      const TiredCharacter(),
                                    ],
                                  )
                                : Column(
                                    children: _children,
                                  ),
                      ],
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
    });
  }
}
