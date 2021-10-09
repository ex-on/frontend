import 'package:exon_app/ui/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterEmailPage extends StatelessWidget {
  const RegisterEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _titleText = '반갑습니다!';
    const _titleLabelText = '회원가입을 위한 이메일을 입력해주세요';
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          SizedBox(
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  _titleText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _titleLabelText,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const InputTextField(
            label: '이메일',
          ),
        ],
      ),
    );
  }
}
