import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/common/drop_down.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:shop_app/widgets/helper.dart';

class SelectShopBottomSheet extends StatelessWidget {
  final Function(ShopMasterModel item)? onItemClick;
  final bool? wholeSellerMode;
  final ScheduleController controller;
  const SelectShopBottomSheet({
    super.key,
    required this.controller,
    this.onItemClick,
    this.wholeSellerMode,
  });

  @override
  Widget build(BuildContext context) {
    return
    // Scaffold(
    //   resizeToAvoidBottomInset: true,
    //   body:
    SafeArea(
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
                      "Select Shop",
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
            Obx(
              () => TextField(
                controller: controller.searchCtr,
                style: TextStyle(fontSize: 14),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: "Search Shop",
                  prefixIcon: Icon(Icons.search, color: AppColors.neutral400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  suffix: controller.isSearchLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                onChanged: (value) {
                  controller.getShopList(value);
                },
              ),
            ),
            verticalSpacing(8),
            Obx(
              () => Visibility(
                visible: controller.selected.value != "Retail",
                child: TextField(
                  controller: controller.placeCtr,
                style: TextStyle(fontSize: 14),
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: "Search distict",
                    prefixIcon: Icon(Icons.location_on, color: AppColors.neutral400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: AppColors.lightGrey),
                    ),
                    suffix: controller.isSearchLoading.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    controller.getShopList("");
                  },
                ),
              ),
            ),

            Visibility(
              visible: !(wholeSellerMode != null && wholeSellerMode == true),
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Obx(
                  () => SizedBox(
                    width: double.maxFinite,
                    child: GenericDropdown<String>(
                      options: controller.dropDownOptions,
                      selectedOption: controller.selected.value,
                      hintText: "Select",
                      onChanged: (value) {
                        controller.selected.value = value ?? "Retail";
                        controller.getShopList(controller.searchCtr.text);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => prgressAndNoDatFound(controller.isSearchLoading.value)),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.shopDetailsOptions.length,
                  itemBuilder: (context, index) {
                    final shop = controller.shopDetailsOptions[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        if (wholeSellerMode != null &&
                            wholeSellerMode == true) {
                          onItemClick!(shop);
                        } else {
                          controller.selectShop(shop);
                        }
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.store, color: AppColors.primary),
                            horizontalSpacing(8),
                            Flexible(
                              child: Text(
                                // maxLines: 3,
                                "${shop.unitName ?? 'Unknown Shop'}\nType:${controller.selected.value == "Retail"? shop.shopType:shop.licenceType}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
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
    if (controller.searchCtr.text.isEmpty &&
        controller.shopDetailsOptions.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "Please enter shop name to search",
            style: TextStyle(color: AppColors.neutral400),
          ),
        ),
      );
    } else if (controller.shopDetailsOptions.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "No ${controller.isRetail.value ? 'Retail' : 'Whole Sale'} Shops Found",
            style: TextStyle(color: AppColors.neutral400),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
