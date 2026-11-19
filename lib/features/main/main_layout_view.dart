import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goprompt/core/constants/app_colors.dart';
import 'package:goprompt/features/explore/explore_view.dart';
import 'package:goprompt/features/favorites/favorites_view.dart';
import 'package:goprompt/features/home/home_view.dart';
import 'package:goprompt/features/prompt_generator/prompt_generator_view.dart';
import 'package:goprompt/features/settings/settings_view.dart';

class MainLayoutController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> screens = [
    const HomeView(),
    const ExploreView(),
    const FavoritesView(),
    const PromptGeneratorView(),
    const SettingsView(),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final MainLayoutController controller = Get.put(MainLayoutController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => controller.screens[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_rounded),
                label: "Explore",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded),
                label: "Favorites",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome_rounded),
                label: "Generator",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
