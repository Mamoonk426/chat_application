import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// COLOR PALETTE — Premium Slate & Indigo
// =============================================================================

class AppColors {
  AppColors._();

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
  static const Color grey50 = Color(0xFFF4F4F4); // using F4F4F4 as light bg
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

  // ── Chat / Messaging ──────────────────────────────────────────────────────
  static const Color bubbleSent = Color(0xFF1CBBB0);
  static const Color bubbleSentText = Color(0xFFFFFFFF);
  static const Color bubbleReceived = Color(0xFFEDE5D8);
  static const Color bubbleReceivedText = Color(0xFF083633);
  static const Color chatBackground = Color(0xFFF2EDE3);

  static const Color bubbleSentDark = Color(0xFF158E86);
  static const Color bubbleReceivedDark = Color(0xFF1A2E2C);
  static const Color bubbleReceivedTextDark = Color(0xFFDBFAF8);
}

// =============================================================================
// TEXT STYLES
// =============================================================================

class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    height: 1.16,
  );

  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.22,
  );

  static TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.29,
  );

  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );

  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
  );

  static TextStyle titleMedium = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static TextStyle titleSmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}

// =============================================================================
// THEME DATA
// =============================================================================

class AppTheme {
  AppTheme._();

  static const double _radiusMd = 12.0;
  static const double _radiusLg = 16.0;

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary500,
      primary: AppColors.primary500,
      secondary: AppColors.secondary500,
      surface: AppColors.grey50,
      onSurface: AppColors.grey900,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.grey900,
      displayColor: AppColors.grey900,
    ),
    scaffoldBackgroundColor: AppColors.grey50,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.grey50,
      foregroundColor: AppColors.grey900,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.grey900,
      ),
      iconTheme: const IconThemeData(color: AppColors.grey900),
    ),
    cardTheme: CardThemeData(
      color: AppColors.grey0,
      elevation: 2,
      shadowColor: AppColors.grey200.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusLg),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
      prefixIconColor: AppColors.grey500,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.grey0,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.grey0,
      selectedItemColor: AppColors.primary500,
      unselectedItemColor: AppColors.grey400,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
    extensions: const [AppChatTheme.light],
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary500,
      brightness: Brightness.dark,
      primary: AppColors.primary400,
      secondary: AppColors.secondary500,
      surface: AppColors.grey900,
      onSurface: AppColors.grey50,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: AppColors.grey50, displayColor: AppColors.grey50),
    scaffoldBackgroundColor: AppColors.grey900,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.grey900,
      foregroundColor: AppColors.grey50,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.grey50,
      ),
      iconTheme: const IconThemeData(color: AppColors.grey50),
    ),
    cardTheme: CardThemeData(
      color: AppColors.grey800,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radiusLg),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey800,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.grey700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.grey700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide: const BorderSide(color: AppColors.primary400, width: 1.5),
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
      prefixIconColor: AppColors.grey400,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary400,
        foregroundColor: AppColors.grey900,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.grey900,
      selectedItemColor: AppColors.primary400,
      unselectedItemColor: AppColors.grey600,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
    extensions: const [AppChatTheme.dark],
  );
}

@immutable
class AppChatTheme extends ThemeExtension<AppChatTheme> {
  const AppChatTheme({
    required this.bubbleSent,
    required this.bubbleSentText,
    required this.bubbleReceived,
    required this.bubbleReceivedText,
    required this.chatBackground,
  });

  final Color bubbleSent;
  final Color bubbleSentText;
  final Color bubbleReceived;
  final Color bubbleReceivedText;
  final Color chatBackground;

  static const AppChatTheme light = AppChatTheme(
    bubbleSent: AppColors.bubbleSent,
    bubbleSentText: AppColors.bubbleSentText,
    bubbleReceived: AppColors.bubbleReceived,
    bubbleReceivedText: AppColors.bubbleReceivedText,
    chatBackground: AppColors.chatBackground,
  );

  static const AppChatTheme dark = AppChatTheme(
    bubbleSent: AppColors.bubbleSentDark,
    bubbleSentText: AppColors.grey50,
    bubbleReceived: AppColors.bubbleReceivedDark,
    bubbleReceivedText: AppColors.bubbleReceivedTextDark,
    chatBackground: AppColors.grey900,
  );

  @override
  AppChatTheme copyWith({
    Color? bubbleSent,
    Color? bubbleSentText,
    Color? bubbleReceived,
    Color? bubbleReceivedText,
    Color? chatBackground,
  }) => AppChatTheme(
    bubbleSent: bubbleSent ?? this.bubbleSent,
    bubbleSentText: bubbleSentText ?? this.bubbleSentText,
    bubbleReceived: bubbleReceived ?? this.bubbleReceived,
    bubbleReceivedText: bubbleReceivedText ?? this.bubbleReceivedText,
    chatBackground: chatBackground ?? this.chatBackground,
  );

  @override
  AppChatTheme lerp(AppChatTheme? other, double t) {
    if (other is! AppChatTheme) return this;
    return AppChatTheme(
      bubbleSent: Color.lerp(bubbleSent, other.bubbleSent, t)!,
      bubbleSentText: Color.lerp(bubbleSentText, other.bubbleSentText, t)!,
      bubbleReceived: Color.lerp(bubbleReceived, other.bubbleReceived, t)!,
      bubbleReceivedText: Color.lerp(
        bubbleReceivedText,
        other.bubbleReceivedText,
        t,
      )!,
      chatBackground: Color.lerp(chatBackground, other.chatBackground, t)!,
    );
  }
}
