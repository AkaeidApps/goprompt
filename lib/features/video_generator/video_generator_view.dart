import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goprompt/core/constants/app_colors.dart';

class VideoGeneratorView extends StatefulWidget {
  const VideoGeneratorView({super.key});

  @override
  State<VideoGeneratorView> createState() => _VideoGeneratorViewState();
}

class _VideoGeneratorViewState extends State<VideoGeneratorView> {
  final TextEditingController _promptController = TextEditingController();
  bool isGenerating = false;
  double progress = 0.0;
  bool isCompleted = false;

  void _startGeneration() {
    if (_promptController.text.trim().isEmpty) {
      Get.snackbar(
        "Enter Prompt",
        "Please enter a prompt for AI video generation.",
        backgroundColor: AppColors.cardBackground,
        colorText: AppColors.textPrimary,
      );
      return;
    }

    setState(() {
      isGenerating = true;
      progress = 0.0;
      isCompleted = false;
    });

    // Simulate generation progress
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => progress = 0.3);
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() => progress = 0.7);
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        progress = 1.0;
        isGenerating = false;
        isCompleted = true;
      });
      Get.snackbar(
        "Generation Complete",
        "AI Video generated successfully!",
        backgroundColor: AppColors.cardBackground,
        colorText: AppColors.primary,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("AI Video Generator Studio"),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Text-to-Video Generator",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Configure your generation settings and prompt to create high-definition AI videos.",
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _promptController,
                maxLines: 4,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Enter your cinematic video prompt here...",
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isGenerating ? null : _startGeneration,
                  icon: const Icon(Icons.movie_rounded),
                  label: Text(
                    isGenerating ? "Generating Video..." : "Generate Video",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              if (isGenerating) ...[
                const SizedBox(height: 32),
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      color: AppColors.primary,
                      backgroundColor: AppColors.cardBackground,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Generating frames... ${(progress * 100).toInt()}%",
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ],
              if (isCompleted) ...[
                const SizedBox(height: 32),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 48),
                        SizedBox(height: 12),
                        Text(
                          "Video Generation Ready",
                          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
