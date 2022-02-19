import 'package:get/get.dart';

class HomeNavigationController extends GetxController {
  static HomeNavigationController to = HomeNavigationController();
  int currentIndex = 2;

  void onIconTap(int index) {
    currentIndex = index;
    update();
  }

  void reset() {
    currentIndex = 2;
    update();
  }
}
