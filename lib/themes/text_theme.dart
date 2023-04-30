import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextTheme darkTextTheme = TextTheme(
    // Body
    bodyMedium: GoogleFonts.comfortaa(
      color: Colors.grey[400],
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),

    // Label
    labelMedium: GoogleFonts.robotoMono(
      color: Colors.white,
      // fontWeight: FontWeight.bold,
      fontSize: 18,
    ),

    // Title
    titleMedium: GoogleFonts.robotoMono(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),

    // Headline
    headlineMedium: GoogleFonts.comfortaa(
      color: Colors.white,
      // fontWeight: FontWeight.bold,
      // fontSize: 30,
    ),

    // Display
    displayMedium: GoogleFonts.comfortaa(
        // color: Colors.white,
        // fontWeight: FontWeight.bold,
        // fontSize: 24,
        ),
  );
}
