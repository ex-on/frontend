import 'package:exon_app/constants/colors.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/excercise_block.dart';
import 'package:exon_app/ui/widgets/home/time_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainHomePage extends GetView<HomeController> {
  const MainHomePage({Key? key}) : super(key: key);

  void _onAddPressed() {}

  @override
  Widget build(BuildContext context) {
    const String _userName = '순호님';
    const String _welcomeText = '운동할 준비 되셨나요?';
    const String _phraseOfTheDay = '인생의 가장 아름다운 순간은 돌아오지 않는다.';
    const List<String> _titleTextList = ['가슴 운동', '등 운동', '복근 운동'];
    const List<String> _excerciseDurationList = [
      '15분 01초',
      '18분 45초',
      '30분 14초'
    ];
    const List<List> _excerciseDataList = [
      ['벤치프레스', false, 6, '00:03:16'],
      ['체스트프레스', true, 4, '00:10:01'],
      ['인클라인 벤치프레스', true, 1, '00:10:01']
    ];

    Widget _titleBanner = SizedBox(
      width: 330,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                _userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  letterSpacing: -2,
                ),
              ),
              Text(
                _welcomeText,
                style: TextStyle(
                  fontSize: 26,
                  letterSpacing: -2,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 29,
          ),
        ],
      ),
    );

    Widget _phraseBox = Container(
      height: 55,
      width: 330,
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: lightPrimaryColor,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: const Text(_phraseOfTheDay),
    );

    return DisableGlowListView(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            _titleBanner,
            _phraseBox,
            const TimeCounter(),
            const SizedBox(
              height: 30,
            ),
            AddExcerciseButton(onPressed: _onAddPressed),
            const SizedBox(
              height: 10,
            ),
            ExcerciseBlock(
              titleText: _titleTextList[0],
              excerciseDuration: _excerciseDurationList[0],
              excerciseDataList: _excerciseDataList,
            )
          ],
        ),
      ],
    );
  }
}
