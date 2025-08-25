import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/drop_down.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/data/network/net_util.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/widgets/helper.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class ShopMasterScreen extends GetView<ShopMasterController> {
  const ShopMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Shop Master'),
        centerTitle: true,
        backgroundColor: AppColors.cherryRed,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              height: 36,
              child: buttonWithImage(
                disable: false,
                context: context,
                label: 'Add Shop',
                leftIcon: const Icon(Icons.add, color: AppColors.red),
                color: AppColors.white,
                textColor: AppColors.red,
                fontSize: 12,
                horiontal: 8,
                vertical: 2,
                onPressed: () {
                  controller.resetAddShopDetail();
                  Get.toNamed(Routes.createShop);
                  controller.isExpanded.value = !controller.isExpanded.value;
                },
              ),
            ),
          ),
        ],
      ),

      // floatingActionButton: ,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          children: [
            Obx(
              () => TextField(
                controller: controller.searchCtr,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search shop here",
                  prefixIcon: Icon(Icons.search, color: AppColors.neutral400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  suffix: controller.isLoding.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryAccent,
                          ),
                        )
                      : null,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.getShopList(controller.searchCtr.text);
                  }
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
                    hintText: "Search district",
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: AppColors.neutral400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: AppColors.lightGrey),
                    ),
                    suffix: controller.isLoding.value
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
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Obx(
                () => SizedBox(
                  width: double.maxFinite,
                  child: GenericDropdown<String>(
                    options: controller.dropDownOptions,
                    selectedOption: controller.selected.value,
                    hintText: "Select",
                    onChanged: (String? value) async {
                      controller.selected.value = value ?? "Retail";
                      await controller.getShopList(controller.searchCtr.text);
                      if (await NetUtil.isNetworkAvailable() == false) {
                        AppToast.showToast(message: "No internet connection");
                        return;
                      }
                    },
                  ),
                ),
              ),
            ),
            Obx(() => prgressAndNoDatFound(controller.isLoding.value)),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.shopListApi.length,
                  itemBuilder: (context, index) {
                    final shop = controller.shopListApi[index];
                    return Container(
                      margin: const EdgeInsets.all(6.0),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.store, color: AppColors.primary),
                              horizontalSpacing(8),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: shop.unitName ?? 'Unknown Shop',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "\nType: ${controller.selected.value == "Retail" ? shop.shopType : shop.licenceType}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "\nDistrict: ${shop.districtName}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "\nOwner: ${shop.ownerName}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "\nAddress: ${shop.premisesAddress}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                        // maxLines: 3,
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                      TextSpan(
                                        text: "\n${shop.mobileNumber}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actionBtns(shop, context),
                        ],
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
    );
  }

  Widget actionBtns(ShopMasterModel shop, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buttonWithImage(
            disable: false,
            context: context,
            horiontal: 8,
            vertical: 8,
            label: "Images",
            fontSize: 12,
            textColor: AppColors.white,
            color: AppColors.primary,
            leftIcon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              controller.setShopData(shop);
              controller.getAllImagesOfShop(shop);
              Get.toNamed(Routes.createShop);
            },
          ),
          horizontalSpacing(16),
          buttonWithImage(
            disable: false,
            context: context,
            label: "Location",
            fontSize: 12,
            horiontal: 8,
            vertical: 8,
            textColor: AppColors.white,
            color: AppColors.primaryAccent,
            leftIcon: Icon(Icons.location_on, color: Colors.white),
            onPressed: () {
              controller.resetLocationUpdateDetail();
              controller.setShopData(shop);
              Get.toNamed(Routes.updateLocation);
            },
          ),
        ],
      ),
    );
  }

  Widget prgressAndNoDatFound(bool value) {
    if (controller.searchCtr.text.isEmpty && controller.shopListApi.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "Please enter shop name to search",
            style: TextStyle(color: AppColors.neutral400),
          ),
        ),
      );
    } else if (controller.shopListApi.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "No Shops Found",
            style: TextStyle(color: AppColors.neutral400),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
