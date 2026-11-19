class PromptModel {
  final String id;
  final String title;
  final String description;
  final String fullPrompt;
  final String category;
  final List<String> tags;
  final String thumbnailUrl;
  final String createdAt;
  bool isFavorite;
  final int viewCount;
  final double popularityScore;
  final List<String> aiModelCompatibility;

  PromptModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fullPrompt,
    required this.category,
    required this.tags,
    required this.thumbnailUrl,
    required this.createdAt,
    this.isFavorite = false,
    required this.viewCount,
    required this.popularityScore,
    required this.aiModelCompatibility,
  });

  factory PromptModel.fromJson(Map<String, dynamic> json) {
    return PromptModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      fullPrompt: json['fullPrompt'] ?? '',
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      viewCount: json['viewCount'] ?? 0,
      popularityScore: (json['popularityScore'] ?? 0.0).toDouble(),
      aiModelCompatibility: List<String>.from(json['aiModelCompatibility'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'fullPrompt': fullPrompt,
      'category': category,
      'tags': tags,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt,
      'isFavorite': isFavorite,
      'viewCount': viewCount,
      'popularityScore': popularityScore,
      'aiModelCompatibility': aiModelCompatibility,
    };
  }

  PromptModel copyWith({
    String? id,
    String? title,
    String? description,
    String? fullPrompt,
    String? category,
    List<String>? tags,
    String? thumbnailUrl,
    String? createdAt,
    bool? isFavorite,
    int? viewCount,
    double? popularityScore,
    List<String>? aiModelCompatibility,
  }) {
    return PromptModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      fullPrompt: fullPrompt ?? this.fullPrompt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      viewCount: viewCount ?? this.viewCount,
      popularityScore: popularityScore ?? this.popularityScore,
      aiModelCompatibility: aiModelCompatibility ?? this.aiModelCompatibility,
    );
  }
}
