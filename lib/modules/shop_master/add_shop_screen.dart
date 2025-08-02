import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/drop_down.dart';
import 'package:shop_app/common/select_image.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:shop_app/modules/shop_master/controller/shop_master_controller.dart';
import 'package:shop_app/widgets/comon_widgets.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

class AddShopMasterScreen extends GetView<ShopMasterController> {
  const AddShopMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add Shop Master'),
        centerTitle: true,
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
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
                        if (controller.photoMode.value) {
                          controller.getAllImagesOfShop(
                            controller.shop ?? ShopMasterModel(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: controller.photoMode.value == true ? 0.5 : 1.0,
                child: CommonWidgets.text(
                  controller: controller.districtCtr,
                  labelText: 'Enter Distric',
                  errorMessage: 'Please enter distric name',
                  fontSize: 14.0,
                  textColor: Colors.black,
                  readOnly: controller.photoMode.value,
                  // prefixIcon: Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: controller.photoMode.value == true ? 0.5 : 1.0,
                child: CommonWidgets.text(
                  controller: controller.entityTypeCtr,
                  labelText: 'Enter Entity Type',
                  errorMessage: 'Please enter entity type',
                  fontSize: 14.0,
                  textColor: Colors.black,
                  readOnly: controller.photoMode.value,
                  // prefixIcon: Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: controller.photoMode.value == true ? 0.5 : 1.0,

                child: CommonWidgets.text(
                  controller: controller.licenseTypeCtr,
                  labelText: 'Enter Licence Type',
                  errorMessage: 'Please enter licence type name',
                  fontSize: 14.0,
                  textColor: Colors.black,
                  readOnly: controller.photoMode.value,
                ),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: controller.photoMode.value == true ? 0.5 : 1.0,

                child: CommonWidgets.text(
                  controller: controller.shopTypeCtr,
                  labelText: 'Enter Shop Type',
                  errorMessage: 'Please enter shop type name',
                  fontSize: 14.0,
                  textColor: Colors.black,
                  readOnly: controller.photoMode.value,
                ),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: controller.photoMode.value == true ? 0.5 : 1.0,

                child: CommonWidgets.text(
                  controller: controller.unitNameCtr,
                  labelText: 'Enter Unit name(Shop Name)',
                  errorMessage: 'Please enter unit name',
                  fontSize: 14.0,
                  textColor: Colors.black,
                  readOnly: controller.photoMode.value,
                ),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: controller.photoMode.value == true ? 0.5 : 1.0,

                child: CommonWidgets.text(
                  controller: controller.licenseNameCtr,
                  labelText: 'Enter Licence number',
                  errorMessage: 'Please enter licence number',
                  fontSize: 14.0,
                  textColor: Colors.black,
                  readOnly: controller.photoMode.value,
                ),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: controller.photoMode.value == true ? 0.5 : 1.0,
                child: CommonWidgets.text(
                  controller: controller.premisesAddressCtr,
                  labelText: 'Enter Address',
                  errorMessage: 'Please enter address',
                  fontSize: 14.0,
                  textColor: Colors.black,
                  readOnly: controller.photoMode.value,
                ),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: controller.photoMode.value == true ? 0.5 : 1.0,
                child: CommonWidgets.text(
                  controller: controller.mobileNoCtr,
                  labelText: 'Enter Mobile number',
                  errorMessage: 'Please enter mobile number',
                  fontSize: 14.0,
                  textColor: Colors.black,
                  readOnly: controller.photoMode.value,
                ),
              ),

              Obx(
                () => Visibility(
                  visible: controller.photoMode.value,
                  child: addImageViw(),
                ),
              ),
              const SizedBox(height: 16),

              Obx(
                () => buttonWithLoader(
                  disable: controller.isAddShopLoding.value,
                  isLoading: controller.isAddShopLoding.value,
                  context: context,
                  label: controller.photoMode.value
                      ? "Update Images"
                      : "Add Shop",
                  textColor: Colors.white,
                  progressColor: Colors.white,
                  color: AppColors.primary,
                  onPressed: () {
                    if (controller.photoMode.value) {
                      if (controller.selectedImageCtr.isEmpty.value) {
                        AppToast.showToast(message: "Select image first.");
                      } else {
                        controller.updateShopImage();
                      }
                    } else {
                      controller.createShop();
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

  Column addImageViw() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Add shop*",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Visibility(
            visible: controller.photoMode.value,
            child: UploadImageWidget(
              controller: controller.selectedImageCtr,
              enabled: controller.photoMode.value,
            ),
          ),
        ),
      ],
    );
  }
}
