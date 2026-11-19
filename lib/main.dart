import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goprompt/app/routes/app_pages.dart';
import 'package:goprompt/app/routes/app_routes.dart';
import 'package:goprompt/app/theme/app_theme.dart';
import 'package:goprompt/core/services/storage_service.dart';
import 'package:goprompt/data/repositories/prompt_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Services
  await Get.putAsync(() => StorageService().init());
  Get.put(PromptRepository());

  runApp(const EasyPromptProApp());
}

class EasyPromptProApp extends StatelessWidget {
  const EasyPromptProApp({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageService storage = Get.find<StorageService>();
    bool isDark = storage.isDarkMode();

    return GetMaterialApp(
      title: 'Easy Prompt Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
