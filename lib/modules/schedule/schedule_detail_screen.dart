import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/dialog_util.dart';
import 'package:shop_app/common/select_image.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/models/product_master_response.dart';
import 'package:shop_app/models/schedule_request.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/modules/shop_master/add_product_bottom.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/screens/calendar/shop_select_bottom.dart';
import 'package:shop_app/widgets/helper.dart';
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
                  (controller.past.value && controller.visited.value ||
                      controller.today.value && controller.visited.value)
                  ? 0.6
                  : 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // timeWidgetAndSubmitButton(context),
                  const SizedBox(height: 15),
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
                  IgnorePointer(
                    ignoring: controller.detailWasAdded.value,
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
                              size: 20,
                              Icons.add,
                              color: Colors.white,
                            ),
                            disable: !_isEditable(),
                            context: context,
                            textColor: Colors.white,
                            onPressed: () {
                              print("${controller.profileImage.isEmpty.value}");
                              if (controller.userManager.getIsWorking() ==
                                  false) {
                                AppToast.showToast(
                                  message:
                                      "Before starting the meeting please checkin from home screen.",
                                );
                              } else if (controller
                                  .profileImage
                                  .isEmpty
                                  .value) {
                                AppToast.showToast(
                                  message: "Please slect a profile image first",
                                );
                              } else {
                                _showSelectProductDialog(context, null);
                              }
                            },
                            label: 'Add',
                            color: AppColors.cherryRed,
                            horiontal: 12,
                            vertical: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  IgnorePointer(
                    ignoring: controller.detailWasAdded.value,
                    child: Opacity(
                      opacity: controller.detailWasAdded.value ? 0.6 : 1,
                      child: listViewOfQtyView(context),
                    ),
                  ),
                  // New Order Quantity (represented as a text field, but in real app could be a GridView/DataTable)
                  const SizedBox(height: 20),

                  Visibility(
                    visible: !controller.detailWasAdded.value,
                    child: Text(
                      "Select Profile Image*",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        // color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: !controller.detailWasAdded.value,
                    child: UploadImageWidget(
                      controller: controller.profileImage,
                      enabled: (!controller.detailWasAdded.value),
                    ),
                  ),
                  Visibility(
                    visible: !controller.detailWasAdded.value,
                    child: const SizedBox(height: 15),
                  ),

                  Text(
                    "Add meeting images",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => UploadImageWidget(
                      controller: controller.selectedImageCtr,
                      enabled:
                          (!controller.detailWasAdded.value ||
                          !controller.profileImage.isEmpty.value),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: controller.remarksController,
                    maxLines: 4,
                    // Allows for multiple lines of input
                    keyboardType: TextInputType.multiline,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
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
                  actionButtonsBottomView(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row actionButtonsBottomView(BuildContext context) {
    print("visit Done ${controller.meetingStatus.value}");
    // print("visit Done ${controller.schedule.value.isVisitDone}");
    return Row(
      children: [
        Obx(
          () => Visibility(
            visible: (controller.meetingStatus.value == MeetingStatus.IDEAL),
            child: Expanded(
              child: buttonWithLoader(
                disable:
                    (controller.meetingStatus.value ==
                        MeetingStatus.CANCELLED ||
                    controller.updateScheduleLoading.value),
                label: 'Cancel',
                color: AppColors.lightGrey,
                textColor: Colors.black,
                progressColor: Colors.black,
                onPressed: () => showConfirmDialog(
                  context,
                  'Are you sure you want to cancel meeting?',
                  () {
                    controller.cancelMeeting();
                  },
                ),
                isLoading:
                    (controller.updateScheduleLoading.value ||
                    controller.isLoading.value),
                context: context,
              ),
            ),
          ),
        ),
        horizontalSpacing(16),
        Obx(
          () => Visibility(
            visible:
                (controller.meetingStatus.value == MeetingStatus.IDEAL) ||
                (controller.meetingStatus.value ==
                    MeetingStatus.CANCEL_REJECTED),
            child: Expanded(
              child: buttonWithLoader(
                disable:
                    (controller.past.value && controller.visited.value ||
                    controller.today.value && controller.visited.value ||
                    controller.updateScheduleLoading.value),
                label: 'Submit',
                color: AppColors.cherryRed,
                textColor: Colors.white,
                progressColor: Colors.white,
                onPressed: () {
                  if (controller.userManager.getIsWorking() == false) {
                    AppToast.showToast(
                      message:
                          "Before starting the meeting please checkin from home screen.",
                    );
                  } else if (controller.profileImage.isEmpty.value) {
                    AppToast.showToast(
                      message: "Please slect a profile image first",
                    );
                  } else if (controller.skListQtyInput.isEmpty) {
                    AppToast.showToast(
                      message: "Please add atleat one order quantity",
                    );
                  } else {
                    showConfirmDialog(
                      context,
                      'Are you sure you want complete metting?',
                      () {
                        // controller.startCountdown();
                        controller.submitForm();
                        // controller.startCountdown();
                        //
                      },
                    );
                  }
                },

                isLoading:
                    (controller.updateScheduleLoading.value ||
                    controller.isLoading.value),
                context: context,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Function to show date picker
  Future<void> showConfirmDialog(
    BuildContext context,
    String message,
    Function() onConfirm,
  ) async {
    showCustomDialog(
      context: context,
      title: 'Confirm',
      message: message,
      primaryButtonText: 'Yes',
      secondaryButtonText: 'No',
      isDestructiveAction: true,
      onPrimaryPressed: onConfirm,
      onSecondaryPressed: () {},
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

  void _showSelectProductDialog(
    BuildContext context,
    QuantityDetailsReq? editProduct,
  ) {
    ShopMasterController ctr = Get.find<ShopMasterController>();
    // print("${ctr.hashCode}");
    ctr.scheduleId = controller.schedule.value.id.toString();
    print("ctr.scheduleId${ctr.scheduleId}");

    if (editProduct != null) {
      final prod = ProductMaster(
        id: editProduct.productId,
        productName: editProduct.prodName,
        sku: editProduct.sku,
        category: editProduct.category,
        unitPrice: editProduct.totalPrice.toString(),
      );
      prod.eQtyController.text =
          editProduct.existingQuantity?.toString() ?? "0";
      prod.cQtyController.text = editProduct.currentQuantity?.toString() ?? "0";
      ctr.product.value = prod;
    } else {
      ctr.product.value = ProductMaster();
      // controller.product.value
    }
    Get.bottomSheet(
      AddProductBottomSheet((product) {
        var eQty = int.parse(product.eQtyController.text);
        var cQty = int.parse(product.cQtyController.text);
        var stockQty = int.parse(
          product.stockQtyController.text.isEmpty
              ? "0"
              : product.stockQtyController.text,
        );
        var price = double.parse(product.price ?? "0.0");

        if (editProduct != null) {
          editProduct.existingQuantity = eQty;
          editProduct.currentQuantity = cQty;
          editProduct.stockIn = stockQty;
          editProduct.productId = product.id;
          editProduct.totalPrice = cQty * price;
          editProduct.sku = product.sku;
          editProduct.sales = (eQty + stockQty) - cQty;
          editProduct.category = product.category;
          editProduct.prodName = "${product.productName}(${product.sku})";
        } else {
          controller.skListQtyInput.add(
            QuantityDetailsReq(
              existingQuantity: eQty,
              currentQuantity: cQty,
              stockIn: stockQty,
              productId: product.id,
              sku: product.sku,
              totalPrice: cQty * price,
              sales: (eQty + stockQty) - cQty,
              category: product.category,
              prodName: "${product.productName}(${product.sku})",
            ),
          );
        }

        controller.skListQtyInput.refresh();
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

  Widget listViewOfQtyView(BuildContext context) {
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
                  flex: 2,
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
                  flex: 1,

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
                  flex: 1,

                  child: Text(
                    "Current QTY",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,

                  child: Text(
                    "Stock IN",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Sales",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (controller.detailWasAdded.value == false)
                  SizedBox(width: 20, height: 16),
              ],
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.skListQtyInput.length,
            itemBuilder: (ctx, index) {
              final model = controller.skListQtyInput[index];
              return InkWell(
                onTap: () {
                  // print("${model.prodName}");
                  if (model.editable) _showSelectProductDialog(context, model);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    border: BoxBorder.all(color: Colors.black54, width: .1),
                    // borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,

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
                        flex: 1,

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
                        flex: 1,

                        child: Text(
                          "${model.currentQuantity}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,

                        child: Text(
                          "${model.stockIn}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,

                        child: Text(
                          "${model.sales}",
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
                            controller.skListQtyInput.remove(model);
                            controller.skListQtyInput.refresh();
                            controller.calculateTotal();
                          },
                          child: Icon(Icons.close),
                        ),
                    ],
                  ),
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
                  flex: 2,

                  child: Text(
                    "Total",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: Colors.black45),
                  ),
                ),
                Expanded(
                  flex: 1,

                  child: Text(
                    "${controller.totalExtQty}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${controller.currentQty}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${controller.stockQty}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${controller.totalSale.value}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                if (controller.detailWasAdded.value == false)
                  SizedBox(width: 20, height: 16),
              ],
            ),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            decoration: BoxDecoration(color: AppColors.lightGrey),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                horizontalSpacing(16),
                Text(
                  "Rs ${controller.total.value}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isEditable() {
    final editAllowed =
        (controller.meetingStatus.value == MeetingStatus.IDEAL) ||
        (controller.meetingStatus.value == MeetingStatus.CANCEL_REJECTED);
    return editAllowed;
  }
}
