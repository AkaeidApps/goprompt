import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:goprompt/core/constants/app_colors.dart';
import 'package:goprompt/features/widgets/generated_prompt_card.dart';

class PromptGeneratorView extends StatefulWidget {
  const PromptGeneratorView({super.key});

  @override
  State<PromptGeneratorView> createState() => _PromptGeneratorViewState();
}

class _PromptGeneratorViewState extends State<PromptGeneratorView> {
  final TextEditingController _sceneController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  String selectedCamera = "Cinematic Drone Shot";
  String selectedLighting = "Golden Hour";
  String selectedStyle = "Photorealistic 8K";
  String selectedMood = "Epic & Majestic";
  String selectedDuration = "5 seconds";
  String selectedAspectRatio = "16:9 widescreen";
  String selectedAiModel = "Sora / Runway Gen-2";

  String generatedPromptResult = "";
  String previewImageUrl = "";
  bool isGenerating = false;
  int _presetIndex = 0;

  static const List<String> _previewImages = [
    "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?q=80&w=1000&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=1000&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1523293182086-7651a899d37f?q=80&w=1000&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=1000&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=1000&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=1000&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1614728894747-a83421e2b9c9?q=80&w=1000&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1000&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?q=80&w=1000&auto=format&fit=crop",
  ];

  final List<String> cameras = [
    "Cinematic Drone Shot",
    "Close-up Macro",
    "FPV Drone Dive",
    "Panning Tracking Shot",
    "Static Tripod",
  ];

  final List<String> lightings = [
    "Golden Hour",
    "Neon Cyberpunk",
    "Moody Cinematic",
    "Bright Daylight",
    "Studio Softbox",
  ];

  final List<String> styles = [
    "Photorealistic 8K",
    "Studio Ghibli Anime",
    "3D Pixar Animation",
    "Dark Fantasy Art",
    "Documentary Style",
  ];

  final List<String> moods = [
    "Epic & Majestic",
    "Suspenseful & Dark",
    "Serene & Peaceful",
    "Energetic & Fast",
    "Whimsical & Magical",
  ];

  final List<String> durations = ["5 seconds", "10 seconds", "15 seconds"];
  final List<String> aspectRatios = ["16:9 widescreen", "9:16 vertical", "1:1 square"];
  final List<String> aiModels = [
    "Sora / Runway Gen-2",
    "Pika Labs",
    "Stable Video Diffusion",
    "Midjourney v6",
  ];

  /// One-tap scene presets with a real thumbnail for a visual quick-start.
  final List<Map<String, String>> quickPresets = [
    {
      "name": "Cyberpunk Chase",
      "emoji": "⚡",
      "scene": "A futuristic cyberpunk warrior riding a glowing motorcycle",
      "details": "rain-slicked neon Tokyo streets at midnight, smoke trails",
      "camera": "FPV Drone Dive",
      "lighting": "Neon Cyberpunk",
      "style": "Photorealistic 8K",
      "mood": "Energetic & Fast",
      "image": _previewImages[0],
    },
    {
      "name": "Epic Dragon",
      "emoji": "🐉",
      "scene": "A majestic giant dragon soaring through clouds",
      "details": "snow-capped mountain peaks during a golden sunset",
      "camera": "Cinematic Drone Shot",
      "lighting": "Golden Hour",
      "style": "Photorealistic 8K",
      "mood": "Epic & Majestic",
      "image": _previewImages[7],
    },
    {
      "name": "Luxury Ad",
      "emoji": "💎",
      "scene": "An elegant glass perfume bottle floating in golden water droplets",
      "details": "dark obsidian reflective studio surface, slow motion",
      "camera": "Close-up Macro",
      "lighting": "Studio Softbox",
      "style": "Photorealistic 8K",
      "mood": "Serene & Peaceful",
      "image": _previewImages[2],
    },
    {
      "name": "Ghibli Forest",
      "emoji": "🌲",
      "scene": "A young magical spirit walking among glowing plants",
      "details": "enchanted ancient deep woods at night, floating spores",
      "camera": "Panning Tracking Shot",
      "lighting": "Moody Cinematic",
      "style": "Studio Ghibli Anime",
      "mood": "Whimsical & Magical",
      "image": _previewImages[8],
    },
    {
      "name": "Ocean Giant",
      "emoji": "🐋",
      "scene": "A humpback whale gliding through turquoise ocean water",
      "details": "sunbeams and god rays, small fish swimming alongside",
      "camera": "Cinematic Drone Shot",
      "lighting": "Bright Daylight",
      "style": "Documentary Style",
      "mood": "Serene & Peaceful",
      "image": _previewImages[3],
    },
    {
      "name": "Mars Mission",
      "emoji": "🛸",
      "scene": "An autonomous rover crossing red Martian dunes",
      "details": "swirling dust storm, eerie blood-red sunset glow",
      "camera": "Panning Tracking Shot",
      "lighting": "Moody Cinematic",
      "style": "Documentary Style",
      "mood": "Suspenseful & Dark",
      "image": _previewImages[6],
    },
  ];

  final List<String> ideaStarters = [
    "A neon samurai in rainy Tokyo",
    "A dragon over snowy peaks",
    "A luxury watch in a dark studio",
    "A cute robot finding a flower",
  ];

  void _showSnack(String title, String message, {bool success = true}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.cardBackground,
      colorText: success ? AppColors.primary : AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _loadPreset(int index) {
    final preset = quickPresets[index];
    setState(() {
      _presetIndex = index;
      _sceneController.text = preset["scene"]!;
      _detailsController.text = preset["details"]!;
      selectedCamera = preset["camera"]!;
      selectedLighting = preset["lighting"]!;
      selectedStyle = preset["style"]!;
      selectedMood = preset["mood"]!;
      previewImageUrl = preset["image"]!;
    });
    _generatePrompt();
  }

  void _randomize() {
    _loadPreset((_presetIndex + 1) % quickPresets.length);
  }

  void _applyIdea(String idea) {
    setState(() {
      _sceneController.text = idea;
      generatedPromptResult = "";
    });
  }

  void _clearAll() {
    setState(() {
      _sceneController.clear();
      _detailsController.clear();
      generatedPromptResult = "";
      previewImageUrl = "";
      isGenerating = false;
    });
  }

  String _pickImage(String seed) {
    final hash = seed.codeUnits.fold<int>(0, (sum, char) => sum + char);
    return _previewImages[hash % _previewImages.length];
  }

  void _generatePrompt() {
    final scene = _sceneController.text.trim();
    if (scene.isEmpty) {
      _showSnack("Add a scene first", "Describe your idea in one line to build a prompt.",
          success: false);
      return;
    }

    setState(() => isGenerating = true);

    // Short delay makes the preview feel like a real generation pipeline.
    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      final cleanScene = scene.replaceAll(RegExp(r'[\s.!?]+$'), '');
      final details = _detailsController.text.trim();
      final buffer = StringBuffer()
        ..write('$cleanScene. ')
        ..write('Shot with $selectedCamera, $selectedLighting lighting. ')
        ..write('$selectedStyle visual style, $selectedMood mood. ');
      if (details.isNotEmpty) buffer.write('Details: $details. ');
      buffer.write(
        'Optimized for $selectedAiModel, $selectedAspectRatio, $selectedDuration, '
        'smooth cinematic motion, anamorphic lens flare, ultra-detailed 4K.',
      );

      setState(() {
        generatedPromptResult = buffer.toString();
        previewImageUrl = _pickImage(scene + selectedStyle);
        isGenerating = false;
      });
    });
  }

  void _copyToClipboard() {
    if (generatedPromptResult.isEmpty) return;
    Clipboard.setData(ClipboardData(text: generatedPromptResult));
    _showSnack("Prompt copied", "Paste it into your favourite AI video tool.");
  }

  void _sharePrompt() {
    if (generatedPromptResult.isEmpty) return;
    Share.share("AI video prompt:\n\n$generatedPromptResult");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 22),

              _sectionTitle("Quick start", subtitle: "Tap a scene to auto-fill"),
              const SizedBox(height: 10),
              SizedBox(
                height: 104,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: quickPresets.length,
                  itemBuilder: (context, index) =>
                      _buildPresetCard(quickPresets[index], index),
                ),
              ),
              const SizedBox(height: 22),

              _sectionTitle("Describe your scene",
                  subtitle: "One sentence is enough"),
              const SizedBox(height: 10),
              _buildSceneInput(),
              const SizedBox(height: 12),
              _buildDetailsInput(),
              const SizedBox(height: 18),

              _sectionTitle("Fine-tune the look",
                  subtitle: "Optional — tap to change"),
              const SizedBox(height: 10),
              _buildOptionGroup("Camera", Icons.videocam_rounded,
                  cameras, selectedCamera, (value) => selectedCamera = value),
              const SizedBox(height: 12),
              _buildOptionGroup("Lighting", Icons.wb_sunny_rounded,
                  lightings, selectedLighting, (value) => selectedLighting = value),
              const SizedBox(height: 12),
              _buildOptionGroup("Visual style", Icons.palette_rounded,
                  styles, selectedStyle, (value) => selectedStyle = value),
              const SizedBox(height: 12),
              _buildOptionGroup("Mood", Icons.mood_rounded,
                  moods, selectedMood, (value) => selectedMood = value),
              const SizedBox(height: 12),
              _buildAdvancedControls(),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isGenerating ? null : _generatePrompt,
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.auto_awesome_rounded,
                                    size: 19, color: AppColors.background),
                                const SizedBox(width: 8),
                                Text(
                                  isGenerating ? "Generating..." : "Generate Prompt",
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.background,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: _clearAll,
                    child: const Text(
                      "Clear",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                ],
              ),

              if (isGenerating || generatedPromptResult.isNotEmpty) ...[
                const SizedBox(height: 22),
                GeneratedPromptCard(
                  prompt: generatedPromptResult,
                  imageUrl: previewImageUrl,
                  styleLabel: selectedStyle.split(' ').first,
                  duration: selectedDuration,
                  isLoading: isGenerating,
                  meta: {
                    "Model": selectedAiModel.split(' / ').first,
                    "Camera": selectedCamera.replaceAll(" Shot", ""),
                    "Light": selectedLighting,
                    "Mood": selectedMood,
                    "Ratio": selectedAspectRatio.split(' ').first,
                  },
                  onCopy: _copyToClipboard,
                  onShare: _sharePrompt,
                  onRegenerate: _randomize,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            gradient: AppColors.studioGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.25),
                blurRadius: 14,
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome_rounded,
              color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AI Prompt Studio",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Pro prompts for Sora, Runway & Pika",
                style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _randomize,
          icon: const Icon(Icons.shuffle_rounded, color: AppColors.primary),
          tooltip: "Surprise me",
          style: IconButton.styleFrom(
            backgroundColor: AppColors.cardBackground,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, {String? subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
          ),
      ],
    );
  }

  Widget _buildPresetCard(Map<String, String> preset, int index) {
    final isSelected = _presetIndex == index;
    return GestureDetector(
      onTap: () => _loadPreset(index),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: preset["image"]!,
              fit: BoxFit.cover,
              placeholder: (context, url) => _presetPlaceholder(),
              errorWidget: (context, url, error) => _presetPlaceholder(),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x33041420), Color(0xEE04141F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: 7,
              left: 8,
              child: Text(preset["emoji"]!,
                  style: const TextStyle(fontSize: 17)),
            ),
            Positioned(
              left: 9,
              right: 9,
              bottom: 9,
              child: Text(
                preset["name"]!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _presetPlaceholder() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.studioGradient),
      child: const Center(
        child: Icon(Icons.auto_awesome_rounded, color: Colors.white54),
      ),
    );
  }

  Widget _buildSceneInput() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tips_and_updates_rounded,
                  size: 16, color: AppColors.primary),
              SizedBox(width: 7),
              Text(
                "What do you want to see?",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _sceneController,
            minLines: 3,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: "e.g. A neon samurai walking through rainy Tokyo at night...",
              hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surfaceDark,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 2),
                child: Text(
                  "Ideas:",
                  style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                ),
              ),
              ...ideaStarters.map(
                (idea) => GestureDetector(
                  onTap: () => _applyIdea(idea),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.elevatedCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      idea,
                      style: const TextStyle(
                          fontSize: 9.5, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsInput() {
    return TextField(
      controller: _detailsController,
      maxLines: 2,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.note_add_rounded,
            size: 18, color: AppColors.textSecondary),
        hintText: "Extra details (optional) — colours, lens, motion...",
        hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.cardBackground,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildOptionGroup(String label, IconData icon, List<String> options,
      String selected, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 34,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = option == selected;
              return Padding(
                padding: const EdgeInsets.only(right: 7),
                child: ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (_) => setState(() => onChanged(option)),
                  backgroundColor: AppColors.cardBackground,
                  selectedColor: AppColors.primary.withValues(alpha: 0.18),
                  labelStyle: TextStyle(
                    fontSize: 10.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  visualDensity: VisualDensity.compact,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedControls() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 6),
        leading: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
        title: const Text(
          "More controls",
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          "$selectedAiModel  •  ${selectedAspectRatio.split(' ').first}  •  $selectedDuration",
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.expand_more_rounded,
            color: AppColors.textSecondary),
        children: [
          _buildDropdown("AI Target Model", selectedAiModel, aiModels,
              (value) => setState(() => selectedAiModel = value!)),
          const SizedBox(height: 10),
          _buildDropdown("Duration", selectedDuration, durations,
              (value) => setState(() => selectedDuration = value!)),
          const SizedBox(height: 10),
          _buildDropdown("Aspect Ratio", selectedAspectRatio, aspectRatios,
              (value) => setState(() => selectedAspectRatio = value!)),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String currentVal, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentVal,
              isExpanded: true,
              dropdownColor: AppColors.cardBackground,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5),
              items: items
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
