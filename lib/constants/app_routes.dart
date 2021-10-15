import 'package:exon_app/ui/views/add_excercise_view.dart';
import 'package:exon_app/ui/views/auth_landing_view.dart';
import 'package:exon_app/ui/views/excercise_info_view.dart';
import 'package:exon_app/ui/views/home_view.dart';
import 'package:exon_app/ui/views/registration_view.dart';
import 'package:exon_app/ui/views/splash_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => const SplashView()),
    GetPage(name: '/auth', page: () => const AuthLandingView()),
    GetPage(name: '/register', page: () => RegistrationView()),
    GetPage(
        name: '/register_physical_info',
        page: () => const RegisterPhysicalInfoView()),
    GetPage(name: '/home', page: () => HomeView()),
    GetPage(name: '/add_excercise', page: () => AddExcerciseView()),
    GetPage(name: '/excercise_info', page: () => const ExcerciseInfoView()),
  ];
}
