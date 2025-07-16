import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppToast {
  static void showToast({String message = "Something Went Wrong"}) {
    Get.snackbar(
      "",
      "",
      maxWidth: 300,
      borderRadius: 10,
      padding: const EdgeInsets.all(13),
      duration: const Duration(milliseconds: 1500),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromRGBO(28, 27, 31, 1),
      margin: const EdgeInsets.only(bottom: 10),
      titleText: Center(
        child: Text(
          message,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      messageText: const SizedBox.shrink(),
    );
  }
}
