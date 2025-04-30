import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff316a42),
      surfaceTint: Color(0xff316a42),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb3f1be),
      onPrimaryContainer: Color(0xff16512c),
      secondary: Color(0xff0e6b58),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffa2f2da),
      onSecondaryContainer: Color(0xff005141),
      tertiary: Color(0xff006877),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa2eeff),
      onTertiaryContainer: Color(0xff004e5a),
      error: Color(0xff904a43),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad5),
      onErrorContainer: Color(0xff73342d),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff181d18),
      onSurfaceVariant: Color(0xff414941),
      outline: Color(0xff717971),
      outlineVariant: Color(0xffc1c9bf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff98d4a4),
      primaryFixed: Color(0xffb3f1be),
      onPrimaryFixed: Color(0xff00210c),
      primaryFixedDim: Color(0xff98d4a4),
      onPrimaryFixedVariant: Color(0xff16512c),
      secondaryFixed: Color(0xffa2f2da),
      onSecondaryFixed: Color(0xff002019),
      secondaryFixedDim: Color(0xff86d6be),
      onSecondaryFixedVariant: Color(0xff005141),
      tertiaryFixed: Color(0xffa2eeff),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xff83d2e3),
      onTertiaryFixedVariant: Color(0xff004e5a),
      surfaceDim: Color(0xffd7dbd4),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ed),
      surfaceContainer: Color(0xffebefe8),
      surfaceContainerHigh: Color(0xffe5eae2),
      surfaceContainerHighest: Color(0xffdfe4dc),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003f1d),
      surfaceTint: Color(0xff316a42),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff40794f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003e32),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff267a66),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003c45),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1b7787),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5e231e),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffa25850),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff0d120e),
      onSurfaceVariant: Color(0xff303831),
      outline: Color(0xff4d544d),
      outlineVariant: Color(0xff676f67),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff98d4a4),
      primaryFixed: Color(0xff40794f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff276039),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff267a66),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00604f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1b7787),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff005e6b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc3c8c1),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ed),
      surfaceContainer: Color(0xffe5eae2),
      surfaceContainerHigh: Color(0xffd9ded7),
      surfaceContainerHighest: Color(0xffced3cc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003417),
      surfaceTint: Color(0xff316a42),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff19542e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003328),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff005344),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003139),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00515d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff511a15),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff76362f),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff262e27),
      outlineVariant: Color(0xff434b44),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff98d4a4),
      primaryFixed: Color(0xff19542e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003b1b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff005344),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003a2f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff00515d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003841),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb5bab3),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf2ea),
      surfaceContainer: Color(0xffdfe4dc),
      surfaceContainerHigh: Color(0xffd1d6ce),
      surfaceContainerHighest: Color(0xffc3c8c1),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff98d4a4),
      surfaceTint: Color(0xff98d4a4),
      onPrimary: Color(0xff003919),
      primaryContainer: Color(0xff16512c),
      onPrimaryContainer: Color(0xffb3f1be),
      secondary: Color(0xff86d6be),
      onSecondary: Color(0xff00382c),
      secondaryContainer: Color(0xff005141),
      onSecondaryContainer: Color(0xffa2f2da),
      tertiary: Color(0xff83d2e3),
      onTertiary: Color(0xff00363e),
      tertiaryContainer: Color(0xff004e5a),
      onTertiaryContainer: Color(0xffa2eeff),
      error: Color(0xffffb4ab),
      onError: Color(0xff561e19),
      errorContainer: Color(0xff73342d),
      onErrorContainer: Color(0xffffdad5),
      surface: Color(0xff101510),
      onSurface: Color(0xffdfe4dc),
      onSurfaceVariant: Color(0xffc1c9bf),
      outline: Color(0xff8b938a),
      outlineVariant: Color(0xff414941),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inversePrimary: Color(0xff316a42),
      primaryFixed: Color(0xffb3f1be),
      onPrimaryFixed: Color(0xff00210c),
      primaryFixedDim: Color(0xff98d4a4),
      onPrimaryFixedVariant: Color(0xff16512c),
      secondaryFixed: Color(0xffa2f2da),
      onSecondaryFixed: Color(0xff002019),
      secondaryFixedDim: Color(0xff86d6be),
      onSecondaryFixedVariant: Color(0xff005141),
      tertiaryFixed: Color(0xffa2eeff),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xff83d2e3),
      onTertiaryFixedVariant: Color(0xff004e5a),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff353a35),
      surfaceContainerLowest: Color(0xff0a0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313631),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffadebb8),
      surfaceTint: Color(0xff98d4a4),
      onPrimary: Color(0xff002d13),
      primaryContainer: Color(0xff639d71),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff9cecd4),
      onSecondary: Color(0xff002c22),
      secondaryContainer: Color(0xff4f9f89),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff99e9fa),
      onTertiary: Color(0xff002a31),
      tertiaryContainer: Color(0xff4a9cac),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff48130f),
      errorContainer: Color(0xffcc7b72),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd6dfd5),
      outline: Color(0xffacb4ab),
      outlineVariant: Color(0xff8a928a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inversePrimary: Color(0xff18522d),
      primaryFixed: Color(0xffb3f1be),
      onPrimaryFixed: Color(0xff001506),
      primaryFixedDim: Color(0xff98d4a4),
      onPrimaryFixedVariant: Color(0xff003f1d),
      secondaryFixed: Color(0xffa2f2da),
      onSecondaryFixed: Color(0xff00150f),
      secondaryFixedDim: Color(0xff86d6be),
      onSecondaryFixedVariant: Color(0xff003e32),
      tertiaryFixed: Color(0xffa2eeff),
      onTertiaryFixed: Color(0xff001418),
      tertiaryFixedDim: Color(0xff83d2e3),
      onTertiaryFixedVariant: Color(0xff003c45),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff414640),
      surfaceContainerLowest: Color(0xff050805),
      surfaceContainerLow: Color(0xff1a1f1a),
      surfaceContainer: Color(0xff242924),
      surfaceContainerHigh: Color(0xff2f342f),
      surfaceContainerHighest: Color(0xff3a3f3a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc0ffcb),
      surfaceTint: Color(0xff98d4a4),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff94d1a0),
      onPrimaryContainer: Color(0xff000f04),
      secondary: Color(0xffb4ffe7),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff82d2ba),
      onSecondaryContainer: Color(0xff000e0a),
      tertiary: Color(0xffd2f6ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff7fcedf),
      onTertiaryContainer: Color(0xff000d11),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220000),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeaf2e8),
      outlineVariant: Color(0xffbdc5bb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inversePrimary: Color(0xff18522d),
      primaryFixed: Color(0xffb3f1be),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff98d4a4),
      onPrimaryFixedVariant: Color(0xff001506),
      secondaryFixed: Color(0xffa2f2da),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff86d6be),
      onSecondaryFixedVariant: Color(0xff00150f),
      tertiaryFixed: Color(0xffa2eeff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff83d2e3),
      onTertiaryFixedVariant: Color(0xff001418),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff4c514c),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c211c),
      surfaceContainer: Color(0xff2c322d),
      surfaceContainerHigh: Color(0xff373d38),
      surfaceContainerHighest: Color(0xff434843),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.secondary,
      foregroundColor: colorScheme.onSecondary,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: colorScheme.surface,
      scrimColor: colorScheme.scrim,
    ),
    bottomNavigationBarTheme: (BottomNavigationBarThemeData(
      backgroundColor: colorScheme.secondary,
      selectedItemColor: colorScheme.primaryContainer,
      unselectedItemColor: colorScheme.onSecondary,
    )),
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
