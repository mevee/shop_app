import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

abstract class AppColors {
  AppColors._();

  // * Primary Colors
  static final Color primaryOrange = Vx.hexToColor('#f6b884');
  static final Color primaryPink = Vx.hexToColor('#ff9c9c');
  static final Color primaryPurple = Vx.hexToColor('#8c64b4');
  static final Color primaryTeal = Vx.hexToColor('#98e4d9');
  static final Color primaryBlack = Vx.hexToColor('#191919');
  static final Color neutral400 = Vx.hexToColor('#888888');
  static const Color neutral200 = Color.fromRGBO(209, 209, 209, 1);
  static const Color neutral600 = Color.fromRGBO(93, 93, 93, 1);
  static const Color disabled = Color.fromRGBO(93, 93, 93, 1);
  static const Color primary = Color.fromRGBO(174, 17, 30, 1);
  static const Color primaryAccent = Color.fromRGBO(142, 47, 94, 1);
  static const Color divider = Color.fromRGBO(93, 93, 93, 1);
  static const Color blackText = Color.fromRGBO(45, 45, 45, 1);
  static const Color greyText = Color.fromRGBO(79, 79, 79, 1);
  static const Color red = Color.fromRGBO(255, 55, 98, 1);
  static const Color black2 = Color.fromRGBO(0, 32, 70, 1);
  static const Color grey = Color.fromRGBO(93, 93, 93, 1);
  static const Color lightGrey = Color.fromRGBO(231, 231, 231, 1);
  static const Color lightGrey100 = Color.fromRGBO(246, 246, 246, 1);
  static const Color lightGrey200 = Color.fromRGBO(176, 176, 176, 1);
  static const Color headingGrey = Color.fromRGBO(136, 136, 136, 1);
  static const Color neon = Color.fromRGBO(238, 231, 27, 1);
  static const Color yellow = Color.fromRGBO(152, 148, 23, 1);
  static const Color brown = Color.fromRGBO(108, 77, 23, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color darkWhite = Color.fromRGBO(250, 250, 250, 1);
  static const Color darkWhite1 = Color.fromRGBO(246, 246, 246, 1);
  static const Color darkWhite2 = Color.fromRGBO(253, 253, 253, 1);
  static const Color textGrey = Color.fromRGBO(109, 109, 109, 1);
  static const Color green = Color.fromRGBO(22, 168, 42, 1);
  static const Color red01 = Color(0xffCD3232);
  static const Color lightgreen = Color(0xffF1FCF4);
  // static  Color lightRed = (Get.context as BuildContext).isDarkMode ? Colors.amber : Color(0xffFDF3F3);

  static const Color black01 = Color(0xFF2D2D2D);
  static const Color lightBlack = Color(0xFF6D6D6D);
  static const Color cherryRed = Color(0xFFCC252C);

  // * Secondary Colors

  // * Gradient Colors
  static final Gradient orangeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    tileMode: TileMode.mirror,
    colors: [
      Vx.hexToColor('#FFDDB5'),
      Vx.hexToColor('#FFF9ED'),
    ],
  );
}

extension WithDarkCheck on Color {
  Color withDarkCheck(bool isDark) {
    if (isDark) {
      return getMaterialColorValues[100]!;
    } else {
      return this;
    }
  }
}
