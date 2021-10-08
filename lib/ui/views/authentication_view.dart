import 'package:flutter/material.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _title = '환영합니다';
    const String _titleLabel = 'EXON에서 운동을 기록하고\n사람들과 공유해보세요';

    Widget _titleSection = Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            _title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(_titleLabel,
              style: TextStyle(
                fontSize: 16,
              )),
        ],
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          _titleSection,
          
        ],
      ),
    );
  }
}
