import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:goprompt/app/routes/app_routes.dart';
import 'package:goprompt/core/constants/app_colors.dart';
import 'package:goprompt/data/repositories/prompt_repository.dart';
import 'package:goprompt/features/main/main_layout_view.dart';
import 'package:goprompt/features/widgets/prompt_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final PromptRepository promptRepo = Get.find<PromptRepository>();

    final List<Map<String, dynamic>> categories = [
      {"name": "All", "icon": Icons.apps_rounded, "color": AppColors.primary},
      {"name": "Cinematic", "icon": Icons.movie_rounded, "color": AppColors.accent},
      {"name": "Sci-Fi", "icon": Icons.rocket_launch_rounded, "color": AppColors.secondary},
      {"name": "Fantasy", "icon": Icons.auto_awesome_rounded, "color": const Color(0xFFB388FF)},
      {"name": "Anime", "icon": Icons.star_rounded, "color": AppColors.favorite},
      {"name": "3D Animation", "icon": Icons.widgets_rounded, "color": const Color(0xFFFFB74D)},
      {"name": "Nature", "icon": Icons.forest_rounded, "color": const Color(0xFF66BB6A)},
      {"name": "Product Advertisement", "icon": Icons.shopping_bag_rounded, "color": const Color(0xFFFF8A65)},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (promptRepo.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final trending = promptRepo.getTrendingPrompts();
          final latest = promptRepo.getLatestPrompts();
          final heroPrompt = trending.isNotEmpty ? trending.first : null;

          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.cardBackground,
            onRefresh: () => promptRepo.loadPrompts(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildHero(heroPrompt?.thumbnailUrl ?? ""),
                  const SizedBox(height: 18),

                  // Quick actions make the generator discoverable in one tap.
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickTool(
                          icon: Icons.auto_awesome_rounded,
                          title: "Prompt Studio",
                          subtitle: "Generate pro prompts",
                          gradient: AppColors.studioGradient,
                          onTap: () =>
                              Get.find<MainLayoutController>().changeTab(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickTool(
                          icon: Icons.movie_creation_rounded,
                          title: "AI Video Lab",
                          subtitle: "Turn text to video",
                          gradient: AppColors.videoGradient,
                          onTap: () => Get.toNamed(AppRoutes.videoGenerator),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _sectionHeader("Popular Categories"),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            avatar: Icon(
                              cat["icon"] as IconData,
                              size: 14,
                              color: cat["color"] as Color,
                            ),
                            label: Text(cat["name"] as String),
                            onPressed: () => Get.toNamed(
                              AppRoutes.search,
                              arguments: {'category': cat["name"]},
                            ),
                            backgroundColor: AppColors.cardBackground,
                            labelStyle: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            visualDensity: VisualDensity.compact,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  _sectionHeader(
                    "Trending Prompts",
                    actionText: "See all",
                    onAction: () => Get.toNamed(AppRoutes.search),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 238,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trending.length > 5 ? 5 : trending.length,
                      itemBuilder: (context, index) {
                        final prompt = trending[index];
                        return ProfessionalPromptCard(
                          prompt: prompt,
                          repo: promptRepo,
                          isHorizontal: true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  _sectionHeader(
                    "Latest AI Prompts",
                    actionText: "Explore",
                    onAction: () => Get.toNamed(AppRoutes.search),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: latest.length > 4 ? 4 : latest.length,
                    itemBuilder: (context, index) {
                      final prompt = latest[index];
                      return ProfessionalPromptCard(
                        prompt: prompt,
                        repo: promptRepo,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: const Icon(Icons.movie_filter_rounded,
                  color: AppColors.background, size: 23),
            ),
            const SizedBox(width: 11),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Easy Prompt Pro",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Create something cinematic",
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.search),
              icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.profile),
              icon: const Icon(Icons.person_rounded, color: AppColors.textPrimary),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHero(String imageUrl) {
    return GestureDetector(
      onTap: () => Get.find<MainLayoutController>().changeTab(3),
      child: Container(
        height: 178,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _heroBackdrop(),
                    errorWidget: (context, url, error) => _heroBackdrop(),
                  )
                : _heroBackdrop(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xF2071827), Color(0x99071827), Color(0x33071827)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      "✨ FEATURED",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    "Cinematic prompts,\none tap away.",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "Pro prompt library for Sora, Runway & Pika",
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Start creating",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.background,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_rounded,
                            size: 13, color: AppColors.background),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroBackdrop() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16455F), Color(0xFF0A1E2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildQuickTool({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9.5,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {String? actionText, VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right_rounded,
                    size: 14, color: AppColors.primary),
              ],
            ),
          ),
      ],
    );
  }
}
