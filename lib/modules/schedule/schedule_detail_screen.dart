import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/common/select_image.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/models/product_master_response.dart';
import 'package:shop_app/models/update_schedule_request.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/modules/shop_master/add_product_bottom.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/screens/calendar/shop_select_bottom.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class ScheduleDetailView extends GetView<ScheduleController> {
  const ScheduleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => Opacity(
              opacity:
                  (controller.past.value && controller.visted.value ||
                      controller.today.value && controller.visted.value)
                  ? 0.6
                  : 1,
              child: Column(
                children: <Widget>[
                  IgnorePointer(
                    ignoring: true,
                    child: TextFormField(
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
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Time Field
                  IgnorePointer(
                    ignoring: true,
                    child: TextFormField(
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
                  ),
                  const SizedBox(height: 15),
                  IgnorePointer(
                    ignoring: true,
                    child: InkWell(
                      onTap: () {
                        _showSelectShopDialog(context, controller);
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: TextFormField(
                          controller: controller.shopController,
                          // onTapOutside: ,
                          decoration: InputDecoration(
                            labelText: 'Select Shop',
                            hintText: 'Select Shop',
                            prefixIcon: const Icon(Icons.store),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
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
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      _showSelectProductDialog(context, null);
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
                              // color: Colors.blue,
                            ),
                          ),
                          buttonWithImage(
                            leftIcon: Icon(
                              size: 24,
                              Icons.add,
                              color: Colors.white,
                            ),
                            disable: false,
                            context: context,
                            textColor: Colors.white,
                            onPressed: () {

                            },
                            label: 'Add',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  listViewOfQtyView(),
                  // New Order Quantity (represented as a text field, but in real app could be a GridView/DataTable)
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Photos",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // color: Colors.blue,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),

                  UploadImageWidget(
                    controller: controller.selectedImageCtr,
                    enabled: !controller.addScheduleLoding.value,
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
                  const SizedBox(height: 16),
                  Obx(
                    () => buttonWithLoader(
                      disable:
                          (controller.past.value && controller.visted.value ||
                          controller.today.value && controller.visted.value ||
                          controller.updateScheduleLoding.value),
                      label: 'Submit',
                      color: AppColors.primary,
                      textColor: Colors.white,
                      progressColor: Colors.white,
                      onPressed: () => controller.submitForm(() {
                        Get.back();
                      }),
                      isLoading:
                          (controller.updateScheduleLoding.value ||
                          controller.isLoding.value),
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
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

  // Helper function to show a message (instead of alert)
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showSelectProductDialog(BuildContext context, ProductMaster? prduct) {
    ShopMasterController ctr = Get.find<ShopMasterController>();
    if (prduct != null) {
      ctr.product.value = prduct;
    } else {
      ctr.product.value = ProductMaster();
    }
    Get.bottomSheet(
      AddProductBottomSheet((product) {
        var eQty = int.parse(product.eQtyController.text);
        var nQty = int.parse(product.nQtyController.text);
        var unitPrice = double.parse(product.unitPrice ?? "0.0");
        controller.shopQtyList.add(
          QuantityDetailsList(
            existingQuantity: eQty,
            newQuantity: nQty,
            productId: product.id,
            totalPrice: unitPrice,
            totalQuantity: nQty,
            prodName: "${product.productName}(${product.sku})",
          ),
        );
        controller.shopQtyList.refresh();
        controller.calculateTotal();
      }),
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
      () => Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.red[200],
              border: BoxBorder.all(color: Colors.black54, width: .1),
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Prod Name",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "New QTY",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Exist QTY",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Unit Price",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.shopQtyList.length,
            itemBuilder: (ctx, index) {
              final model = controller.shopQtyList[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  border: BoxBorder.all(color: Colors.black54, width: .1),
                  // borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${model.prodName}",
                        maxLines: 2,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${model.newQuantity}",
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${model.existingQuantity}",
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${model.totalPrice}",
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    if (model.editable)
                      InkWell(
                        onTap: () {
                          controller.shopQtyList.remove(model);
                        },
                        child: Icon(Icons.close),
                      ),
                  ],
                ),
              );
            },
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              // color: Colors.blueGrey[200],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Total",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: Colors.black45),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${controller.totalNewQty}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${controller.totalExtQty}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${controller.totalPrice}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
