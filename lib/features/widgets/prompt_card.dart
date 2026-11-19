import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:goprompt/app/routes/app_routes.dart';
import 'package:goprompt/core/constants/app_colors.dart';
import 'package:goprompt/data/models/prompt_model.dart';
import 'package:goprompt/data/repositories/prompt_repository.dart';

/// A visual prompt card: cinematic thumbnail + prompt preview + one-tap copy.
/// Used on Home, Explore, Search and Favorites screens.
class ProfessionalPromptCard extends StatelessWidget {
  final PromptModel prompt;
  final PromptRepository repo;
  final bool isHorizontal;

  const ProfessionalPromptCard({
    super.key,
    required this.prompt,
    required this.repo,
    this.isHorizontal = false,
  });

  void _copyPrompt() {
    Clipboard.setData(ClipboardData(text: prompt.fullPrompt));
    Get.snackbar(
      "Prompt copied",
      "Ready to paste into Sora, Runway or Pika.",
      backgroundColor: AppColors.cardBackground,
      colorText: AppColors.primary,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.promptDetails, arguments: prompt),
      child: Container(
        width: isHorizontal ? 186 : null,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: isHorizontal ? MainAxisSize.min : MainAxisSize.max,
          children: [
            isHorizontal
                ? SizedBox(height: 126, child: _buildImage())
                : Expanded(flex: 3, child: _buildImage()),
            isHorizontal
                ? SizedBox(height: 104, child: _buildContent())
                : Expanded(flex: 2, child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: CachedNetworkImage(
            imageUrl: prompt.thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildPlaceholder(),
            errorWidget: (context, url, error) => _buildPlaceholder(),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x66041420),
                Color(0x00000000),
                Color(0xCC04141F),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Category badge
        Positioned(
          top: 9,
          left: 9,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
            ),
            child: Text(
              prompt.category.toUpperCase(),
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        // Favorite button
        Positioned(
          top: 7,
          right: 7,
          child: GestureDetector(
            onTap: () => repo.toggleFavorite(prompt.id),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.72),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
              ),
              child: Obx(() {
                final current = repo.prompts.firstWhereOrNull((p) => p.id == prompt.id);
                final isFav = current?.isFavorite ?? prompt.isFavorite;
                return Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? AppColors.favorite : Colors.white,
                  size: 15,
                );
              }),
            ),
          ),
        ),
        // Video style indicator
        Positioned(
          bottom: 9,
          left: 9,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    size: 11, color: AppColors.background),
              ),
              const SizedBox(width: 6),
              const Text(
                "0:05  •  4K",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),
        // One-tap copy button
        Positioned(
          bottom: 7,
          right: 7,
          child: GestureDetector(
            onTap: _copyPrompt,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy_rounded, size: 12, color: AppColors.background),
                  SizedBox(width: 4),
                  Text(
                    "Copy",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16455F), Color(0xFF0A1E2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 30),
            SizedBox(height: 6),
            Text(
              "AI VISION",
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final model = prompt.aiModelCompatibility.isNotEmpty
        ? prompt.aiModelCompatibility.first
        : "AI Ready";

    return Padding(
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prompt.title,
            maxLines: isHorizontal ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          // Prompt preview with accent line
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  width: 2,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    prompt.fullPrompt,
                    maxLines: isHorizontal ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    model,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.visibility_outlined,
                      size: 11, color: AppColors.textSecondary),
                  const SizedBox(width: 3),
                  Text(
                    "${prompt.viewCount}",
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 10, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
