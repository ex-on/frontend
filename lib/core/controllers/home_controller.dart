import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController homeController = Get.find();
  final totalExcerciseTime =
      const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  RxInt page = 0.obs;

  void jumpToPage(int pageNum) {
    page.value = pageNum;
  }
}
