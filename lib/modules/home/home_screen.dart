import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/common/dialog_util.dart';
import 'package:shop_app/common/two_state_widget.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/location_service/permission_helper.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/modules/home/controller/home_controller.dart';
import 'package:shop_app/modules/home/more_options_bottom.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/modules/schedule/schedule_detail_screen.dart';
import 'package:shop_app/modules/schedule/schedule_item_view.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasboard'),
        centerTitle: true,
        backgroundColor: AppColors.cherryRed,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
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

                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buttonWithLoader(
                          disable:
                              (controller.userState.value ==
                                      UserState.WORKING ||
                                  controller.userState.value ==
                                      UserState.NOT_WORKING ||
                                  controller.isPunchInProgress.value)
                              ? true
                              : false,
                          isLoading: controller.isPunchInProgress.value,
                          context: context,
                          color: Colors.green,
                          textColor: Colors.white,
                          progressColor: Colors.white,
                          label: "Checkin",
                          onPressed: () async {
                            final p1 =
                                await PermissionUtil.notificationPermissionCheck();
                            if (p1) {
                              final loc =
                                  await PermissionUtil.locationPermissionCheck();
                              if (loc) {
                                // AppToast.showToast(
                                //   message: "Locaton notification allowed",
                                // );
                                showCustomDialog(
                                  context: context,
                                  message: "Do you want to checkin?",
                                  title: "Confirm",
                                  barrierDismissible: true,
                                  primaryButtonText: "Yes",
                                  secondaryButtonText: "No",
                                  onPrimaryPressed: () {
                                    controller.getInLocation();
                                  },
                                );
                              } else {
                                AppToast.showToast(
                                  message: "Locaton notification denied",
                                );
                              }
                            } else {
                              AppToast.showToast(
                                message: "Notification permission is required.",
                              );
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
                              (controller.userState.value == UserState.IDEAL ||
                                  controller.userState.value ==
                                      UserState.NOT_WORKING ||
                                  controller.isPunchOutProgress.value)
                              ? true
                              : false,
                          isLoading: controller.isPunchOutProgress.value,
                          context: context,
                          color: Colors.red,
                          textColor: Colors.white,
                          progressColor: Colors.white,
                          label: "Checkout",
                          onPressed: () {
                            showCustomDialog(
                              context: context,
                              message: "Do you want to Checkout?",
                              title: "Confirm",
                              barrierDismissible: true,
                              primaryButtonText: "Yes",
                              secondaryButtonText: "No",
                              onPrimaryPressed: () {
                                aLog(
                                  "isSchedulePending::${controller.isSchedulePending()}",
                                );
                                // if (controller.isSchedulePending()) {
                                //   AppToast.showToast(
                                //     message:
                                //         "Please complete schedule before checkout",
                                //   );
                                // }else
                                if (!controller.isAgent()) {
                                  controller.getOutLocation();
                                } else {
                                  if (!controller.is15ScheduleCompleted()) {
                                    AppToast.showToast(
                                      message:
                                          "Please complete at least 15 schedule before checkout",
                                    );
                                  } else {
                                    controller.getOutLocation();
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(16.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Todays Schedules:",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print(
                          'loadUserData()${controller.userManager.getUserData()?.toJson()}',
                        );
                        controller.getTodaysSchedules();
                        controller.getEmployeeAttandance();
                      },
                      child: Icon(Icons.refresh),
                    ),
                  ],
                ),
                verticalSpace(8.0),
                Obx(
                  () => twoState(
                    state: controller.isTodaysLoding.value,
                    replace: LinearProgressIndicator(),
                    child: scheduleListView(controller.scheduleList),
                  ),
                ),
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
            return scheduleItemView(
              model: log,
              onClick: () {
                final payoad = {"id": log};
                // Get.to(
                //   Routes.scheduleDetail,
                //   arguments: payoad,
                //   preventDuplicates: false,
                // );
                Get.to(
                  arguments: payoad,
                  () => ScheduleDetailView(null, payoad),
                  binding: BindingsBuilder(() {
                    Get.create<SessionPref>(() => SPrefSessiomImpl());
                    Get.put(ScheduleController());
                  }),
                  preventDuplicates: false, // Allows new instance
                );
                print("scheduleItemView $payoad");
              },
            );
          },
        ),
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
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Working Staus :",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        horizontalSpace(8),
                        Obx(
                          () => circleDot(
                            controller.userState.value == UserState.WORKING,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Distance : ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.distance.value,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // alignment: WrapAlignment.start,
                      children: [
                        Text(
                          "M.Name : ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Obx(
                          () => Flexible(
                            child: Text(
                              controller.userData.value.login?.managerName ??
                                  "",
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
              fontSize: 16,
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
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              Obx(
                () => Text(
                  controller.userData.value.login?.employeeId ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
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
          Obx(
            () => lableValue(
              label: Icons.calendar_month,
              value: controller.attandanceObj.value.loginTime,
            ),
          ),
          verticalSpace(4.0),
          Obx(
            () => lableValue(
              label: Icons.av_timer,
              value: DateFormatter.getTimeDifference(
                controller.attandanceObj.value.loginTime,
                controller.attandanceObj.value.logoutTime,
              ),
            ),
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
        Icon(label, size: 14, color: Colors.white),

        horizontalSpace(8.0),
        Text(
          value ?? '',
          style: GoogleFonts.poppins(
            fontSize: 14,
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
        color: isGreen ? Colors.green : AppColors.primaryAccent,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
