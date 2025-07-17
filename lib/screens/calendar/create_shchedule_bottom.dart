import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:shop_app/widgets/comon_widgets.dart';

class AddScheduleBottomSheet extends StatelessWidget {
   AddScheduleBottomSheet({super.key});
  final ScheduleController controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
  //  controller.getShopList();

    return Obx(
      () => Container(
        height: 60.h(context),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  bottom: 24,
                  left: 16,
                  right: 16,
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
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                child: Divider(color: AppColors.lightGrey),
              ),
             
              // Shop Details Dropdown
              SizedBox(
                height: 50.h(context),
                child: DropdownButtonFormField<ShopMasterResponse>(
                  value: controller.selectedShop.value,
                  decoration: InputDecoration(
                    labelText: 'Shop Details',
                    hintText: 'Select a Shop',
                    prefixIcon: const Icon(Icons.store),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  items: controller.shopDetailsOptions.map((
                    ShopMasterResponse shop,
                  ) {
                    return DropdownMenuItem<ShopMasterResponse>(
                      value: shop,
                      child: Text(
                        shop.ownerName ?? "${shop.unitName} (${shop.shopType})",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (ShopMasterResponse? newValue) {
                    controller.selectedShop.value = newValue;
                  },
                  isExpanded: true,
                ),
              ),
              const SizedBox(height: 15),
              // SizedBox(
              //   height: 50.h(context),
              //   width: double.maxFinite,
              //   child: CommonWidgets.button(
              //     lable: 'Submit',
              //     color: Colors.blue.shade800,
              //     // onPressed: controller.submitForm(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
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
}
