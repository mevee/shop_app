import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/two_state_widget.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/data/network/net_util.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/modules/schedule/schedule_item_view.dart';
import 'package:shop_app/navigation/app_pages.dart';

class ScheduleListView extends GetView<ScheduleController> {
  const ScheduleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('Schedule of ${controller.scheduleDate}'),
          centerTitle: true,
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (await NetUtil.isNetworkAvailable() == false) {
              AppToast.showToast(message: "No internet connection");
              return;
            }
            controller.getTodaysScheduleList(controller.scheduleDate);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: twoState(
              state: controller.isDateWiseLoading.value,
              replace: LinearProgressIndicator(),
              child: scheduleListView(controller.scheduleList),
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
            "No schedule for ${controller.scheduleDate}",
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
          return scheduleItemView(
            model: log,
            onClick: () {
              print("$index AND ID${log.id}");
              final dta = {"id": log};
              Get.toNamed(Routes.scheduleDetail, arguments: dta);
              controller.setManualArguments(dta);
            },
          );
        },
      );
    }
  }

  // Helper function to show a message (instead of alert)
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
