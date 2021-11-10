import 'package:exon_app/helpers/transformers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  static HomeController to = Get.find();
  final totalExcerciseTime =
      const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  final now = DateTime.now();
  int page = 0;
  int currentTime = 0;
  String weekDay = '';
  String currentMD = '';
  ColorTheme theme = ColorTheme.day;

  @override
  void onInit() {
    currentTime = int.parse(DateFormat.H().format(now));
    if (currentTime < 18 && currentTime > 5) {
      theme = ColorTheme.day;
    } else {
      theme = ColorTheme.night;
    }
    currentMD = DateFormat.Md().format(now);
    weekDay = DateFormat.E('ko_KR').format(now);
    update();
    super.onInit();
  }

  void jumpToPage(int pageNum) {
    page = pageNum;
    update();
  }
}
