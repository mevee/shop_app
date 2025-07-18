import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';

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
            child: controller.isDateWiseLoding.value?Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ):
                  scheduleListView(controller.scheduleList),
             
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
              
            },
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

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != controller.selectedDate) {
      controller.selectedDate = picked;
      controller.dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // Function to show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: controller.selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != controller.selectedTime) {
      controller.selectedTime = picked;
      controller.timeController.text = picked.format(context);
    }
  }

  // Function to handle form submission

  // Helper function to show a message (instead of alert)
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
