import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(AppConstants.accentHex),
      scaffoldBackgroundColor: const Color(AppConstants.primaryBgHex),
      colorScheme: const ColorScheme.dark(
        primary: Color(AppConstants.accentHex),
        secondary: Color(AppConstants.secondaryHex),
        surface: Color(0xFF1E293B), 
        surfaceContainer: Color(0xFF0F172A),
        error: Color(AppConstants.errorHex),
      ),
      textTheme: GoogleFonts.cinzelTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.cinzel(
          color: const Color(AppConstants.accentHex),
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        headlineMedium: GoogleFonts.cinzel(
          color: const Color(AppConstants.secondaryHex),
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter( // Proxy for Google Sans Flex
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter( 
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: const Color(AppConstants.accentHex).withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(AppConstants.accentHex),
            width: 1.5,
          ),
        ),
        labelStyle: const TextStyle(color: Color(AppConstants.secondaryHex)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppConstants.accentHex),
          foregroundColor: const Color(AppConstants.primaryBgHex),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.cinzel(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          elevation: 8,
        ),
      ),
    );
  }
}
