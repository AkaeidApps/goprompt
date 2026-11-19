import 'package:get/get.dart';
import 'package:goprompt/app/routes/app_routes.dart';
import 'package:goprompt/features/main/main_layout_view.dart';
import 'package:goprompt/features/onboarding/onboarding_view.dart';
import 'package:goprompt/features/profile/profile_view.dart';
import 'package:goprompt/features/prompt_details/prompt_details_view.dart';
import 'package:goprompt/features/search/search_view.dart';
import 'package:goprompt/features/settings/settings_view.dart';
import 'package:goprompt/features/splash/splash_view.dart';
import 'package:goprompt/features/video_generator/video_generator_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
    ),
    GetPage(
      name: AppRoutes.mainLayout,
      page: () => const MainLayoutView(),
    ),
    GetPage(
      name: AppRoutes.promptDetails,
      page: () => const PromptDetailsView(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
    ),
    GetPage(
      name: AppRoutes.videoGenerator,
      page: () => const VideoGeneratorView(),
    ),
  ];
}
