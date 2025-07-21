import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/widgets/helper.dart';

class ShopMasterScreen extends GetView<ShopMasterController> {
  const ShopMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Shop Master'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.createShop);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:  8.0,horizontal: 16),
        child: Column(
          children: [
            Obx(
              () => TextField(
                controller: controller.searchCtr,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: "Search Shop",
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
                            color: Colors.deepPurpleAccent,
                          ),
                        )
                      : null,
                ),
                onChanged: (value) {
                  controller.searchShopList(value);
                },
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
                      child: Row(
                        children: [
                          Icon(Icons.store, color: Colors.purpleAccent),
                          horizontalSpacing(8),
                          Expanded(
                            child: Text(
                              maxLines: 3,
                              "${shop.unitName ?? 'Unknown Shop'}\nType:${shop.shopType}\nDistric:${shop.districtName}\nOwner:${shop.ownerName}\nMob:${shop.mobileNumber}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
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
