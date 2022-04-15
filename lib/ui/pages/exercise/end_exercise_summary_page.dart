import 'package:confetti/confetti.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as Math;

class EndExerciseSummaryPage extends GetView<ExerciseBlockController> {
  const EndExerciseSummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () => controller.confettiControllerTop.play(),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ExerciseBlockController>(
        builder: (_) {
          print(_.postedExerciseRecord);
          if (_.postLoading || _.postedExerciseRecord == null) {
            return const LoadingIndicator();
          } else {
            bool _isCardio =
                _.postedExerciseRecord!['record_data']['exercise_time'] == null;
            bool _isBodyWeight =
                _.postedExerciseRecord!['record_data']['total_reps'] != null;
            int _exerciseTime = _isCardio
                ? _.postedExerciseRecord!['record_data']['record_duration']
                : _.postedExerciseRecord!['record_data']['exercise_time']!;

            Path _drawStar(Size size) {
              // Method to convert degree to radians
              double degToRad(double deg) => deg * (Math.pi / 180.0);

              const numberOfPoints = 5;
              final halfWidth = size.width / 2;
              final externalRadius = halfWidth;
              final internalRadius = halfWidth / 2.5;
              final degreesPerStep = degToRad(360 / numberOfPoints);
              final halfDegreesPerStep = degreesPerStep / 2;
              final path = Path();
              final fullAngle = degToRad(360);
              path.moveTo(size.width, halfWidth);

              for (double step = 0; step < fullAngle; step += degreesPerStep) {
                path.lineTo(halfWidth + externalRadius * Math.cos(step),
                    halfWidth + externalRadius * Math.sin(step));
                path.lineTo(
                    halfWidth +
                        internalRadius * Math.cos(step + halfDegreesPerStep),
                    halfWidth +
                        internalRadius * Math.sin(step + halfDegreesPerStep));
              }
              path.close();
              return path;
            }

            void _onCelebratePressed() {
              controller.confettiControllerLeft.play();
              controller.confettiControllerRight.play();
              // controller.confettiControllerLeft.play();
            }

            void _onGoHomePressed() {
              HomeController.to.getTodayExerciseStatus();
              Get.offAllNamed('/home');
            }

            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: darkSecondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: context.width - 80,
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: Text(
                        activityLevelIntToStr[
                                AuthController.to.userInfo['activity_level']]! +
                            ' ' +
                            AuthController.to.userInfo['username'] +
                            '님\n 아주 칭찬해~',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 15),
                      child: Text(
                        '운동기록',
                        style: TextStyle(
                          fontSize: 16,
                          color: clearBlackColor,
                        ),
                      ),
                    ),
                    Text(
                      _.postedExerciseRecord!['exercise_name'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: clearBlackColor,
                      ),
                    ),
                    Text(
                      _exerciseTime < 3600
                          ? formatMMSS(_exerciseTime)
                          : formatHHMMSS(_exerciseTime),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: clearBlackColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15,
                        bottom: 20,
                      ),
                      child: Divider(
                        color: clearBlackColor,
                        thickness: 0.5,
                        height: 0.5,
                        indent: 30,
                        endIndent: 30,
                      ),
                    ),
                    () {
                      if (_isCardio) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  '총 주행거리',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: clearBlackColor,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: getCleanTextFromDouble(
                                        _.postedExerciseRecord!['record_data']
                                            ['record_distance']),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: darkPrimaryColor,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' km',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            horizontalSpacer(30),
                            Column(
                              children: [
                                const Text(
                                  '소모 칼로리',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: clearBlackColor,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: getCleanTextFromDouble(
                                        _.postedExerciseRecord!['record_data']
                                            ['record_calories']),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: darkPrimaryColor,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' kcal',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return !_isBodyWeight
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        '최고 1RM',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: clearBlackColor,
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: getCleanTextFromDouble(
                                              _.postedExerciseRecord![
                                                  'record_data']['max_one_rm']),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: darkPrimaryColor,
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: ' kg',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  horizontalSpacer(30),
                                  Column(
                                    children: [
                                      const Text(
                                        '총 세트 수',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: clearBlackColor,
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: _.postedExerciseRecord![
                                                  'record_data']['total_sets']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: darkPrimaryColor,
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: ' set',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  horizontalSpacer(30),
                                  Column(
                                    children: [
                                      const Text(
                                        '총 운동 볼륨',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: clearBlackColor,
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: getCleanTextFromDouble(_
                                                  .postedExerciseRecord![
                                              'record_data']['total_volume']),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: darkPrimaryColor,
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: ' kg',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        '총 반복횟수',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: clearBlackColor,
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: _.postedExerciseRecord![
                                                  'record_data']['total_reps']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: darkPrimaryColor,
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: ' 회',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  horizontalSpacer(30),
                                  Column(
                                    children: [
                                      const Text(
                                        '총 세트 수',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: clearBlackColor,
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: _.postedExerciseRecord![
                                                  'record_data']['total_sets']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: darkPrimaryColor,
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: ' set',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                      }
                    }(),
                    verticalSpacer(140),
                    SizedBox(
                      width: context.width - 80,
                      child: Row(
                        children: [
                          ElevatedActionButton(      width: context.width / 2 - 45,
                          height: 65,
                            buttonText: '셀프 축하',
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(
                              color: darkSecondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overlayColor: darkSecondaryColor.withOpacity(0.2),
                            borderRadius: 20,
                            borderSide:
                                const BorderSide(color: darkSecondaryColor),
                            onPressed: _onCelebratePressed,
                          ),
                          horizontalSpacer(10),
                          ElevatedActionButton( width: context.width / 2 - 45,
                          height: 65,
                            buttonText: '홈으로',
                            backgroundColor: darkSecondaryColor,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            borderRadius: 20,
                            onPressed: _onGoHomePressed,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _.confettiControllerTop,
                    blastDirection: Math.pi / 2,
                    maxBlastForce: 5, // set a lower max blast force
                    minBlastForce: 2, // set a lower min blast force
                    emissionFrequency: 0.05,
                    numberOfParticles: 20, // a lot of particles at once
                    gravity: 0.2,
                    shouldLoop: false,
                    createParticlePath: _drawStar,
                    colors: const [
                      brightPrimaryColor,
                      brightSecondaryColor,
                      darkPrimaryColor,
                      darkSecondaryColor,
                      cardioColor,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ConfettiWidget(
                    confettiController: _.confettiControllerLeft,
                    blastDirection: 0,
                    maxBlastForce: 5, // set a lower max blast force
                    minBlastForce: 2, // set a lower min blast force
                    emissionFrequency: 0.05,
                    numberOfParticles: 5, // a lot of particles at once
                    gravity: 0.1,
                    shouldLoop: false,
                    createParticlePath: _drawStar,
                    colors: const [
                      brightPrimaryColor,
                      brightSecondaryColor,
                      darkPrimaryColor,
                      darkSecondaryColor,
                      cardioColor,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ConfettiWidget(
                    confettiController: _.confettiControllerRight,
                    blastDirection: Math.pi,
                    maxBlastForce: 5, // set a lower max blast force
                    minBlastForce: 2, // set a lower min blast force
                    emissionFrequency: 0.05,
                    numberOfParticles: 5, // a lot of particles at once
                    gravity: 0.1,
                    shouldLoop: false,
                    createParticlePath: _drawStar,
                    colors: const [
                      brightPrimaryColor,
                      brightSecondaryColor,
                      darkPrimaryColor,
                      darkSecondaryColor,
                      cardioColor,
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
