import 'package:get/get.dart';

class HomeNavigationController extends GetxController {
  int currentIndex = 2;

  void onIconTap(int index) {
    currentIndex = index;
    update();
  }
}
