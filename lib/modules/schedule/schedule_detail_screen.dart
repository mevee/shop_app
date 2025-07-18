import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/modules/schedule/add_product_bottom.dart';
import 'package:shop_app/modules/schedule/controller/product_controller.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/modules/schedule/select_product_bottom.dart';
import 'package:shop_app/screens/calendar/shop_select_bottom.dart';
import 'package:shop_app/widgets/comon_widgets.dart';

class ScheduleDetailView extends GetView<ScheduleController> {
  const ScheduleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Date Field
              TextFormField(
                controller: controller.dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Select Date',
                  prefixIcon: const Icon(Icons.calendar_today),
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
                readOnly:
                    true, // Makes the field non-editable, only selectable via picker
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 15),

              // Time Field
              TextFormField(
                controller: controller.timeController,
                decoration: InputDecoration(
                  labelText: 'Time',
                  hintText: 'Select Time',
                  prefixIcon: const Icon(Icons.access_time),
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
                readOnly: true,
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 15),

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
                    tailfixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Existing Quantity Textbox
              TextFormField(
                controller: controller.existingQuantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Existing Quantity',
                  hintText: 'Enter existing quantity',
                  prefixIcon: const Icon(Icons.inventory),
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
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  _showSelectProductDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "New Order Quantity (Grid)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      // Icon(size: 24, Icons.add,color: Colors.blue,),
                      Icon(size: 24, Icons.grid_on, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              listViewOfQtyView(),
              // New Order Quantity (represented as a text field, but in real app could be a GridView/DataTable)
              TextFormField(
                controller: controller.newOrderQuantityController,
                keyboardType: TextInputType
                    .text, // Could be number or text based on grid content
                decoration: InputDecoration(
                  labelText: 'New Order Quantity (Grid)',
                  hintText: 'Enter new order quantity details',
                  prefixIcon: const Icon(Icons.grid_on),
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
                maxLines:
                    2, // Allow multiple lines for potential grid-like input description
              ),
              const SizedBox(height: 20),

              CommonWidgets.button(
                lable: 'Capture Photo',
                color: Colors.blue.shade600,
                onPressed: () {
                  _showMessage(
                    context,
                    'Capture Photo functionality not implemented.',
                  );
                },
                icon: const Icon(Icons.camera, color: Colors.white),
              ),
              const SizedBox(height: 15),

              CommonWidgets.button(
                lable: 'Capture Video',
                color: Colors.blue.shade600,
                icon: const Icon(Icons.video_call, color: Colors.white),
              ),

              const SizedBox(height: 15),

              // Remarks MultiText Box
              TextFormField(
                controller: controller.remarksController,
                maxLines: 4, // Allows for multiple lines of input
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  hintText: 'Enter any additional remarks here...',
                  prefixIcon: const Icon(Icons.notes),
                  alignLabelWithHint: true,
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
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CommonWidgets.button(
                      lable: 'Submit',
                      color: Colors.blue.shade800,
                      onPressed: controller.submitForm,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CommonWidgets.button(
                      lable: 'Reset',
                      color: Colors.blue.shade800,
                      // onPressed: controller.submitForm,
                    ),
                  ),
                ],
              ),
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

  // Function to handle form submission

  // Helper function to show a message (instead of alert)
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }


void _showSelectProductDialog(
    BuildContext context,
   ) {
    ProductController controller = Get.find<ProductController>();
     Get.bottomSheet(
      AddProductBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    );
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

  Widget listViewOfQtyView() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        itemCount: controller.shopQtyList.length,
        itemBuilder: (ctx, index) {
          final model = controller.shopQtyList[index];
          return Container(
            decoration: BoxDecoration(),
            child: Row(
              children: [
                Text("${model.productId}"),
                // Text("${model.existingQuantity}"),
                Text("${model.newQuantity}"),
                InkWell(
                  onTap: (){
                    controller.shopQtyList.remove(model);
                  },
                  child: Icon(Icons.close)),
              ],
            ),
          );
        },
      ),
    );
  }
}
