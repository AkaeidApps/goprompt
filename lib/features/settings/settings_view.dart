import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goprompt/core/constants/app_colors.dart';
import 'package:goprompt/core/services/storage_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final StorageService storage = Get.find<StorageService>();
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = storage.isDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            // Appearance
            const Text(
              "PREFERENCES",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: SwitchListTile(
                title: const Text(
                  "Dark Mode",
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  "Use premium dark navy theme",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                value: isDarkMode,
                activeThumbColor: AppColors.primary,
                onChanged: (val) async {
                  setState(() {
                    isDarkMode = val;
                  });
                  await storage.setDarkMode(val);
                  Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
            const SizedBox(height: 24),

            // About & Support
            const Text(
              "ABOUT & SUPPORT",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.privacy_tip_rounded,
                    title: "Privacy Policy",
                    onTap: () {
                      Get.snackbar("Privacy Policy", "Easy Prompt Pro respects your privacy.",
                          backgroundColor: AppColors.cardBackground, colorText: AppColors.textPrimary);
                    },
                  ),
                  const Divider(color: AppColors.border, height: 1),
                  _buildSettingTile(
                    icon: Icons.description_rounded,
                    title: "Terms and Conditions",
                    onTap: () {
                      Get.snackbar("Terms", "Standard terms of use apply.",
                          backgroundColor: AppColors.cardBackground, colorText: AppColors.textPrimary);
                    },
                  ),
                  const Divider(color: AppColors.border, height: 1),
                  _buildSettingTile(
                    icon: Icons.star_rounded,
                    title: "Rate Application",
                    onTap: () {
                      Get.snackbar("Thank You!", "Rating feature coming soon.",
                          backgroundColor: AppColors.cardBackground, colorText: AppColors.textPrimary);
                    },
                  ),
                  const Divider(color: AppColors.border, height: 1),
                  _buildSettingTile(
                    icon: Icons.support_agent_rounded,
                    title: "Contact Support",
                    onTap: () {
                      Get.snackbar("Support", "Email: support@easyprompt.pro",
                          backgroundColor: AppColors.cardBackground, colorText: AppColors.textPrimary);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App Version
            const Center(
              child: Text(
                "Easy Prompt Pro v1.0.0+1",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSecondary, size: 14),
      onTap: onTap,
    );
  }
}
