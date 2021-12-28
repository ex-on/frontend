import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:exon_app/ui/widgets/common/header.dart';
import 'package:exon_app/ui/widgets/common/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QnaWritePage extends StatelessWidget {
  const QnaWritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _headerTitle = '질문';
    const String _submitButtonText = '등록';

    void _onBackPressed() {
      Get.back();
    }

    void _onSubmitPressed() {}

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Header(
            onPressed: _onBackPressed,
            title: _headerTitle,
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: TextActionButton(
                  buttonText: _submitButtonText,
                  onPressed: _onSubmitPressed,
                  fontSize: 16,
                  textColor: brightPrimaryColor,
                  isUnderlined: false,
                ),
              )
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
              children: [
                TitleInputField(hintText: '질문 제목'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ContentInputField(),
                ),
                const Divider(
                  thickness: 0.5,
                  height: 0.5,
                  color: Color(0xffAEADAD),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: mainBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '엑손 게시판 이용규칙',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Color(0xffA1A0A0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '1. 욕설 및 비방 금지',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffA1A0A0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}