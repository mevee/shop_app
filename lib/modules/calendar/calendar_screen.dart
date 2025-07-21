import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/modules/calendar/controller/calender_controller.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/screens/calendar/add_shchedule_bottom.dart';

class CalendarScreen extends GetView<CallenderController> {
  const CalendarScreen({super.key});

  // Function to build a single day cell in the calendar grid
  Widget buildDayCell(DateTime date, {bool isCurrentMonth = true}) {
    // Determine if the cell should have a special background color (like red/green in the image)
    Color? backgroundColor;
    final bool hasData = controller.dailyData.containsKey(date);
    final bool isSpecialDay =
        date.day == 7 ||
        date.day == 19 ||
        date.day == 24; // Example days from image

    if (isSpecialDay) {
      backgroundColor = Colors.red.shade100; // Light red for highlighted days
    } else if (hasData && isCurrentMonth) {
      backgroundColor = Colors.green.shade100; // Light green for days with data
    }
    return InkWell(
      onTap: () {
        print(date);
        // final scheduleList = controller.checkIfSchedulAvailable(date);

        if (hasData) {
          Get.toNamed(
            Routes.scheduleList,
            arguments: {"date": DateFormatter.format(date)},
          );
          final ctr = Get.find<ScheduleController?>();
          ctr?.setManualArguments({"date": DateFormatter.format(date)});
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              Colors.white, // Default to white if no special color
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Day number
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 4.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: isCurrentMonth
                        ? Colors.black87
                        : Colors.grey.shade500, // Dim non-current month days
                  ),
                ),
              ),
            ),
            // List of data for the day
            if (hasData)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    itemCount: (controller.dailyData[date]?.length),
                    itemBuilder: (ctx, index) {
                      final item = controller.dailyData[date]![index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 2.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors
                              .yellow
                              .shade100, // Light blue background for text items
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          item.shopName ?? 'No Data',
                          style: TextStyle(fontSize: 9.0, color: Colors.black),
                          overflow: TextOverflow.clip, // Truncate long text
                          maxLines: 1,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Calendar'),
      //   centerTitle: true,
      //   backgroundColor: Colors.deepPurple,
      //   foregroundColor: Colors.white,
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddSheduleBottomSheet(context);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
            children: [
              monthTitleTopView1(),
              Obx(()=>  Visibility(
                visible: controller.isLoding.value,
                child: LinearProgressIndicator())),
              SizedBox(height: 8.0),
              weekDayTitleView2(),
              Obx(
                () => Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7, // 7 days in a week
                          childAspectRatio:
                              0.4, // Adjust to control cell height vs width
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 4.0,
                        ),
                    itemCount: controller.daysInGrid.length,
                    itemBuilder: (context, index) {
                      final date = controller.daysInGrid[index];
                      final bool isCurrentMonth =
                          date.month == controller.focusedMonth.value.month;
                      // return Container(color: Colors.amber,);
                      return buildDayCell(date, isCurrentMonth: isCurrentMonth);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Table weekDayTitleView2() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          children: controller.weekdays
              .map(
                (day) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget monthTitleTopView1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: controller.goToPreviousMonth,
          ),
          Obx(
            () => Text(
              DateFormat('MMMM yyyy').format(controller.focusedMonth.value),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: controller.goToNextMonth,
          ),
        ],
      ),
    );
  }

  void showAddSheduleBottomSheet(BuildContext context) {
    Get.bottomSheet(
      AddScheduleBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    ).whenComplete(() {
      // Optionally, you can refresh the calendar after adding a schedule
      controller.getTodaysScheduleList(
        DateFormatter.format(controller.focusedMonth.value),
      );
    });
  }
}
