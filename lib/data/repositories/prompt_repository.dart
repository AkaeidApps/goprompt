import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goprompt/core/services/storage_service.dart';
import 'package:goprompt/data/models/prompt_model.dart';

class PromptRepository extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final RxList<PromptModel> prompts = <PromptModel>[].obs;
  final RxList<PromptModel> favoritePrompts = <PromptModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPrompts();
  }

  Future<void> loadPrompts() async {
    try {
      isLoading.value = true;
      final String jsonString = await rootBundle.loadString('assets/data/prompts.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      List<PromptModel> loaded = jsonList.map((json) => PromptModel.fromJson(json)).toList();

      // Load favorites from storage
      List<String> favIds = _storageService.getFavorites();
      for (var prompt in loaded) {
        if (favIds.contains(prompt.id)) {
          prompt.isFavorite = true;
        }
      }

      prompts.value = loaded;
      updateFavoritesList();
    } catch (e) {
      debugPrint("Error loading prompts: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(String promptId) {
    final index = prompts.indexWhere((p) => p.id == promptId);
    if (index != -1) {
      prompts[index].isFavorite = !prompts[index].isFavorite;
      prompts.refresh();

      List<String> favIds = prompts.where((p) => p.isFavorite).map((p) => p.id).toList();
      _storageService.saveFavorites(favIds);
      updateFavoritesList();
    }
  }

  void updateFavoritesList() {
    favoritePrompts.value = prompts.where((p) => p.isFavorite).toList();
  }

  List<PromptModel> getPromptsByCategory(String category) {
    if (category.toLowerCase() == 'all') return prompts;
    return prompts.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
  }

  List<PromptModel> getTrendingPrompts() {
    List<PromptModel> sorted = List.from(prompts);
    sorted.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
    return sorted;
  }

  List<PromptModel> getLatestPrompts() {
    List<PromptModel> sorted = List.from(prompts);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  List<PromptModel> searchPrompts(String query) {
    if (query.trim().isEmpty) return [];
    String q = query.toLowerCase();
    return prompts.where((p) =>
      p.title.toLowerCase().contains(q) ||
      p.description.toLowerCase().contains(q) ||
      p.category.toLowerCase().contains(q) ||
      p.tags.any((t) => t.toLowerCase().contains(q)) ||
      p.fullPrompt.toLowerCase().contains(q)
    ).toList();
  }
}
