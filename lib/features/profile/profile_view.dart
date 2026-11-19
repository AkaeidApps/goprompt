import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goprompt/core/constants/app_colors.dart';
import 'package:goprompt/data/repositories/prompt_repository.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final PromptRepository promptRepo = Get.find<PromptRepository>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 48,
                  color: AppColors.background,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Pro Creator",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "creator@easyprompt.pro",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: Obx(() => _buildStatCard(
                          "Saved Prompts",
                          "${promptRepo.favoritePrompts.length}",
                          Icons.favorite_rounded,
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Total Views",
                      "${promptRepo.prompts.fold(0, (sum, p) => sum + p.viewCount)}",
                      Icons.remove_red_eye_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Account Options
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.cloud_sync_rounded, color: AppColors.primary),
                      title: const Text("Cloud Sync Status", style: TextStyle(color: AppColors.textPrimary)),
                      trailing: const Text("Synced", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: AppColors.favorite),
                      title: const Text("Sign Out", style: TextStyle(color: AppColors.favorite, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Get.snackbar("Signed Out", "Successfully signed out of profile.",
                            backgroundColor: AppColors.cardBackground, colorText: AppColors.textPrimary);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
