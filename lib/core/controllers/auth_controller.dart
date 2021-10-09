import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get authControl => Get.find();

  final birthDate = DateTime.utc(2001, 01, 01).obs;
  final gender = 0.obs;
  final height = 0.obs;
  final weight = 0.obs;
  final bodyFatPercentage = 0.obs;
  final muscleMass = 0.obs;
  var page = 0.obs;

  void jumpToPage(int pageNum) {
    page.value = pageNum;
    update();
  }
}
