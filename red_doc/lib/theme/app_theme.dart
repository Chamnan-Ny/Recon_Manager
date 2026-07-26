import 'package:flutter/material.dart';

class AppTheme {
  // ==================== PRIMARY COLORS ====================
  static const Color primaryColor = Color(0xFFD32F2F); // 🔴 CHANGED TO RED
  static const Color secondaryColor = Color(0xFFB71C1C); // 🔴 Darker Red
  static const Color accentColor = Color(0xFFFF6F00); // Orange (complementary)
  static const Color backgroundColor = Color(0xFFF5F7FA); // Light Gray

  // ==================== TEXT COLORS ====================
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color textWhite = Color(0xFFFFFFFF);

  // ==================== SEVERITY COLORS ====================
  static const Color severityCritical = Color(0xFFD32F2F); // Red
  static const Color severityHigh = Color(0xFFF57C00); // Orange
  static const Color severityMedium = Color(0xFFFFA000); // Amber
  static const Color severityLow = Color(0xFF388E3C); // Green
  static const Color severityInfo = Color(0xFF1976D2); // Blue

  // ==================== STATUS COLORS ====================
  static const Color statusDraft = Color(0xFF9E9E9E); // Gray
  static const Color statusPending = Color(0xFF1976D2); // Blue
  static const Color statusRevision = Color(0xFFFF6F00); // Orange
  static const Color statusApproved = Color(0xFF2E7D32); // Green

  // ==================== UI COLORS ====================
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0x1A000000);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFFF6F00);

  // ==================== GRADIENT ====================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryColor, secondaryColor],
  );

  // ==================== TEXT STYLES ====================
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textLight,
    height: 1.5,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textWhite,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonTextOutlined = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryColor,
    letterSpacing: 0.5,
  );

  static const TextStyle labelText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textLight,
  );

  // ==================== BUTTON STYLES ====================
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: buttonText,
    elevation: 2,
    shadowColor: shadowColor,
  );

  static ButtonStyle outlinedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: primaryColor,
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: primaryColor),
    ),
    textStyle: buttonTextOutlined,
    elevation: 0,
  );

  static ButtonStyle dangerButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: errorColor,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: buttonText,
    elevation: 2,
  );

  static ButtonStyle successButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: successColor,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: buttonText,
    elevation: 2,
  );

  // ==================== INPUT DECORATION ====================
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: primaryColor, width: 2), // 🔴 Red focus
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: errorColor, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: errorColor, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: TextStyle(color: textSecondary, fontSize: 14),
    hintStyle: TextStyle(color: textLight, fontSize: 14),
    errorStyle: TextStyle(color: errorColor, fontSize: 12),
  );

  // ==================== CARD THEME ====================
  static const CardThemeData cardTheme = CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    color: cardBackground,
    shadowColor: shadowColor,
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  // ==================== APP BAR THEME ====================
  static const AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: primaryColor, // 🔴 RED APP BAR
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 0.5,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );

  // ==================== DIALOG THEME ====================
  static const DialogThemeData dialogTheme = DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    elevation: 4,
    backgroundColor: cardBackground,
  );

  // ==================== SNACKBAR THEME ====================
  static const SnackBarThemeData snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    backgroundColor: textPrimary,
    contentTextStyle: TextStyle(color: Colors.white, fontSize: 14),
  );

  // ==================== COMPLETE THEME DATA ====================
  static ThemeData lightTheme = ThemeData(
    // Core
    useMaterial3: true,
    brightness: Brightness.light,

    // Colors
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardBackground,
      background: backgroundColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      onBackground: textPrimary,
      onError: Colors.white,
    ),

    // App Bar
    appBarTheme: appBarTheme,

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // Input Fields
    inputDecorationTheme: inputDecorationTheme,

    // Cards
    cardTheme: cardTheme,

    // Text
    textTheme: const TextTheme(
      displayLarge: heading1,
      displayMedium: heading2,
      displaySmall: heading3,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: buttonText,
      labelMedium: labelText,
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),

    // Dialog
    dialogTheme: dialogTheme,

    // Snackbar
    snackBarTheme: snackBarTheme,
  );
}
