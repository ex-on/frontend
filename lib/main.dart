import 'package:exon_app/constants/app_routes.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/core/controllers/deep_link_controller.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/controllers/login_controller.dart';
import 'package:exon_app/core/controllers/profile_controller.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/core/controllers/settings_controller.dart';
import 'package:exon_app/dummy_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Get.put<DummyDataController>(DummyDataController());
  Get.put<RegisterController>(RegisterController());
  Get.put<RegisterInfoController>(RegisterInfoController());
  Get.put<LoginController>(LoginController());
  Get.put<AuthController>(AuthController());
  Get.put<SettingsController>(SettingsController());
  Get.put<AddExerciseController>(AddExerciseController());
  Get.put<ExerciseBlockController>(ExerciseBlockController());
  Get.put<HomeNavigationController>(HomeNavigationController());
  KakaoContext.clientId = kakaoClientId;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _scaffoldKey = GlobalKey();
  final ThemeData theme = ThemeData();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _configureAmplify();
    });
  }

  void _configureAmplify() async {
    await AmplifyService.configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DeepLinkController());
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            // secondary: brightPrimaryColor.withOpacity(0.3),
            secondary: deepGrayColor,
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ko', 'KR'),
        ],
        key: _scaffoldKey,
        initialRoute: '/',
        locale: const Locale('ko', 'KO'),
        getPages: AppRoutes.routes,
      ),
    );
  }
}
