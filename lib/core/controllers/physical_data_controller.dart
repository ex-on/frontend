import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/stats_controller.dart';
import 'package:exon_app/core/services/stats_api_service.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:exon_app/helpers/utils.dart';

class PhysicalDataController extends GetxController {
  static PhysicalDataController to = Get.find<PhysicalDataController>();
  TextEditingController weightTextController = TextEditingController();
  TextEditingController muscleMassTextController = TextEditingController();
  TextEditingController bodyFatPercentageTextController =
      TextEditingController();
  int physicalStatsCategory = 0;
  bool loading = false;
  late FocusNode weightFocusNode;
  late FocusNode muscleMassFocusNode;
  late FocusNode bodyFatPercentageFocusNode;
  late TrackballBehavior physicalStatsTrackballBehavior;
  Map<String, dynamic> physicalStatData = {};

  @override
  void onInit() {
    super.onInit();
    weightFocusNode = FocusNode();
    muscleMassFocusNode = FocusNode();
    bodyFatPercentageFocusNode = FocusNode();
    physicalStatsTrackballBehavior = TrackballBehavior(
      activationMode: ActivationMode.singleTap,
      enable: true,
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        double yValue = trackballDetails.point!.yValue.toDouble();
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(trackballDetails.point!.xValue);
        return Container(
          width: 85,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xff7C8C97),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('yyyy년\nMM월 dd일').format(date),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Text(
                getCleanTextFromDouble(yValue) +
                    getPhysicalStatsUnit(physicalStatsCategory),
                style: const TextStyle(
                  fontSize: 12,
                  color: lightBrightPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 폼이 삭제될 때 호출
  @override
  void onClose() {
    super.onClose();
    weightFocusNode.dispose();
    muscleMassFocusNode.dispose();
    bodyFatPercentageFocusNode.dispose();
  }

  void setLoading(bool val) {
    loading = val;
    update();
  }

  void updatePhysicalDataCategory(int val) {
    physicalStatsCategory = val;
    update();
  }

  void reset() {
    weightTextController.clear();
    muscleMassTextController.clear();
    bodyFatPercentageTextController.clear();
  }

  Future<void> postPhysicalData() async {
    setLoading(true);
    var res = await StatsApiService.postPhysicalData(
      double.parse(weightTextController.text),
      double.parse(muscleMassTextController.text),
      double.parse(bodyFatPercentageTextController.text),
    );

    setLoading(false);
    if (res.statusCode == 200) {
      StatsController.to.cumulativeTimeStatData['physical_stat'][0] =
          StatsController.to.cumulativeTimeStatData['physical_stat'][0] + 1;
      StatsController.to.cumulativeTimeStatData['physical_stat'][1] = {
        'weight': double.parse(weightTextController.text),
        'muscle_mass': double.parse(muscleMassTextController.text),
        'body_fat_percentage':
            double.parse(bodyFatPercentageTextController.text),
        'created_at': DateTime.now().toString(),
      };
      StatsController.to.update();
    }
  }

  Future<void> getPhysicalData() async {
    setLoading(true);
    var resData = await StatsApiService.getPhysicalData();
    physicalStatData = resData;
    setLoading(false);
  }
}
