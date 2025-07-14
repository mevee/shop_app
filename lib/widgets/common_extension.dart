import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

List<TextInputFormatter> noEmojiNoSpace = [
  FilteringTextInputFormatter.deny(
    RegExp(
      r'[\u{1F600}-\u{1F64F}]' // Smileys & Emotion
      r'|[\u{1F300}-\u{1F5FF}]' // Symbols & Pictographs
      r'|[\u{1F680}-\u{1F6FF}]' // Transport & Map Symbols
      r'|[\u{1F700}-\u{1F77F}]' // Alchemical Symbols
      r'|[\u{1F780}-\u{1F7FF}]' // Geometric Shapes Extended
      r'|[\u{1F800}-\u{1F8FF}]' // Supplemental Arrows-C
      r'|[\u{1F900}-\u{1F9FF}]' // Supplemental Symbols and Pictographs
      r'|[\u{1FA00}-\u{1FA6F}]' // Chess Symbols
      r'|[\u{1FA70}-\u{1FAFF}]' // Symbols and Pictographs Extended-A
      r'|[\u{2600}-\u{26FF}]' // Miscellaneous Symbols
      r'|[\u{2700}-\u{27BF}]' // Dingbats
      r'|\s',
      unicode: true,
    ),
  ),
];

extension DynamicFontSizeOnInt on int {
  double sp(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return this * (screenWidth / 375);
  }
}

extension DynamicFontSizeOnDouble on double {
  double sp(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return this * (screenWidth / 375);
  }
}

// extension DynamicFontSizeOnInt on int {
//   double sp(BuildContext context) {
//     return MediaQuery.of(context).size.width / 4.3 * this / 100;
//   }
// }

// extension DynamicFontSizeOnDouble on double {
//   double sp(BuildContext context) {
//     return MediaQuery.of(context).size.width / 4.3 * this / 100;
//   }
// }

extension HeightPercentOnInt on int {
  double h(BuildContext context) {
    return MediaQuery.of(context).size.height * this / 100;
  }

  double hSA(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double top = MediaQuery.of(context).padding.top;
    final double bottom = MediaQuery.of(context).padding.bottom;
    final double screenHeightMinusSafeArea = screenHeight - top - bottom;
    return screenHeightMinusSafeArea * this / 100;
  }
}

extension HeightPercentOnDouble on double {
  double h(BuildContext context) {
    return MediaQuery.of(context).size.height * this / 100;
  }

  double hSA(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double top = MediaQuery.of(context).padding.top;
    final double bottom = MediaQuery.of(context).padding.bottom;
    final double screenHeightMinusSafeArea = screenHeight - top - bottom;
    return screenHeightMinusSafeArea * this / 100;
  }
}

extension WidthercentOnInt on int {
  double w(BuildContext context) {
    return MediaQuery.of(context).size.width * this / 100;
  }
}
