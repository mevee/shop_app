import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/utils/app_images.dart';
import 'package:shop_app/widgets/app_button.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:shop_app/widgets/common_textfield.dart';
import 'package:shop_app/widgets/helper.dart';
import 'package:shop_app/widgets/loader.dart';

class DialogHelper {
  static void showLogoutPopup(void Function()? onClick) {
    DialogHelper.showErrorDialog(
      title: "Authorization Failed",
      description: "Access token has been expired.",
      onClick: onClick,
      dismissible: false,
    );
  }

  static void showErrorDialog({
    String title = 'Error',
    String? description = "Something went wrong",
    void Function()? onClick,
    bool dismissible = true,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.sora(
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp(Get.context as BuildContext)),
              ),
              verticalSpacing(10),
              Text(
                description ?? '',
                style: GoogleFonts.sora(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp(Get.context as BuildContext)),
              ),
              verticalSpacing(20),
              CustomButtonWithIcon(
                buttonText: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400, color: Colors.white),
                ),
                height: 40,
                buttonWidth: getWidth(Get.context as BuildContext) * 0.1,
                disabled: false,
                onClick: onClick ??
                    () {
                      Get.back();
                    },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: dismissible,
    );
  }

  static void commonConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? secondButtonText,
    AssetImage? secondButtonImage,
    required VoidCallback onClick,
    bool isErrorDialog = false,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackText),
              ),
              verticalSpacing(12),
              (content.isNotEmpty)
                  ? Text(
                      content,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGrey),
                    ).paddingOnly(bottom: 24)
                  : const SizedBox(),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.lightGrey,
              ),
              verticalSpacing(24),
              Align(
                widthFactor: double.infinity,
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => {Get.back()},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          color: Colors.white,
                          border: Border.all(color: AppColors.grey, width: 1.0),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.inter(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    horizontalSpacing(16.0),
                    InkWell(
                      onTap: onClick,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          color: isErrorDialog
                              ? AppColors.red01
                              : AppColors.blackText,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ImageIcon(
                              secondButtonImage ?? AssetImages.folder,
                              size: 16,
                              color: Colors.white,
                            ),
                            horizontalSpacing(8.0),
                            Text(
                              secondButtonText ?? "Save",
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // * Common Loader
  static void showLoading() {
    Get.dialog(
      const CupertinoActivityIndicator(),
      barrierColor: Colors.white.withOpacity(0.5),
      barrierDismissible: false,
    );
  }

  // * hide loading
  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }

  static void onboardingCompleted({required BuildContext context}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Onboarding Completed",
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.blackText,
              ),
            ),
            verticalSpacing(16),
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () => {Get.back()},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: AppColors.blackText,
                    ),
                    child: Text(
                      "Start",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ).paddingSymmetric(vertical: 24, horizontal: 20),
      ),
    );
  }

  static void submitFeedback(
      {required BuildContext context,
      ImageProvider? image,
      required TextEditingController textController,
      required VoidCallback onClick,
      required RxBool isLoading}) {
    final RxString remarks = ''.obs;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image(
                  image: (image != null) ? image : AssetImages.tickCircle,
                  width: 20,
                ),
                horizontalSpacing(10),
                Text(
                  "Add Comment",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                InkWell(
                  child: Icon(color: AppColors.neutral400, Icons.close),
                  onTap: () {
                    Get.back();
                  },
                )
              ],
            ),
            verticalSpacing(3.h(context)),
            Obx(
              () => textField(
                  context: context,
                  maxLines: 3,
                  enabled: !isLoading.value,
                  textController: textController,
                  onChanged: () {
                    remarks.value = textController.text;
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
            ),
            verticalSpacing(2.h(context)),
            Obx(() => Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: textController.text.isEmpty ? null : onClick,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          color: remarks.value.isEmpty
                              ? AppColors.lightGrey
                              : AppColors.blackText,
                        ),
                        child: Row(
                          children: [
                            if (isLoading.value) const RotatingImageView(),
                            if (isLoading.value) horizontalSpacing(8),
                            Text(
                              "Submit Feed Back",
                              style: GoogleFonts.inter(
                                color: remarks.value.isEmpty
                                    ? AppColors.grey
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ).paddingSymmetric(vertical: 20, horizontal: 20),
      ),
    );
  }
}
