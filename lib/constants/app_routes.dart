import 'package:exon_app/ui/pages/community/community_search_page.dart';
import 'package:exon_app/ui/pages/community/post/post_edit_page.dart';
import 'package:exon_app/ui/pages/community/post/post_list_page.dart';
import 'package:exon_app/ui/pages/community/post/community_post_page.dart';
import 'package:exon_app/ui/pages/community/qna/community_qna_page.dart';
import 'package:exon_app/ui/pages/community/post/post_write_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_answer_comments_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_answer_edit_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_answer_write_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_edit_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_list_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_select_answer_page.dart';
import 'package:exon_app/ui/pages/community/qna/qna_write_page.dart';
import 'package:exon_app/ui/pages/home/notification_page.dart';
import 'package:exon_app/ui/views/community/bookmarked_tab_view.dart';
import 'package:exon_app/ui/views/community/post_activity_tab_view.dart';
import 'package:exon_app/ui/views/community/qna_activity_tab_view.dart';
import 'package:exon_app/ui/pages/exercise/cardio_record_page.dart';
import 'package:exon_app/ui/pages/exercise/end_exercise_summary_page.dart';
import 'package:exon_app/ui/pages/exercise/update_exercise_details_page.dart';
import 'package:exon_app/ui/pages/stats/exercise_bodyweight_stats_page.dart';
import 'package:exon_app/ui/pages/stats/exercise_cardio_stats_page.dart';
import 'package:exon_app/ui/pages/stats/exercise_stats_list_page.dart';
import 'package:exon_app/ui/pages/stats/exercise_weight_stats_page.dart';
import 'package:exon_app/ui/pages/stats/physical_data_page.dart';
import 'package:exon_app/ui/pages/stats/record_physical_data_page.dart';
import 'package:exon_app/ui/views/exercise/add_exercise_view.dart';
import 'package:exon_app/ui/views/auth_landing_view.dart';
import 'package:exon_app/ui/views/exercise/exercise_cardio_block_view.dart';
import 'package:exon_app/ui/views/exercise/exercise_weight_block_view.dart';
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
    GetPage(name: '/notification', page: () => const NotificationPage()),
    GetPage(name: '/add_exercise', page: () => AddExerciseView()),
    GetPage(
        name: '/add_exercise/update',
        page: () => const UpdateExerciseDetailsPage()),
    GetPage(
        name: '/exercise_weight_block',
        page: () => const ExerciseWeightBlockView()),
    GetPage(
        name: '/exercise_cardio_block',
        page: () => const ExerciseCardioBlockView()),
    GetPage(name: '/exercise_info', page: () => const ExerciseInfoPage()),
    GetPage(
        name: '/exercise_cardio_record', page: () => const CardioRecordPage()),
    GetPage(
        name: '/exercise_summary', page: () => const EndExerciseSummaryPage()),
    GetPage(
      name: '/community/search',
      page: () => const CommunitySearchPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(name: '/community/post/list', page: () => const PostListPage()),
    GetPage(name: '/community/post', page: () => const CommunityPostPage()),
    GetPage(name: '/community/post/write', page: () => const PostWritePage()),
    GetPage(name: '/community/post/edit', page: () => const PostEditPage()),
    GetPage(name: '/community/qna', page: () => const CommunityQnaPage()),
    GetPage(name: '/community/qna/list', page: () => const QnaListPage()),
    GetPage(name: '/community/qna/write', page: () => const QnaWritePage()),
    GetPage(name: '/community/qna/edit', page: () => const QnaEditPage()),
    GetPage(
        name: '/community/qna/select_answer',
        page: () => const QnaSelectAnswerPage()),
    GetPage(
      name: '/community/qna/answer/write',
      page: () => const QnaAnswerWritePage(),
    ),
    GetPage(
        name: '/community/qna/answer/edit',
        page: () => const QnaAnswerEditPage()),
    GetPage(
      name: '/community/qna/answer_comments',
      page: () => const QnaAnswerCommentsPage(),
    ),
    GetPage(
        name: '/community/saved/bookmarks',
        page: () => const BookmarkedTabView()),
    GetPage(
        name: '/community/saved/post_activity',
        page: () => const PostActivityTabView()),
    GetPage(
        name: '/community/saved/qna_activity',
        page: () => const QnaActivityTabView()),
    GetPage(
      name: '/stats/physical_data',
      page: () => const PhysicalDataPage(),
    ),
    GetPage(
      name: '/stats/exercise/weight',
      page: () => const ExerciseWeightStatsPage(),
    ),
    GetPage(
      name: '/stats/exercise/bodyweight',
      page: () => const ExerciseBodyweightStatsPage(),
    ),
    GetPage(
      name: '/stats/exercise/cardio',
      page: () => const ExerciseCardioStatsPage(),
    ),
    GetPage(
      name: '/stats/exercise_list',
      page: () => const ExerciseStatsListPage(),
    ),
    GetPage(
      name: '/stats/physical_data/record',
      page: () => const RecordPhysicalDataPage(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
        name: '/settings',
        page: () => const SettingsView(),
        transition: Transition.rightToLeft),
  ];
}
