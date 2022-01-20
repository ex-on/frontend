import 'package:exon_app/core/services/exercise_api_service.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  static HomeController to = Get.find();
  final now = DateTime.now();
  int currentTime = 0;
  int totalExerciseTime = 0;
  bool loading = false;
  String weekDay = '';
  String currentMD = '';
  List<dynamic> todayExercisePlanList = [];
  List<dynamic> todayExerciseRecordList = [];
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
    Future.delayed(Duration.zero, () => getTodayExerciseStatus());
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  Future<void> getTodayExerciseStatus() async {
    setLoading(true);
    DateTime now = DateTime.now();

    var res = await ExerciseApiService.getExerciseStatusDate(now);
    if (res != null) {
      todayExercisePlanList = res['plans'];
      todayExerciseRecordList = res['records'];
      totalExerciseTime = res['total_exercise_time'];
    }
    update();
    setLoading(false);
  }
}
