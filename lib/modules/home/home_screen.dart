import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/models/employee_response.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/modules/home/controller/dashboard_controller.dart';
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
                Text(
                  'Welcome to Shop App',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => userInfoWidget(controller.userData.value.login)),
                verticalSpace(16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      Image(image: AssetImages.timeline, width: 24, height: 24),
                      horizontalSpace(8),
                      Text(
                        "Distance Travelled Today: ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        controller.distance.value,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buttonWithLoader(
                          disable:
                              (controller.clockedIn.value ||
                                  controller.isPunchInProgress.value)
                              ? true
                              : false,
                          isLoading: controller.isPunchInProgress.value,
                          context: context,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          progressColor: Colors.white,
                          label: "Clock IN",
                          onPressed: () {
                            controller.getInLocation();
                          },
                        ),
                      ),
                    ),
                    horizontalSpace(16),
                    Expanded(
                      child: buttonWithLoader(
                        disable:
                            (!controller.clockedIn.value ||
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
      return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final log = list[index];
          return InkWell(
            onTap: () {
              Get.toNamed(Routes.scheduleDetail, arguments: {"id":log.id});
            },
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 10.0,
              ),
              decoration: BoxDecoration(
                color: log.isVisitDone == 0 ? Colors.white : Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Text(
                    "Shop: ${log.shopName}\nScheduled Time: ${log.scheduleDateTime}\nStatus: ${log.status}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
            
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
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
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Hello, ",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
              ),
              Text(
                data?.fullName ?? "",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    "Working Staus",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Icon(
                    Icons.circle,
                    color: controller.clockedIn.value
                        ? Colors.green
                        : Colors.red,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(8.0),

          lableValue(label: "Email:", value: data?.emailId ?? ""),
          verticalSpace(4.0),
          lableValue(label: "Mobile:", value: data?.contactNo ?? ""),
          verticalSpace(4.0),
          lableValue(
            label: "Date:",
            value: DateTime.now().toLocal().toString().split(' ')[0],
          ),
          verticalSpace(4.0),
          lableValue(
            label: "Time:",
            value: DateTime.now()
                .toLocal()
                .toString()
                .split(' ')[1]
                .substring(0, 5),
          ),
          verticalSpace(4.0),
          lableValue(label: "Location:", value: data?.address ?? ""),
        ],
      ),
    );
  }

  Row lableValue({required String label, String? value}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black54,
          ),
        ),
        horizontalSpace(8.0),
        Text(
          value ?? '',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
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
}
