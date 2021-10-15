import 'package:exon_app/constants/colors.dart';
import 'package:exon_app/core/controllers/add_excercise_controller.dart';
import 'package:exon_app/dummy_data.dart';
import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_text_field.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExcerciseDetailsPage extends StatelessWidget {
  const AddExcerciseDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddExcerciseController());
    const String _titleLabel = '기록할 운동';
    const String _crashText = '정보를 찾을 수 없습니다';
    const String _targetMuscleLabelText = '타겟 부위';
    const String _excerciseMethodLabelText = '운동 종류';
    const String _addExcerciseSetLabelText = '운동 기록';
    const String _loadRecordButtonText = '최근 기록 가져오기';
    const String _addSetButtonText = '세트 추가하기';
    const String _completeButtonText = '완료';
    const double _addIconSize = 25;
    const double _deleteIconSize = 30;
    Color _dividerColor = const Color(0xff777777).withOpacity(0.3);
    final _data = excerciseDummyData[controller.selectedExcercise] ?? {};

    void _onBackPressed() {
      controller.jumpToPage(0);
    }

    void _onLoadRecordPressed() {}

    void _onAddSetPressed() {
      controller.addSet();
    }

    void _onDeleteSetPressed(int setNum) {
      controller.deleteSet(setNum);
    }

    void _onCompletePressed() {
      Get.offNamed('/home');
    }

    Widget _header = Header(onPressed: _onBackPressed);

    Widget _excerciseInfoSection = _data.isEmpty
        ? const Text(_crashText)
        : Container(
            width: context.width,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            color: lightPrimaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: deepPrimaryColor,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        _titleLabel,
                        style: TextStyle(
                          color: deepPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _data['name'],
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: (context.width - 40) / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text(
                              _targetMuscleLabelText,
                              style: TextStyle(
                                color: deepPrimaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            targetMuscleIntToStr[_data['target_muscle']]!,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: (context.width - 40) / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text(
                              _excerciseMethodLabelText,
                              style: TextStyle(
                                color: deepPrimaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            excerciseMethodIntToStr[_data['excercise_method']]!,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

    Widget _addExcerciseSetHeader = Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              color: deepPrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: SizedBox(
              height: 30,
              width: 100,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  _addExcerciseSetLabelText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _onLoadRecordPressed,
            child: const Text(
              _loadRecordButtonText,
              style: TextStyle(
                textBaseline: TextBaseline.alphabetic,
                decoration: TextDecoration.underline,
                color: deepPrimaryColor,
                fontSize: 18,
                letterSpacing: -2,
              ),
            ),
          )
        ],
      ),
    );

    Widget _excerciseSetBlock(int setNum) {
      return GetBuilder<AddExcerciseController>(builder: (_) {
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: _dividerColor,
              ),
            ),
          ),
          child: SizedBox(
            width: context.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Row(
                children: [
                  Text(
                    '$setNum세트',
                    style: const TextStyle(
                      color: Color(0xff000300),
                      fontSize: 22,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: NumberInputField(
                      controller: _.inputSetControllers[setNum - 1][0],
                      hintText: '0.0',
                    ),
                  ),
                  const Text(
                    'kg',
                    style: TextStyle(
                      color: Color(0xff000300),
                      fontSize: 22,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: NumberInputField(
                      controller: _.inputSetControllers[setNum - 1][1],
                      hintText: '0',
                      maxLength: 2,
                    ),
                  ),
                  const Text(
                    '회',
                    style: TextStyle(
                      color: Color(0xff000300),
                      fontSize: 22,
                    ),
                  ),
                  setNum == 1
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: () => _onDeleteSetPressed(setNum),
                          icon: const Icon(
                            Icons.remove_circle,
                            color: deepPrimaryColor,
                            size: _deleteIconSize,
                          ),
                        )
                ],
              ),
            ),
          ),
        );
      });
    }

    Widget _addExcerciseSetButton = InkWell(
        splashColor: lightPrimaryColor,
        onTap: () => _onAddSetPressed(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: _dividerColor),
          ),
          child: SizedBox(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_circle_outline,
                  color: deepPrimaryColor,
                  size: _addIconSize,
                ),
                Text(
                  _addSetButtonText,
                  style: TextStyle(
                    color: deepPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ));

    Widget _excerciseSetList = GetBuilder<AddExcerciseController>(
      builder: (_) {
        return Column(
          children: List.generate(
            _.numSets + 1,
            (index) {
              if (index != _.numSets) {
                return _excerciseSetBlock(index + 1);
              } else {
                return _addExcerciseSetButton;
              }
            },
          ),
        );
      },
    );

    Widget _completeButtonSection = Column(
      children: [
        ElevatedActionButton(
          buttonText: _completeButtonText,
          onPressed: _onCompletePressed,
        ),
        DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: verticalSpacer(40)),
      ],
    );

    return Column(
      children: [
        _header,
        Expanded(
          child: DisableGlowListView(
            padding: const EdgeInsets.only(bottom: 10),
            children: [
              _excerciseInfoSection,
              _addExcerciseSetHeader,
              _excerciseSetList,
            ],
          ),
        ),
        _completeButtonSection,
      ],
    );
  }
}
