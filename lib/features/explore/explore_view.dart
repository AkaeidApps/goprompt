import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goprompt/app/routes/app_routes.dart';
import 'package:goprompt/core/constants/app_colors.dart';
import 'package:goprompt/data/models/prompt_model.dart';
import 'package:goprompt/data/repositories/prompt_repository.dart';
import 'package:goprompt/features/widgets/prompt_card.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final PromptRepository promptRepo = Get.find<PromptRepository>();
  String selectedCategory = "All";
  String searchQuery = "";

  final List<String> categories = [
    "All",
    "Cinematic",
    "Sci-Fi",
    "Fantasy",
    "Anime",
    "3D Animation",
    "Nature",
    "Product Advertisement"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar / Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Explore Prompts",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed(AppRoutes.search),
                    icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.cardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category Chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.cardBackground,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.background : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Prompt Grid
            Expanded(
              child: Obx(() {
                List<PromptModel> list = promptRepo.getPromptsByCategory(selectedCategory);
                if (searchQuery.isNotEmpty) {
                  list = list.where((p) =>
                    p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    p.description.toLowerCase().contains(searchQuery.toLowerCase())
                  ).toList();
                }

                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      "No prompts found in this category.",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final prompt = list[index];
                    return ProfessionalPromptCard(
                      prompt: prompt,
                      repo: promptRepo,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
