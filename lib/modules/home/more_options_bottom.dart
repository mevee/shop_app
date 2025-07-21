import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/modules/home/controller/dashboard_controller.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:shop_app/widgets/helper.dart';

class MoreOptionBottomSheet extends GetView<DashboardController> {
  const MoreOptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 40.h(context),
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Select Action",
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    ),
                  ),
                  InkWell(
                    child: Icon(color: AppColors.neutral400, Icons.close),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Divider(color: AppColors.lightGrey),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ["Logout", "Change Password"].length,
                itemBuilder: (context, index) {
                  final list = ["Logout", "Change Password"];
                  final model = list[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {
                      if (index == 0) {
                        controller.logout();
                      } else {
                        Get.toNamed(Routes.passwordUpdate);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black87.withOpacity(.5),
                            width: 0.7,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            index == 0 ? Icons.logout : Icons.password,
                            color: Colors.blueAccent,
                          ),
                          horizontalSpacing(8),
                          Text(
                            maxLines: 1,
                            model,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Expanded(child: ,),
            const SizedBox(height: 16),
          ],
        ),
      ),
      // ),
    );
  }
}
