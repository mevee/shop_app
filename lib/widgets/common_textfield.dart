import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/utils/app_images.dart';

Widget textField(
    {required BuildContext context,
    required TextEditingController textController,
    int? maxLength,
    int? maxLines = 1,
    bool enabled = true,
    bool isPassword = false,
    EdgeInsetsGeometry? contentPadding =
        const EdgeInsets.symmetric(vertical: 15, horizontal: 0.0),
    TextInputType? keyboardType,
    Function()? onTap,
    Function()? onTapOutside,
    Function()? onChanged,
    Function()? toggleObscure,
    AssetImage? leadingIcon,
    AssetImage? trailingIcon,
    Function()? onTapTrailingIcon,
    List<TextInputFormatter>? formatters,
    String errorText = "",
    String hint = "",
    Color? backGroundColor,
    Color leadingIconColor = Colors.black,
    Color passwordIconColor = Colors.black,
    Color textColor = Colors.black,
    bool isObscure = false,
    FocusNode? node}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
            color: AppColors.darkWhite1,
            borderRadius: BorderRadius.circular(8)),
        child: TextField(
          focusNode: node,
          inputFormatters: formatters,
          enabled: enabled,
          maxLines: maxLines,
          obscureText: isObscure,
          keyboardType: keyboardType,
          maxLength: maxLength,
          textInputAction: TextInputAction.done,
          onTap: () async => {
            if (onTap != null) onTap(),
          },
          onTapOutside: (event) async => {
            if (onTapOutside != null) onTapOutside(),
          },
          onChanged: (value) async => {
            if (onChanged != null) onChanged(),
          },
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400,color: textColor),
          cursorColor: AppColors.neutral200.withDarkCheck(context.isDarkMode),
          controller: textController,
          decoration: InputDecoration(
            prefixIconConstraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),

            // isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
            ),
            fillColor: backGroundColor,
            labelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.black2,
            ),
            counterText: "",
            contentPadding: contentPadding,
            prefixIcon: leadingIcon != null
                ? Image(
                    color: leadingIconColor,
                    image: leadingIcon,
                    height: 24,
                    width: 24,
                  ).paddingSymmetric(horizontal: 15, vertical: 12)
                : null,
            suffixIcon: (isPassword)
                ? InkWell(
                    onTap: () {
                      if (toggleObscure != null) {
                        toggleObscure();
                      }
                    },
                    child: Image(
                      image: isObscure ? AssetImages.eye : AssetImages.eyeClose,
                      width: 24,
                      color: passwordIconColor,
                    ).paddingSymmetric(vertical: 12, horizontal: 15),
                  )
                : (trailingIcon != null)
                    ? InkWell(
                        onTap: () {
                          onTapTrailingIcon?.call();
                        },
                        child: Image(
                          image: trailingIcon,
                          color: Colors.black,
                          width: 24,
                        ).paddingSymmetric(vertical: 12, horizontal: 15),
                      )
                    : null,
            border: InputBorder.none,
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8),
            //   borderSide: BorderSide(
            //     color: errorText.isNotEmpty
            //         ? AppColors.red01
            //         : Colors.black.withOpacity(0.2),
            //     width: 1,
            //   ),
            // ),
            // disabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8),
            //   borderSide: BorderSide(
            //     color: errorText.isNotEmpty
            //         ? AppColors.red01
            //         : Colors.black.withOpacity(0.2),
            //     width: 1,
            //   ),
            // ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText.isNotEmpty
                    ? AppColors.red
                    : Colors.black.withOpacity(0.1),
                width: 2,
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: errorText.isNotEmpty,
        child: Text(
          errorText,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.red,
          ),
        ),
      )
    ],
  );
}
