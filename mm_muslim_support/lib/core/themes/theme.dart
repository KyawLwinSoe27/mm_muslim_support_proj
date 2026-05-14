import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1B7A4A),
      surfaceTint: Color(0xFF1B7A4A),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFB3F1BE),
      onPrimaryContainer: Color(0xFF00210C),
      secondary: Color(0xFF0E6B58),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFA2F2DA),
      onSecondaryContainer: Color(0xFF002019),
      tertiary: Color(0xFF006877),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFA2EEFF),
      onTertiaryContainer: Color(0xFF004E5A),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFF8FBF6),
      onSurface: Color(0xFF1A1C19),
      onSurfaceVariant: Color(0xFF434743),
      outline: Color(0xFF737772),
      outlineVariant: Color(0xFFC3C7C1),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2F312E),
      inversePrimary: Color(0xFF98D4A4),
      primaryFixed: Color(0xFFB3F1BE),
      onPrimaryFixed: Color(0xFF00210C),
      primaryFixedDim: Color(0xFF98D4A4),
      onPrimaryFixedVariant: Color(0xFF00522A),
      secondaryFixed: Color(0xFFA2F2DA),
      onSecondaryFixed: Color(0xFF002019),
      secondaryFixedDim: Color(0xFF86D6BE),
      onSecondaryFixedVariant: Color(0xFF005141),
      tertiaryFixed: Color(0xFFA2EEFF),
      onTertiaryFixed: Color(0xFF001F25),
      tertiaryFixedDim: Color(0xFF83D2E3),
      onTertiaryFixedVariant: Color(0xFF004E5A),
      surfaceDim: Color(0xFFD8DBD5),
      surfaceBright: Color(0xFFF8FBF6),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF2F5F0),
      surfaceContainer: Color(0xFFECEFEA),
      surfaceContainerHigh: Color(0xFFE6EAE4),
      surfaceContainerHighest: Color(0xFFE1E4DE),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF98D4A4),
      surfaceTint: Color(0xFF98D4A4),
      onPrimary: Color(0xFF00391A),
      primaryContainer: Color(0xFF00522A),
      onPrimaryContainer: Color(0xFFB3F1BE),
      secondary: Color(0xFF86D6BE),
      onSecondary: Color(0xFF00382B),
      secondaryContainer: Color(0xFF005141),
      onSecondaryContainer: Color(0xFFA2F2DA),
      tertiary: Color(0xFF83D2E3),
      onTertiary: Color(0xFF003640),
      tertiaryContainer: Color(0xFF004E5A),
      onTertiaryContainer: Color(0xFFA2EEFF),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF121412),
      onSurface: Color(0xFFE1E4DE),
      onSurfaceVariant: Color(0xFFC3C7C1),
      outline: Color(0xFF8D918C),
      outlineVariant: Color(0xFF434743),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE1E4DE),
      inversePrimary: Color(0xFF1B7A4A),
      primaryFixed: Color(0xFFB3F1BE),
      onPrimaryFixed: Color(0xFF00210C),
      primaryFixedDim: Color(0xFF98D4A4),
      onPrimaryFixedVariant: Color(0xFF00522A),
      secondaryFixed: Color(0xFFA2F2DA),
      onSecondaryFixed: Color(0xFF002019),
      secondaryFixedDim: Color(0xFF86D6BE),
      onSecondaryFixedVariant: Color(0xFF005141),
      tertiaryFixed: Color(0xFFA2EEFF),
      onTertiaryFixed: Color(0xFF001F25),
      tertiaryFixedDim: Color(0xFF83D2E3),
      onTertiaryFixedVariant: Color(0xFF004E5A),
      surfaceDim: Color(0xFF121412),
      surfaceBright: Color(0xFF373A37),
      surfaceContainerLowest: Color(0xFF0C0F0C),
      surfaceContainerLow: Color(0xFF1A1C1A),
      surfaceContainer: Color(0xFF1E201E),
      surfaceContainerHigh: Color(0xFF282B28),
      surfaceContainerHighest: Color(0xFF333633),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        indicatorColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primaryContainer;
          return colorScheme.surfaceContainerHighest;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: BorderSide(color: colorScheme.onSurfaceVariant),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        thickness: 0.5,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colorScheme.surface,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: colorScheme.surface,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  ThemeData lightHighContrast() => light();
  ThemeData darkHighContrast() => dark();
}
