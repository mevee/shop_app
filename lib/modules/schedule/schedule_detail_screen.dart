import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/widgets/comon_widgets.dart';

class ScheduleDetailView extends GetView<ScheduleController> {
  const ScheduleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh),
      ),
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

              // Shop Details Dropdown
              Obx(
                () => DropdownButtonFormField<ShopMasterResponse>(
                  value: controller.selectedShop.value
                      ,
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
                  items: controller.shopDetailsOptions.map((ShopMasterResponse shop) {
                    return DropdownMenuItem<ShopMasterResponse>(
                      value: shop,
                      child: Text(shop.mobileNumber??"${shop.unitName} (${shop.shopType})"),
                    );
                  }).toList(),
                  onChanged: (ShopMasterResponse? newValue) {
                    controller.selectedShop.value = newValue;
                  },
                  isExpanded: true,
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
                onPressed:controller.submitForm,
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
}
