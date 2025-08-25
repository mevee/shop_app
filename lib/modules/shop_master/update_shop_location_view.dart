import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/drop_down.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/widgets/comon_widgets.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class UpdateShopLoctionView extends GetView<ShopMasterController> {
  const UpdateShopLoctionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Upate Shop Location'),
        centerTitle: true,
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Shop Details",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.all(6.0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkWhite2,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black87.withOpacity(.5),
                        width: 0.7,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "SHOP: ${controller.currentShop.value.unitName ?? 'Unknown shop'}\nOwner: ${controller.currentShop.value.ownerName}\nLicence: ${controller.currentShop.value.licenceType}\nPhone: ${controller.currentShop.value.mobileNumber}\nAddress: ${controller.currentShop.value.premisesAddress}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => CommonWidgets.text(
                  controller: controller.latLongCtr,
                  labelText: 'Click to detect My location',
                  errorMessage: controller.latLonError.value,
                  fontSize: 14.0,
                  textColor: Colors.black,
                  readOnly: true,
                  isError: controller.latLonError.value.isEmpty,
                  onChange: (value) {
                    controller.latLonError.value = value.isEmpty
                        ? "Location not found. Click location icon to get location"
                        : "";
                  },
                  tailfixIcon: InkWell(
                    onTap: () {
                      controller.getMyLatLong();
                    },
                    child: Icon(Icons.location_on, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => buttonWithLoader(
                  disable: controller.isLoding.value,
                  isLoading: controller.isLoding.value,
                  context: context,
                  label: "Update shop location",
                  textColor: Colors.white,
                  progressColor: Colors.white,
                  color: AppColors.primary,
                  onPressed: () {
                    if (controller.latLongCtr.text.isEmpty) {
                      AppToast.showToast(
                        message: "Location not detected. Add location first",
                      );
                      controller.latLonError.value =
                          "Location not found. Click location icon to get location";
                    } else {
                      controller.updateShopLocation();
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
