import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class AppColors {
  static bool _isDark = true;

  static void updateBrightness(bool isDark) => _isDark = isDark;

  static Color get background => _isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8F9FA);
  static Color get surface => _isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);
  static Color get surfaceElevated => _isDark ? const Color(0xFF242424) : const Color(0xFFF0F1F3);
  static Color get textPrimary => _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF111827);
  static Color get textSecondary => _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  static Color get textTertiary => _isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);
  static Color get border => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);

  static const accent = Color(0xFFFF6B2C);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFFBBF24);
  static const danger = Color(0xFFEF4444);
}

class AppTheme {
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8F9FA);
    final surf = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);
    final surfElev = isDark ? const Color(0xFF242424) : const Color(0xFFF0F1F3);
    final txtPrimary = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF111827);
    final txtSecondary = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final txtTertiary = isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);
    final brd = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB);

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      primaryColor: AppColors.accent,
      colorScheme: isDark
          ? const ColorScheme.dark(
              primary: AppColors.accent,
              secondary: AppColors.accent,
              surface: Color(0xFF1A1A1A),
              error: AppColors.danger,
            )
          : const ColorScheme.light(
              primary: AppColors.accent,
              secondary: AppColors.accent,
              surface: Color(0xFFFFFFFF),
              error: AppColors.danger,
            ),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: TextStyle(color: txtPrimary, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(color: txtPrimary, fontWeight: FontWeight.w700),
          displaySmall: TextStyle(color: txtPrimary, fontWeight: FontWeight.w700),
          headlineLarge: TextStyle(color: txtPrimary, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(color: txtPrimary, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(color: txtPrimary, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: txtPrimary, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: txtPrimary, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(color: txtPrimary, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: txtPrimary),
          bodyMedium: TextStyle(color: txtSecondary),
          bodySmall: TextStyle(color: txtTertiary),
          labelLarge: TextStyle(color: txtPrimary, fontWeight: FontWeight.w500),
          labelMedium: TextStyle(color: txtSecondary),
          labelSmall: TextStyle(color: txtTertiary),
        ),
      ),
      cardTheme: CardThemeData(
        color: surf,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: brd, width: 0.5),
        ),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: txtPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: txtPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surf,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: txtTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: brd,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfElev,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: brd),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: brd),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        hintStyle: GoogleFonts.poppins(color: txtTertiary),
        labelStyle: GoogleFonts.poppins(color: txtSecondary),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.accent,
        unselectedLabelColor: txtTertiary,
        indicatorColor: AppColors.accent,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 13),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent;
          return txtTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent.withValues(alpha: 0.3);
          return brd;
        }),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surf,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surf,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
