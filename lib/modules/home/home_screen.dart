import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/models/employee_response.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/modules/home/controller/dashboard_controller.dart';
import 'package:shop_app/modules/home/more_options_bottom.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/utils/app_images.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class HomeScreen extends GetView<DashboardController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.getTodaysSchedules,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => userInfoWidget(controller.userData.value.login)),
                verticalSpace(16.0),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                //   child: Row(
                //     children: [
                //       Image(image: AssetImages.timeline, width: 24, height: 24),
                //       horizontalSpace(8),
                //       Text(
                //         "Distance Travelled Today: ",
                //         style: GoogleFonts.poppins(
                //           fontSize: 16,
                //           fontWeight: FontWeight.normal,
                //         ),
                //       ),
                //       Text(
                //         controller.distance.value,
                //         style: GoogleFonts.poppins(
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buttonWithLoader(
                          disable:
                              (controller.attandanceObj.value.isLoggedIn ||
                                  controller.isPunchInProgress.value)
                              ? true
                              : false,
                          isLoading: controller.isPunchInProgress.value,
                          context: context,
                          color: Colors.green,
                          textColor: Colors.white,
                          progressColor: Colors.white,
                          label: "Clock IN",
                          onPressed: () {
                            if (controller.attandanceObj.value.loginTime ==
                                null) {
                              AppToast.showToast(
                                message:
                                    "User attandance was not loaded. Re loading to check attandance.",
                              );
                              controller.getEmployeeAttandance();
                            } else {
                              controller.getInLocation();
                            }
                          },
                        ),
                      ),
                    ),
                    horizontalSpace(16),
                    Expanded(
                      child: Obx(
                        () => buttonWithLoader(
                          disable:
                              (controller.attandanceObj.value.isLoggedOut ||
                                  controller.isPunchOutProgress.value)
                              ? true
                              : false,
                          isLoading: controller.isPunchOutProgress.value,
                          context: context,
                          color: Colors.red,
                          textColor: Colors.white,
                          progressColor: Colors.white,
                          label: "Clock OUT",
                          onPressed: () {
                            controller.getOutLocation();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(16.0),
                Text(
                  "Todays Schedules:",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(8.0),
                Obx(() => scheduleListView(controller.scheduleList)),
                // Obx(() => attandanceLogView(controller.attandanceList)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget scheduleListView(List<ScheduleDateTimeModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "No schedule for today",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final log = list[index];
            return InkWell(
              onTap: () {
                Get.toNamed(Routes.scheduleDetail, arguments: {"id": log});
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.symmetric(
                  vertical: 3.0,
                  horizontal: 10.0,
                ),
                decoration: BoxDecoration(
                  color: log.isVisitDone == 0
                      ? Colors.white
                      : Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Shop: ${log.shopName}\nScheduled Time: ${log.scheduleDateTime}\nStatus: ${log.status}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                        ),

                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    if (log.isVisitDone == 1)
                      Image(
                        image: AssetImages.eye,
                        height: 24,
                        width: 24,
                        color: Colors.green,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget attandanceLogView(List<AttandanceModel> attandanceList) {
    if (attandanceList.isEmpty) {
      return Center(
        child: Text(
          "No logs found for today",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: attandanceList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final log = attandanceList[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Text(log.loginTime ?? ""),
                Spacer(),
                Transform(
                  // angle: index % 2 == 0 ? 90 : 125,
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..rotateZ((!log.isLoggedOut ? 140 : 315) * 3.1415927 / 180),
                  child: Icon(
                    Icons.arrow_back,
                    color: !log.isLoggedOut ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Container userInfoWidget([UserData? data]) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Hello, ",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Working Staus:",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        horizontalSpace(8),
                        Obx(() => circleDot(controller.clockedIn.value)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Distance : ",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.distance.value,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "M.Name : ",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.userData.value.login?.managerName ?? "",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              InkWell(
                onTap: () {
                  Get.bottomSheet(
                    MoreOptionBottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  padding: EdgeInsets.all(3),
                  child: Icon(Icons.more_vert, size: 24, color: Colors.white),
                ),
              ),
            ],
          ),
          verticalSpace(8.0),
          Text(
            data?.fullName ?? "",
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          verticalSpace(4.0),
          Row(
            children: [
              Text(
                "Employee ID: ",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              Obx(
                () => Text(
                  controller.userData.value.login?.id?.toString() ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(4.0),
          lableValue(label: Icons.phone_android, value: data?.contactNo ?? ""),
          verticalSpace(4.0),
          lableValue(
            label: Icons.calendar_month,
            value: DateTime.now().toLocal().toString().split(' ')[0],
          ),
          verticalSpace(4.0),
          lableValue(
            label: Icons.av_timer,
            value: DateTime.now()
                .toLocal()
                .toString()
                .split(' ')[1]
                .substring(0, 5),
          ),
          verticalSpace(4.0),
          lableValue(label: Icons.location_on, value: data?.address ?? ""),
        ],
      ),
    );
  }

  Row lableValue({required IconData label, String? value}) {
    return Row(
      children: [
        Icon(label, size: 18, color: Colors.white),

        horizontalSpace(8.0),
        Text(
          value ?? '',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget horizontalSpace(double i) {
    return SizedBox(width: i, height: 0);
  }

  Widget verticalSpace(double i) {
    return SizedBox(height: i, width: 0);
  }

  Widget circleDot(bool isGreen) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.only(left: 2.0),
      child: Icon(
        Icons.circle,
        color: isGreen ? Colors.green : Colors.redAccent,
        size: 16,
      ),
    );
  }
}
