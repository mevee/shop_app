import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/utils/constants.dart';

class CommonWidgets {
  static Widget text({
    required TextEditingController controller,
    String? labelText,
    Color filledColor = Colors.white,
    Color errorColor = AppConstants.errorColor,

    Widget? prefixIcon,
    bool isPassword = false,
    bool isError = false,

    double fontSize = 12.0,
    double border = 12.0,
    String? errorMessage,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: isError ? errorColor : Colors.white,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: filledColor,
        prefixIcon: prefixIcon,
        hintStyle: TextStyle(color: Colors.white, fontSize: fontSize),
        floatingLabelStyle: TextStyle(color: Colors.white, fontSize: 14.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(border)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(border),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(border),
          borderSide: BorderSide(
            color: isError ? errorColor : Color.fromARGB(255, 165, 180, 247),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(border),
          borderSide: BorderSide(color: errorColor ?? Colors.redAccent),
        ),
        errorStyle: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage ?? 'Field is required';
        }
        return null;
      },
    );
  }

  static Widget appBar({required String title, bool centerTitle = false}) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    );
  }

  static Widget button({required String lable,
  Color color = Colors.deepPurple,
  Color textColor = Colors.white,
  Icon? icon,

  Function()? onPressed}) {
    return SizedBox(
      width: double.maxFinite,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) 
              icon,
              if (icon != null)
              const SizedBox(width: 8),
              Text(
                lable,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
