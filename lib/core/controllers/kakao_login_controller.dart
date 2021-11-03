import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:kakao_flutter_sdk/auth.dart';

class KakaoLoginController extends GetxController {
  bool isKakaoInstalled = false;

  @override
  void onInit() {
    _initKakaoTalkInstalled();
    super.onInit();
  }

  void _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install: ' + installed.toString());
    isKakaoInstalled = installed;
    update();
  }
}
