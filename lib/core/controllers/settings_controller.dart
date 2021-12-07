import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  static SettingsController to = Get.find();
  bool loading = false;

  void setLoading(bool val) {
    loading = val;
    update();
  }

  Future<bool> signOut() async {
    setLoading(true);
    var signOutRes = await AmplifyService.signOut(
        RegisterController.to.emailController.text);
    setLoading(false);
    return signOutRes;
  }
}
