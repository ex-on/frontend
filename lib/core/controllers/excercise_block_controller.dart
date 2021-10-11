import 'package:get/get.dart';

class ExcerciseBlockController extends GetxController {
  bool open = false;

  void toggle() {
    open = !open;
    update();
  }
}
