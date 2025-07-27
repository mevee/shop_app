import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/modules/manager/view/manger_action_bottom_view.dart';
import 'package:shop_app/widgets/helper.dart';

import 'controller/manager_controller.dart';

class ManagerScreen extends GetView<ManagerController> {
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Approve schedules'),
        centerTitle: true,
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          children: [
            // Obx(
            //   () => TextField(
            //     controller: controller.searchCtr,
            //     onTapOutside: (event) => FocusScope.of(context).unfocus(),
            //     decoration: InputDecoration(
            //       hintText: "Search Shop",
            //       prefixIcon: Icon(Icons.search, color: AppColors.neutral400),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //         borderSide: BorderSide(color: AppColors.lightGrey),
            //       ),
            //       suffix: controller.isLoading.value
            //           ? SizedBox(
            //               width: 20,
            //               height: 20,
            //               child: CircularProgressIndicator(
            //                 color: AppColors.primaryAccent,
            //               ),
            //             )
            //           : null,
            //     ),
            //     onChanged: (value) {
            //       if (value.isNotEmpty) {
            //         controller.searchShopList(value);
            //       }
            //     },
            //   ),
            // ),
            Obx(() => progressAndNoDatFound(controller.isLoading.value)),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.scheduleList.length,
                  itemBuilder: (context, index) {
                    final schedule = controller.scheduleList[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        Get.bottomSheet(
                          ManagerActionScheduleView(schedule),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                               Radius.circular(8.0),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(6.0),
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
                            Icon(Icons.book_online_rounded, color: AppColors.primary,size: 24,),
                            horizontalSpacing(8),
                            Expanded(
                              child: Text(
                                // maxLines: 6,
                                "${schedule.shopName ?? 'Unknown Schedule'}\nDate:${schedule.scheduleDateTime}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Expanded(child: ,),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget progressAndNoDatFound(bool value) {
    if (controller.scheduleList.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "No Schedule",
            style: TextStyle(color: AppColors.neutral400),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
