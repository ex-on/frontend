import 'package:exon_app/ui/views/add_exercise_view.dart';
import 'package:exon_app/ui/views/auth_landing_view.dart';
import 'package:exon_app/ui/views/excercise_info_view.dart';
import 'package:exon_app/ui/views/home_navigation_view.dart';
import 'package:exon_app/ui/views/registration_view.dart';
import 'package:exon_app/ui/views/splash_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => const SplashView(loading: false)),
    GetPage(name: '/loading', page: () => const SplashView(loading: true)),
    GetPage(name: '/auth', page: () => AuthLandingView()),
    GetPage(name: '/register', page: () => RegistrationView()),
    GetPage(
        name: '/register_optional_info',
        page: () => const RegisterOptionalInfoView()),
    GetPage(name: '/home', page: () => HomeNavigationView()),
    GetPage(name: '/add_excercise', page: () => AddExerciseView()),
    GetPage(name: '/excercise_info', page: () => const ExerciseInfoView()),
  ];
}
