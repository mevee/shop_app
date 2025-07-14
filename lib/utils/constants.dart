import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  // App Colors
  static const Color primaryColor = Colors.deepPurple;
  static const Color secondaryColor = Colors.orange;
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color errorColor = Colors.red;
  static const Color errorColor2 =  Color.fromARGB(255, 246, 165, 247);

  // App Text Styles with Google Fonts
  static TextStyle get headingStyle => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static TextStyle get subheadingStyle => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static TextStyle get bodyStyle => GoogleFonts.poppins(
    fontSize: 16,
    color: textColor,
  );

  static TextStyle get captionStyle => GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.grey,
  );

  static TextStyle get buttonStyle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // App Dimensions
  static const double padding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 4.0;

  // API Endpoints
  static const String baseUrl = 'https://api.example.com';
  static const String productsEndpoint = '/products';
  static const String ordersEndpoint = '/orders';
  static const String authEndpoint = '/auth';

  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort = 'Password must be at least 6 characters';
} 