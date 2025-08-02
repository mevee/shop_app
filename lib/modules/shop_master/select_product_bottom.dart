import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:shop_app/widgets/helper.dart';

class SelectSkuBottomSheet extends GetView<ShopMasterController> {
  const SelectSkuBottomSheet({super.key});
 
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
                      "Slect Product",
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
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Divider(color: AppColors.lightGrey),
            ),
            Obx(() => prgressAndNoDatFound(controller.isSkuListLoding.value)),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: controller.skuListApi.length,
                  itemBuilder: (context, index) {
                    final shop = controller.skuListApi[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        controller.onProducSelected(shop);
                        
                        Get.back();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black87.withOpacity(.5),
                              width: 0.7,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.grid_on_outlined, color: Colors.blueAccent),
                            horizontalSpacing(8),
                            Expanded(
                              flex: 2,
                              child: Text(
                                maxLines: 3,
                                "${shop.productName ?? 'Unknown'}\nCategory: ${shop.category}\nSKU:${shop.sku}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ), 
                              ),
                            ),
                            horizontalSpacing(8),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Text(
                                    "Price: ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.blackText,
                                    ),
                                  ),
                                  Text(
                                    maxLines: 1,
                                    "${shop.unitPrice}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blackText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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
    } else if (controller.skuListApi.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "No Sku Found",
            style: TextStyle(color: AppColors.neutral400),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
