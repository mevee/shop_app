import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/models/product_master_response.dart';
import 'package:shop_app/modules/schedule/controller/product_controller.dart';
import 'package:shop_app/modules/schedule/select_product_bottom.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:shop_app/widgets/comon_widgets.dart';
import 'package:shop_app/widgets/helper.dart';

class AddProductBottomSheet extends GetView<ProductController> {
  const AddProductBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
            Obx(() => showProductView(context, controller.product.value)),
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Divider(color: AppColors.lightGrey),
            ),

            // Expanded(child: ,),
            const SizedBox(height: 16),
          ],
        ),
      ),
      // ),
    );
  }

  Widget prgressAndNoDatFound(bool value) {
    if (value) {
      return Expanded(
        child: Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (controller.productList.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "No prodct Found",
            style: TextStyle(color: AppColors.neutral400),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget showProductView(BuildContext context, [ProductMaster? data]) {
    if (data?.category == null) {
      return Expanded(
        child: Center(
          child: Column(
            children: [
              Text("No Product selected", style: TextStyle(fontSize: 18)),
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
      return Container(
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
            verticalSpacing(8.0),
            lableValue(label: "Product:", value: data?.productName ?? ""),
            verticalSpacing(4.0),
            lableValue(label: "SKU:", value: data?.sku ?? ""),
            verticalSpacing(4.0),
            lableValue(label: "Category:", value: data?.category ?? ""),
            verticalSpacing(4.0),
            lableValue(label: "unitPrice:", value: data?.unitPrice ?? ""),
            verticalSpacing(4.0),
          ],
        ),
      );
    }
  }

  void _showSelectProductDialog(BuildContext context) {
    controller.getShopList();
    Get.bottomSheet(
      SelectProductBottomSheet(),
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
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black54,
          ),
        ),
        horizontalSpacing(8.0),
        Text(
          value ?? '',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
