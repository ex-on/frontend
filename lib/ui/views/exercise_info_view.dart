import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/dummy_data_controller.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/color_badge.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseInfoView extends StatelessWidget {
  const ExerciseInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _exerciseName = Get.arguments;
    const String _headerTitle = '운동 상세보기';
    const String _crashText = '존재하지 않는 운동입니다';
    const String _targetMuscleLabelText = '부위';
    const String _exerciseMethodLabelText = '종류';
    const String _recommendedTimeMinLabelText = '권장';
    const String _exerciseInfoLabelText = '운동 정보';
    const double _imageWidthHeight = 250;
    const _image = 'assets/benchpress.png';

    final Map<String, dynamic> _data =
        DummyDataController.to.exerciseInfoList[_exerciseName] ?? {};

    void _onBackPressed() {
      Get.back();
    }

    Widget _header = Header(onPressed: _onBackPressed, color: Colors.white);

    Widget _headerText = const Center(
      child: Text(
        _headerTitle,
        style: TextStyle(
          color: clearBlackColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -2,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Column(
        children: [
          _header,
          Expanded(
            child: DisableGlowListView(
              children: _data.isEmpty
                  ? [
                      const Text(_crashText),
                    ]
                  : [
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 15),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                _headerText,
                                verticalSpacer(30),
                                SizedBox(
                                  child: Image.asset(
                                    _image,
                                    width: _imageWidthHeight,
                                    height: _imageWidthHeight,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 15, top: 15),
                                  child: Text(
                                    _data['name'],
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          _targetMuscleLabelText,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        horizontalSpacer(9),
                                        ColorBadge(
                                          text:
                                              "${targetMuscleIntToStr[_data['target_muscle']]}",
                                          type: 'targetMuscle',
                                          height: 35,
                                          width: 57,
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          _exerciseMethodLabelText,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        horizontalSpacer(9),
                                        ColorBadge(
                                          text:
                                              "${excerciseMethodIntToStr[_data['exercise_method']]}",
                                          type: 'exerciseMethod',
                                          height: 35,
                                          width: 57,
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          _recommendedTimeMinLabelText,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        horizontalSpacer(9),
                                        ColorBadge(
                                          text:
                                              "${_data['recommended_time_min']}분",
                                          type: 'recommendedExerciseTime',
                                          height: 35,
                                          width: 57,
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  _exerciseInfoLabelText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("${_data['info_text']}"),
                                const Text(
                                  _exerciseInfoLabelText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("${_data['info_text']}"),
                                const Text(
                                  _exerciseInfoLabelText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("${_data['info_text']}"),
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
    );
  }
}
