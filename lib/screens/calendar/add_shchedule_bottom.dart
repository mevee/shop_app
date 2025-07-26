import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/screens/calendar/shop_select_bottom.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:shop_app/widgets/comon_widgets.dart';
import 'package:shop_app/widgets/helper.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class AddScheduleBottomSheet extends StatelessWidget {
  AddScheduleBottomSheet({super.key});
  final ScheduleController controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h(context),
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              // left: 16,
              // right: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Create Schedule",
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
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Divider(color: AppColors.lightGrey),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CommonWidgets.text(
                      controller: controller.dateController,
                      readOnly: true,
                      textColor: AppColors.black01,
                      labelText: 'Select Date',
                      errorMessage: 'Date is required',
                      fontSize: 14.0,
                      isPassword: false,
                      prefixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              horizontalSpacing(8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CommonWidgets.text(
                      controller: controller.timeController,
                      readOnly: true,
                      textColor: AppColors.black01,
                      labelText: 'Select Time',
                      errorMessage: 'Time is required',
                      fontSize: 14.0,
                      isPassword: false,
                      prefixIcon: Icon(
                        Icons.more_time_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          InkWell(
            onTap: () {
              _showSelectShopDialog(context, controller);
            },
            child: IgnorePointer(
              ignoring: true,
              child: CommonWidgets.text(
                controller: controller.shopController,
                readOnly: true,
                textColor: AppColors.black01,
                labelText: 'Select Shop',
                errorMessage: 'Shop is required',
                fontSize: 14.0,
                isPassword: false,
                prefixIcon: Icon(Icons.store, color: Colors.black),
                tailfixIcon: Icon(Icons.arrow_drop_down, color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Obx(
            () => buttonWithLoader(
              disable: controller.addScheduleLoading.value ? true : false,
              isLoading: controller.addScheduleLoading.value,
              context: context,
              color: AppColors.primaryPurple,
              textColor: Colors.white,
              progressColor: Colors.white,
              label: "SUBMIT",
              onPressed: () {
                controller.addSchedule();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(), // Minimum selectable date (today)
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

  void _showSelectShopDialog(
    BuildContext context,
    ScheduleController controller,
  ) {
    Get.bottomSheet(
      SelectShopBottomSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    );
  }
}
