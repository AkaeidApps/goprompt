import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF071827);
  static const Color secondaryBackground = Color(0xFF0A2235);
  static const Color cardBackground = Color(0xFF102B40);
  static const Color elevatedCard = Color(0xFF14354B);
  static const Color primary = Color(0xFF00C99A);
  static const Color secondary = Color(0xFF00AFC4);
  static const Color accent = Color(0xFF4D9BFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA8BBC9);
  static const Color border = Color(0xFF24445A);
  static const Color favorite = Color(0xFFFF5B79);
  static const Color surfaceDark = Color(0xFF040E16);

  // Reusable gradients give the UI a deeper, more "real" cinematic feel.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00C99A), Color(0xFF00AFC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xF20B2033), Color(0xB2071827)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient studioGradient = LinearGradient(
    colors: [Color(0xFF7B5CFF), Color(0xFF00AFC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient videoGradient = LinearGradient(
    colors: [Color(0xFFFF7A59), Color(0xFFFF3D81)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
