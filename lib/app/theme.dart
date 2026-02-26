import 'package:flutter/material.dart';

ThemeData buildAppTheme() => AppTheme.lightTheme;

class AppTheme {
  static const Color _primary = Color(0xFF0A84FF);
  static const Color _surface = Color(0xFFF3F6FB);
  static const Color _card = Color(0xFFFFFFFF);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primary,
        onPrimary: Colors.white,
        secondary: Color(0xFF34C759),
        onSecondary: Colors.white,
        error: Color(0xFFFF3B30),
        onError: Colors.white,
        surface: _surface,
        onSurface: Color(0xFF1D1D1F),
        outline: Color(0xFFD8DFEB),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: base.colorScheme,
      scaffoldBackgroundColor: _surface,
      fontFamily: 'SF Pro Text',
      appBarTheme: AppBarTheme(
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        centerTitle: false,
        backgroundColor: const Color(0xFF0B6FE3),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: _card,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: base.colorScheme.outline.withValues(alpha: 0.55),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xFF3A3A3C),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.22),
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          foregroundColor: _primary,
          side: BorderSide(color: _primary.withValues(alpha: 0.35)),
          backgroundColor: _primary.withValues(alpha: 0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: _primary,
          backgroundColor: _primary.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: _primary.withValues(alpha: 0.22)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.96),
        indicatorColor: _primary.withValues(alpha: 0.14),
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? _primary : const Color(0xFF5B6470),
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? _primary : const Color(0xFF6C7482),
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 12,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.92),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: base.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: base.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
      ),
      checkboxTheme: const CheckboxThemeData(shape: CircleBorder()),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return const Color(0xFFFAFAFA);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primary;
          return const Color(0xFFE5EAF3);
        }),
      ),
      chipTheme: ChipThemeData(
        selectedColor: _primary.withValues(alpha: 0.12),
        side: BorderSide(color: base.colorScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme;
  }
}
