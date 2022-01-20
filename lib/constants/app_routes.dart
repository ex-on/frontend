import 'package:exon_app/ui/pages/community/post/post_list_page.dart';
import 'package:exon_app/ui/pages/community/post/community_post_page.dart';
import 'package:exon_app/ui/pages/community/qna/community_qna_page.dart';
import 'package:exon_app/ui/pages/community/post/post_write_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_answer_comments_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_answer_write_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_list_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_write_page.dart';
import 'package:exon_app/ui/pages/exercise/end_exercise_summary_page.dart';
import 'package:exon_app/ui/pages/exercise/update_exercise_details_page.dart';
import 'package:exon_app/ui/views/add_exercise_view.dart';
import 'package:exon_app/ui/views/auth_landing_view.dart';
import 'package:exon_app/ui/views/exercise_block_view.dart';
import 'package:exon_app/ui/pages/exercise_info_page.dart';
import 'package:exon_app/ui/views/home_navigation_view.dart';
import 'package:exon_app/ui/views/login_view.dart';
import 'package:exon_app/ui/views/registration_view.dart';
import 'package:exon_app/ui/views/settings_view.dart';
import 'package:exon_app/ui/views/splash_view.dart';
import 'package:exon_app/ui/widgets/common/loading_indicator.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => const SplashView()),
    GetPage(name: '/loading', page: () => const LoadingIndicator(route: true)),
    GetPage(name: '/auth', page: () => AuthLandingView()),
    GetPage(name: '/register', page: () => const RegistrationView()),
    GetPage(name: '/register_info', page: () => const RegisterInfoView()),
    GetPage(name: '/login', page: () => const LoginView()),
    GetPage(name: '/home', page: () => HomeNavigationView()),
    GetPage(name: '/add_exercise', page: () => AddExerciseView()),
    GetPage(
        name: '/add_exercise/update',
        page: () => const UpdateExerciseDetailsPage()),
    GetPage(name: '/exercise_block', page: () => const ExerciseBlockView()),
    GetPage(name: '/excercise_info', page: () => const ExerciseInfoPage()),
    GetPage(
        name: '/exercise_summary', page: () => const EndExerciseSummaryPage()),
    GetPage(name: '/community/post/list', page: () => const PostListPage()),
    GetPage(name: '/community/post', page: () => const CommunityPostPage()),
    GetPage(name: '/community/post/write', page: () => const PostWritePage()),
    GetPage(name: '/community/qna', page: () => const CommunityQnaPage()),
    GetPage(name: '/community/qna/list', page: () => const QnaListPage()),
    GetPage(name: '/community/qna/write', page: () => const QnaWritePage()),
    GetPage(
        name: '/community/qna/answer/write',
        page: () => const QnaAnswerWritePage()),
    GetPage(
        name: '/community/qna/answer_comments',
        page: () => const QnaAnswerCommentsPage()),
    GetPage(
        name: '/settings',
        page: () => const SettingsView(),
        transition: Transition.rightToLeft),
  ];
}
