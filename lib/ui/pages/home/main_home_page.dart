import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/excercise_blocks.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
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
    Get.toNamed('/add_excercise');
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
    const String _addExerciseButtonText = '운동 추가하기 >';
    const String _exercisePlanEmptyPromptText = '운동을 추가하러 가볼까요?';
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
            AuthController.to.userInfo['username'] + '님,',
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
                  weekDayIntToStr[index + 1] ?? '',
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

    return DisableGlowListView(
      shrinkWrap: true,
      children: [
        GetBuilder<HomeController>(builder: (_) {
          return Column(
            children: [
              Container(
                width: context.width,
                height: context.height * 0.4,
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
                        child: TimeCounter(theme: _.theme)),
                  ],
                ),
              ),
              _weekdayProgressBar,
              verticalSpacer(30),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _totalExercisePlanNumText +
                          _.todayExercisePlanList.length.toString(),
                      style: const TextStyle(
                        color: softGrayColor,
                        fontSize: 13.7,
                      ),
                    ),
                    TextActionButton(
                      buttonText: _addExerciseButtonText,
                      onPressed: _onAddPressed,
                      fontSize: 13,
                      textColor: softGrayColor,
                      isUnderlined: false,
                    )
                    // AddExcerciseButton(onPressed: _onAddPressed),
                  ],
                ),
              ),
              _.loading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: LoadingIndicator(icon: true),
                    )
                  : (_.todayExercisePlanList.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 95,
                          margin: const EdgeInsets.only(
                              left: 30, right: 30, top: 8),
                          alignment: Alignment.center,
                          child: const Text(
                            _exercisePlanEmptyPromptText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: clearBlackColor,
                            ),
                          ),
                        )
                      : Column(
                          children: List.generate(
                            _.todayExercisePlanList.length,
                            (index) {
                              return ExcercisePlanBlock(
                                id: _.todayExercisePlanList[index]['plan_data']
                                    ['id'],
                                exerciseId: _.todayExercisePlanList[index]
                                    ['exercise_data']['id'],
                                exerciseName: _.todayExercisePlanList[index]
                                    ['exercise_data']['name'],
                                targetMuscle: _.todayExercisePlanList[index]
                                    ['exercise_data']['target_muscle'],
                                exerciseMethod: _.todayExercisePlanList[index]
                                    ['exercise_data']['exercise_method'],
                                numSets: _.todayExercisePlanList[index]
                                    ['plan_data']['num_sets'],
                              );
                            },
                          ),
                        )),
            ],
          );
        }),
      ],
    );
  }
}
