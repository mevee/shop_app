import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/models/product_master_response.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/modules/shop_master/select_product_bottom.dart';
import 'package:shop_app/screens/calendar/shop_select_bottom.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:shop_app/widgets/comon_widgets.dart';
import 'package:shop_app/widgets/helper.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class AddProductBottomSheet extends GetView<ShopMasterController> {
  final Function(ProductMaster product)? onItemselect;
  const AddProductBottomSheet(this.onItemselect, {super.key});

  @override
  Widget build(BuildContext context) {
    // print(controller.hashCode);
    print(controller.product.value.eQtyController.text);
    return SafeArea(
      child: Container(
        height: 70.h(context),
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Add/Update Product",
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
            Expanded(
              child: Column(
                children: [
                  Obx(() => showProductView(context, controller.product.value)),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  //   child: Divider(color: AppColors.lightGrey),
                  // ),
                  Spacer(),
                  Obx(
                    () => buttonWithLoader(
                      label: "Submit",
                      color: AppColors.primary,
                      textColor: Colors.white,
                      onPressed: () {
                        if (controller
                            .product
                            .value
                            .eQtyController
                            .text
                            .isEmpty) {
                          AppToast.showToast(message: "Exiting Qty rquired.");
                        } else if (controller
                            .product
                            .value
                            .cQtyController
                            .text
                            .isEmpty) {
                          AppToast.showToast(message: "Current Qty rquired.");
                        } else if (controller
                            .product
                            .value
                            .stockQtyController
                            .text
                            .isEmpty) {
                          AppToast.showToast(message: "Stock Qty rquired.");
                        } else if (controller
                                .product
                                .value
                                .sellerCtr
                                .text
                                .isEmpty ||
                            controller.product.value.sellerCtr.text ==
                                "Select Seller") {
                          AppToast.showToast(message: "Seller not selected");
                        } else if (controller.product.value.id == null) {
                          AppToast.showToast(message: "No product selected");
                        } else {
                          onItemselect?.call(controller.product.value);
                          Get.back();
                        }
                      },
                      disable: controller.product.value.category != null
                          ? false
                          : true,
                      isLoading: false,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget showProductView(BuildContext context, ProductMaster data) {
    if (data.id == null) {
      return Expanded(
        child: Center(
          child: Column(
            children: [
              Text("No Product selected", style: TextStyle(fontSize: 16)),
              verticalSpacing(16),
              CommonWidgets.button(
                lable: "Click to Select",
                onPressed: () {
                  _showSelectProductDialog(context);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Icon(color: AppColors.black01, Icons.edit),
                      onTap: () {
                        _showSelectProductDialog(context);
                      },
                    ),
                  ],
                ),
                // verticalSpacing(8.0),
                lableValue(label: "Product:", value: data.productName ?? ""),
                verticalSpacing(4.0),
                lableValue(label: "SKU:", value: data.sku ?? ""),
                verticalSpacing(4.0),
                lableValue(label: "Category:", value: data.category ?? ""),
                verticalSpacing(4.0),
                lableValue(label: "unitPrice:", value: data.price ?? ""),
                verticalSpacing(4.0),
              ],
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: data.eQtyController,
            keyboardType: TextInputType.number,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Existing Quantity',
              hintText: 'Enter existing quantity',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: const Icon(Icons.inventory),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: data.cQtyController,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 14),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              labelText: 'Current Quantity',
              hintText: 'Enter current quantity',
              hintStyle: TextStyle(fontSize: 14),

              prefixIcon: const Icon(Icons.inventory),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: data.stockQtyController,
            style: TextStyle(fontSize: 14),

            keyboardType: TextInputType.number,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              labelText: 'Stock In',
              hintText: 'Enter stock',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: const Icon(Icons.inventory),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
          ),

          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              _showSelectShopDialog(context, data);
            },
            child: IgnorePointer(
              ignoring: true,
              child: CommonWidgets.text(
                controller: data.sellerCtr,
                readOnly: true,
                textColor: AppColors.black01,
                labelText: 'Select Seller',
                errorMessage: 'Seller required',
                fontSize: 14.0,
                isPassword: false,
                prefixIcon: Icon(Icons.store, color: Colors.black),
                tailfixIcon: Icon(Icons.arrow_drop_down, color: Colors.black),
              ),
            ),
          ),
        ],
      );
    }
  }

  void _showSelectProductDialog(BuildContext context) {
    controller.getScheduleSku();
    Get.bottomSheet(
      SelectSkuBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    );
  }

  Row lableValue({required String label, String? value}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black54,
          ),
        ),
        horizontalSpacing(8.0),
        Expanded(
          child: Text(
            value ?? '',
            maxLines: 2,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _showSelectShopDialog(BuildContext context, ProductMaster data) {
    ScheduleController controller = ScheduleController();
    controller.selectSeller();
    Get.bottomSheet(
      SelectShopBottomSheet(
        controller: controller,
        wholeSellerMode: true,
        onItemClick: (item) {
          data.seller = item;
          data.sellerCtr.text = item.unitName ?? "Unknown unit name";
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    );
  }
}
