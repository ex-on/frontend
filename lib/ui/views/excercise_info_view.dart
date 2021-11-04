import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/dummy_data.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExcerciseInfoView extends StatelessWidget {
  const ExcerciseInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _excerciseName = Get.arguments;
    const String _headerTitle = '운동 상세';
    const String _crashText = '존재하지 않는 운동입니다';
    const String _targetMuscleLabelText = '부위';
    const String _excerciseMethodLabelText = '종류';
    const String _recommendedTimeMinLabelText = '권장 시간';
    const String _excerciseInfoLabelText = '운동 정보';
    const double _imageWidthHeight = 250;
    const _image = 'assets/benchpress.png';

    final Map<String, dynamic> _data = DummyData.excerciseInfoList[_excerciseName] ?? {};

    void _onBackPressed() {
      Get.back();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Header(
            onPressed: _onBackPressed,
            title: _headerTitle,
          ),
          _data.isEmpty
              ? const Text(_crashText)
              : Expanded(
                  child: DisableGlowListView(
                    padding: const EdgeInsets.only(
                      top: 5,
                    ),
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            child: Image.asset(
                              _image,
                              width: _imageWidthHeight,
                              height: _imageWidthHeight,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, top: 3),
                                child: Text(_data['name'],
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -2,
                                    )),
                              ),
                              Text(
                                "난이도: ${difficultyIntToString[_data['difficulty']]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: deepPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: lightPrimaryColor,
                            margin: const EdgeInsets.only(top: 15, bottom: 15),
                            height: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            _targetMuscleLabelText,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${targetMuscleIntToStr[_data['target_muscle']]}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: -2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            _excerciseMethodLabelText,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${excerciseMethodIntToStr[_data['excercise_method']]}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: -2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            _recommendedTimeMinLabelText,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${_data['recommended_time_min']}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: -2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 330,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 7),
                                  child: Text(
                                    _excerciseInfoLabelText,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
