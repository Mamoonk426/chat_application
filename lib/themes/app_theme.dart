import 'package:flutter/material.dart';

// =============================================================================
// COLOR PALETTE — based on Color Style Guide
// =============================================================================

class AppColors {
  // ── Primary (Teal / Cyan scale) ──────────────────────────────────────────
  static const Color primary50 = Color(0xFFDBFAF8);
  static const Color primary100 = Color(0xFFAFF3EF);
  static const Color primary200 = Color(0xFF83EDE6);
  static const Color primary300 = Color(0xFF56E6DD);
  static const Color primary400 = Color(0xFF2ADFD4);
  static const Color primary500 = Color(0xFF1CBBB0); // main primary
  static const Color primary600 = Color(0xFF158E86);
  static const Color primary700 = Color(0xFF0E625C);
  static const Color primary800 = Color(0xFF083633);
  static const Color primary900 = Color(0xFF052422);

  // ── Secondary (Yellow-Green / Lime scale) ────────────────────────────────
  static const Color secondary50 = Color(0xFFFAFFE5);
  static const Color secondary100 = Color(0xFFEFFFB2);
  static const Color secondary200 = Color(0xFFE5FF80);
  static const Color secondary300 = Color(0xFFDBFF4D);
  static const Color secondary400 = Color(0xFFD0FF1A); // vibrant accent
  static const Color secondary500 = Color(0xFFC7FA00); // main secondary
  static const Color secondary600 = Color(0xFF9EC700);
  static const Color secondary700 = Color(0xFF769400);
  static const Color secondary800 = Color(0xFF4D6100);
  static const Color secondary900 = Color(0xFF252E00);

  // ── Greys ─────────────────────────────────────────────────────────────────
  static const Color grey0 = Color(0xFFFFFFFF);
  static const Color grey100 = Color(0xFFF4F4F4);
  static const Color grey200 = Color(0xFFCCCCCC);
  static const Color grey300 = Color(0xFFB3B3B3);
  static const Color grey400 = Color(0xFF999999);
  static const Color grey500 = Color(0xFF808080);
  static const Color grey600 = Color(0xFF666666);
  static const Color grey700 = Color(0xFF4D4D4D);
  static const Color grey800 = Color(0xFF333333);
  static const Color grey900 = Color(0xFF000000);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF1CBBB0);
  static const Color warning = Color(0xFFD0FF1A);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF56E6DD);

  // ── Surface / Background (light) ─────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFF4F4F4);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF083633);

  // ── Surface / Background (dark) ──────────────────────────────────────────
  static const Color surfaceDark = Color(0xFF0E625C);
  static const Color backgroundDark = Color(0xFF052422);
  static const Color onSurfaceDark = Color(0xFFDBFAF8);
}

// =============================================================================
// TEXT STYLES
// =============================================================================

class AppTextStyles {
  AppTextStyles._();

  // Use GoogleFonts in your project:
  //   flutter pub add google_fonts
  //   import 'package:google_fonts/google_fonts.dart';
  // Then replace TextStyle(...) with GoogleFonts.poppins(...) etc.

  static const String _fontFamily = 'Poppins'; // swap with GoogleFonts

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w700,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.22,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}

// =============================================================================
// COLOR SCHEME HELPERS
// =============================================================================

const ColorScheme _lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary
  primary: AppColors.primary500,
  onPrimary: AppColors.grey0,
  primaryContainer: AppColors.primary100,
  onPrimaryContainer: AppColors.primary900,

  // Secondary
  secondary: AppColors.secondary500,
  onSecondary: AppColors.secondary900,
  secondaryContainer: AppColors.secondary100,
  onSecondaryContainer: AppColors.secondary900,

  // Tertiary — a muted teal mid-tone
  tertiary: AppColors.primary300,
  onTertiary: AppColors.primary900,
  tertiaryContainer: AppColors.primary50,
  onTertiaryContainer: AppColors.primary800,

  // Error
  error: AppColors.error,
  onError: AppColors.grey0,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),

  // Surface
  surface: AppColors.surfaceLight,
  onSurface: AppColors.onSurfaceLight,
  surfaceContainerHighest: AppColors.grey200,

  // Outline
  outline: AppColors.grey400,
  outlineVariant: AppColors.grey200,

  // Inverse
  inverseSurface: AppColors.grey800,
  onInverseSurface: AppColors.grey100,
  inversePrimary: AppColors.primary200,

  // Shadow / scrim
  shadow: AppColors.grey900,
  scrim: AppColors.grey900,
);

const ColorScheme _darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary
  primary: AppColors.primary300,
  onPrimary: AppColors.primary900,
  primaryContainer: AppColors.primary700,
  onPrimaryContainer: AppColors.primary50,

  // Secondary
  secondary: AppColors.secondary400,
  onSecondary: AppColors.secondary900,
  secondaryContainer: AppColors.secondary800,
  onSecondaryContainer: AppColors.secondary100,

  // Tertiary
  tertiary: AppColors.primary400,
  onTertiary: AppColors.primary900,
  tertiaryContainer: AppColors.primary800,
  onTertiaryContainer: AppColors.primary100,

  // Error
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),

  // Surface
  surface: AppColors.backgroundDark,
  onSurface: AppColors.onSurfaceDark,
  surfaceContainerHighest: AppColors.primary800,

  // Outline
  outline: AppColors.grey500,
  outlineVariant: AppColors.grey700,

  // Inverse
  inverseSurface: AppColors.grey100,
  onInverseSurface: AppColors.grey800,
  inversePrimary: AppColors.primary600,

  // Shadow / scrim
  shadow: AppColors.grey900,
  scrim: AppColors.grey900,
);

// =============================================================================
// THEME DATA
// =============================================================================

class AppTheme {
  AppTheme._();

  // ─── Shared radius ───────────────────────────────────────────────────────
  static const double _radiusSm = 8.0;
  static const double _radiusMd = 12.0;
  static const double _radiusLg = 16.0;
  static const double _radiusXl = 24.0;

  // ─── Elevation ────────────────────────────────────────────────────────────
  static const double _elevationCard = 5.0;
  static const double _elevationDialog = 6.0;
  static const double _elevationNavBar = 8.0;

  // =========================================================================
  // LIGHT THEME
  // =========================================================================
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    brightness: Brightness.light,

    // ── Typography ────────────────────────────────────────────────────────
    textTheme:
        const TextTheme(
          displayLarge: AppTextStyles.displayLarge,
          displayMedium: AppTextStyles.displayMedium,
          displaySmall: AppTextStyles.displaySmall,
          headlineLarge: AppTextStyles.headlineLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          headlineSmall: AppTextStyles.headlineSmall,
          titleLarge: AppTextStyles.titleLarge,
          titleMedium: AppTextStyles.titleMedium,
          titleSmall: AppTextStyles.titleSmall,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.labelLarge,
          labelMedium: AppTextStyles.labelMedium,
          labelSmall: AppTextStyles.labelSmall,
        ).apply(
          bodyColor: AppColors.onSurfaceLight,
          displayColor: AppColors.onSurfaceLight,
        ),

    // ── Scaffold ─────────────────────────────────────────────────────────
    scaffoldBackgroundColor: AppColors.backgroundLight,

    // ── AppBar ────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary500,
      foregroundColor: AppColors.grey0,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.grey0,
      ),
      iconTheme: IconThemeData(color: AppColors.grey0),
    ),

    // ── Bottom Navigation Bar ─────────────────────────────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary500,
      selectedItemColor: AppColors.grey900,
      unselectedItemColor: AppColors.grey400,
      elevation: _elevationNavBar,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    ),

    // ── NavigationBar (M3) ────────────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.grey0,
      indicatorColor: AppColors.primary100,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary600);
        }
        return const IconThemeData(color: AppColors.grey500);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppColors.primary600,
          );
        }
        return const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: AppColors.grey500,
        );
      }),
      elevation: _elevationNavBar,
    ),

    // ── Elevated Button ───────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.grey0,
        disabledBackgroundColor: AppColors.grey200,
        disabledForegroundColor: AppColors.grey400,
        elevation: 4,
        shadowColor: AppColors.primary500.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // ── Filled Button ─────────────────────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.grey0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // ── Outlined Button ───────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary500,
        side: const BorderSide(color: AppColors.primary500, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // ── Text Button ───────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusSm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // ── FloatingActionButton ──────────────────────────────────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary900,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // ── Card ──────────────────────────────────────────────────────────────
    // ── Card ──────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.primary50, // teal-tinted surface instead of pure white
      elevation: 6, // slightly higher elevation
      shadowColor: AppColors.primary600.withOpacity(
        0.25,
      ), // stronger, colored shadow
      surfaceTintColor: AppColors.primary200, // M3 tint for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusLg),
        side: const BorderSide(
          color: AppColors.primary200, // subtle teal border
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // ── Input Decoration ──────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.primary50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.grey300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.primary500, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
      prefixIconColor: AppColors.primary500,
      suffixIconColor: AppColors.grey500,
    ),

    // ── Chip ──────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.primary50,
      selectedColor: AppColors.primary500,
      secondarySelectedColor: AppColors.secondary500,
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: AppColors.primary700,
      ),
      secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(
        color: AppColors.grey0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusXl),
        side: const BorderSide(color: AppColors.primary200),
      ),
    ),

    // ── Dialog ────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.grey0,
      elevation: _elevationDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusXl),
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.primary800,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.grey700,
      ),
    ),

    // ── BottomSheet ───────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.grey0,
      modalBackgroundColor: AppColors.grey0,
      elevation: _elevationDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_radiusXl)),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // ── Snack Bar ─────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary800,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.primary50,
      ),
      actionTextColor: AppColors.secondary400,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
      ),
    ),

    // ── Divider ───────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.grey200,
      thickness: 1,
      space: 1,
    ),

    // ── Switch ────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.grey0;
        return AppColors.grey400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary500;
        return AppColors.grey200;
      }),
    ),

    // ── Checkbox ─────────────────────────────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary500;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.grey0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(color: AppColors.grey400, width: 1.5),
    ),

    // ── Radio ─────────────────────────────────────────────────────────────
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary500;
        return AppColors.grey400;
      }),
    ),

    // ── Slider ────────────────────────────────────────────────────────────
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primary500,
      inactiveTrackColor: AppColors.primary100,
      thumbColor: AppColors.primary500,
      overlayColor: Color(0x291CBBB0),
      valueIndicatorColor: AppColors.primary700,
      valueIndicatorTextStyle: TextStyle(
        color: AppColors.grey0,
        fontFamily: 'Poppins',
        fontSize: 12,
      ),
    ),

    // ── Progress Indicator ────────────────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary500,
      linearTrackColor: AppColors.primary100,
      circularTrackColor: AppColors.primary100,
    ),

    // ── Tab Bar ───────────────────────────────────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary500,
      unselectedLabelColor: AppColors.grey500,
      indicatorColor: AppColors.primary500,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    ),

    // ── List Tile ────────────────────────────────────────────────────────
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.primary500,
      textColor: AppColors.onSurfaceLight,
      tileColor: Colors.transparent,
      selectedTileColor: AppColors.primary50,
      selectedColor: AppColors.primary600,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_radiusMd)),
      ),
    ),

    // ── Icon ─────────────────────────────────────────────────────────────
    iconTheme: const IconThemeData(color: AppColors.primary600, size: 24),

    // ── Drawer ────────────────────────────────────────────────────────────
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.grey0,
      elevation: _elevationDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(_radiusXl),
        ),
      ),
    ),

    // ── Tooltip ───────────────────────────────────────────────────────────
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.primary800,
        borderRadius: BorderRadius.circular(_radiusSm),
      ),
      textStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.primary50),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );

  // =========================================================================
  // DARK THEME
  // =========================================================================
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    brightness: Brightness.dark,

    // ── Typography ────────────────────────────────────────────────────────
    textTheme:
        const TextTheme(
          displayLarge: AppTextStyles.displayLarge,
          displayMedium: AppTextStyles.displayMedium,
          displaySmall: AppTextStyles.displaySmall,
          headlineLarge: AppTextStyles.headlineLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          headlineSmall: AppTextStyles.headlineSmall,
          titleLarge: AppTextStyles.titleLarge,
          titleMedium: AppTextStyles.titleMedium,
          titleSmall: AppTextStyles.titleSmall,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.labelLarge,
          labelMedium: AppTextStyles.labelMedium,
          labelSmall: AppTextStyles.labelSmall,
        ).apply(
          bodyColor: AppColors.onSurfaceDark,
          displayColor: AppColors.onSurfaceDark,
        ),

    // ── Scaffold ─────────────────────────────────────────────────────────
    scaffoldBackgroundColor: AppColors.backgroundDark,

    // ── AppBar ────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary800,
      foregroundColor: AppColors.primary50,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.primary50,
      ),
      iconTheme: IconThemeData(color: AppColors.primary100),
    ),

    // ── Bottom Navigation Bar ─────────────────────────────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary900,
      selectedItemColor: AppColors.primary300,
      unselectedItemColor: AppColors.grey500,
      elevation: _elevationNavBar,
      type: BottomNavigationBarType.fixed,
    ),

    // ── NavigationBar (M3) ────────────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.primary900,
      indicatorColor: AppColors.primary700,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary200);
        }
        return const IconThemeData(color: AppColors.grey500);
      }),
    ),

    // ── Elevated Button ───────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary400,
        foregroundColor: AppColors.primary900,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // ── Filled Button ─────────────────────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary400,
        foregroundColor: AppColors.primary900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // ── Outlined Button ───────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary300,
        side: const BorderSide(color: AppColors.primary400, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // ── Text Button ───────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusSm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // ── FloatingActionButton ──────────────────────────────────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary500,
      foregroundColor: AppColors.secondary900,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // ── Card ──────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.primary800,
      elevation: _elevationCard,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // ── Input Decoration ──────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.primary900,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.primary700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.primary700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.primary300, width: 2),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
      prefixIconColor: AppColors.primary300,
      suffixIconColor: AppColors.grey500,
    ),

    // ── Chip ──────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.primary800,
      selectedColor: AppColors.primary500,
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: AppColors.primary200,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusXl),
        side: const BorderSide(color: AppColors.primary700),
      ),
    ),

    // ── Dialog ────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.primary800,
      elevation: _elevationDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusXl),
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.primary100,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.grey300,
      ),
    ),

    // ── BottomSheet ───────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.primary800,
      modalBackgroundColor: AppColors.primary800,
      elevation: _elevationDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_radiusXl)),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // ── Snack Bar ─────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary700,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.primary50,
      ),
      actionTextColor: AppColors.secondary400,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
      ),
    ),

    // ── Divider ───────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.primary700,
      thickness: 1,
      space: 1,
    ),

    // ── Switch ────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary900;
        return AppColors.grey600;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary300;
        return AppColors.grey700;
      }),
    ),

    // ── Checkbox ─────────────────────────────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary400;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.primary900),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(color: AppColors.primary600, width: 1.5),
    ),

    // ── Radio ─────────────────────────────────────────────────────────────
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary300;
        return AppColors.grey600;
      }),
    ),

    // ── Slider ────────────────────────────────────────────────────────────
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primary300,
      inactiveTrackColor: AppColors.primary800,
      thumbColor: AppColors.primary300,
      overlayColor: Color(0x2983EDE6),
      valueIndicatorColor: AppColors.primary600,
      valueIndicatorTextStyle: TextStyle(
        color: AppColors.primary50,
        fontFamily: 'Poppins',
        fontSize: 12,
      ),
    ),

    // ── Progress Indicator ────────────────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary300,
      linearTrackColor: AppColors.primary800,
      circularTrackColor: AppColors.primary800,
    ),

    // ── Tab Bar ───────────────────────────────────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary300,
      unselectedLabelColor: AppColors.grey500,
      indicatorColor: AppColors.primary300,
      indicatorSize: TabBarIndicatorSize.label,
    ),

    // ── List Tile ────────────────────────────────────────────────────────
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.primary300,
      textColor: AppColors.onSurfaceDark,
      tileColor: Colors.transparent,
      selectedTileColor: AppColors.primary800,
      selectedColor: AppColors.primary200,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_radiusMd)),
      ),
    ),

    // ── Icon ─────────────────────────────────────────────────────────────
    iconTheme: const IconThemeData(color: AppColors.primary300, size: 24),

    // ── Drawer ────────────────────────────────────────────────────────────
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.primary900,
      elevation: _elevationDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(_radiusXl),
        ),
      ),
    ),

    // ── Tooltip ───────────────────────────────────────────────────────────
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.primary600,
        borderRadius: BorderRadius.circular(_radiusSm),
      ),
      textStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.primary50),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
}

// =============================================================================
// HOW TO USE IN main.dart
// =============================================================================
//
// import 'app_theme.dart';
//
// MaterialApp(
//   title: 'My App',
//   theme: AppTheme.light,
//   darkTheme: AppTheme.dark,
//   themeMode: ThemeMode.system, // or ThemeMode.light / ThemeMode.dark
//   home: const MyHomePage(),
// );
//
// Access colors anywhere:
//   AppColors.primary500
//   Theme.of(context).colorScheme.primary
//
// Access text styles anywhere:
//   AppTextStyles.titleLarge
//   Theme.of(context).textTheme.titleLarge
//
// For Google Fonts support, add to pubspec.yaml:
//   dependencies:
//     google_fonts: ^6.0.0
// Then replace const TextStyle(fontFamily: 'Poppins', ...) with:
//   GoogleFonts.poppins(fontSize: ..., fontWeight: ...)
// =============================================================================
