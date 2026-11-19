import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goprompt/core/constants/app_colors.dart';
import 'package:goprompt/data/models/prompt_model.dart';
import 'package:goprompt/data/repositories/prompt_repository.dart';
import 'package:goprompt/features/widgets/prompt_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final PromptRepository promptRepo = Get.find<PromptRepository>();
  final TextEditingController _searchController = TextEditingController();
  final RxList<PromptModel> searchResults = <PromptModel>[].obs;
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args is Map && args['category'] != null) {
      String cat = args['category'];
      _searchController.text = cat;
      _onSearch(cat);
    }
  }

  void _onSearch(String query) {
    setState(() {
      hasSearched = true;
    });
    searchResults.value = promptRepo.searchPrompts(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Search prompts by title, tag, category...",
                        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: _onSearch,
                    ),
                  ),
                ],
              ),
            ),

            // Results Grid
            Expanded(
              child: Obx(() {
                if (!hasSearched || _searchController.text.isEmpty) {
                  return const Center(
                    child: Text(
                      "Type keywords or categories to search prompts.",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                if (searchResults.isEmpty) {
                  return const Center(
                    child: Text(
                      "No matching prompts found.",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final prompt = searchResults[index];
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
