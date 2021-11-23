import 'package:get/get.dart';

class HomeNavigationController extends GetxController {
  static HomeNavigationController to = HomeNavigationController();
  int currentIndex = 2;
  double? topPadding;

  void onIconTap(int index) {
    currentIndex = index;
    update();
  }
}
