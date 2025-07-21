import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
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
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              controller.getTodaysScheduleList(controller.scheduleDate),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: controller.isDateWiseLoding.value
                ? Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : scheduleListView(controller.scheduleList),
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
          return InkWell(
            onTap: () {
              // controller.setManualArguments({"id": log});
              final dta = {"id": log};
              Get.toNamed(Routes.scheduleDetail,arguments:dta );
              controller.setManualArguments(dta);
            },
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

  // Helper function to show a message (instead of alert)
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
