import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
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
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            children: [
              CommonWidgets.text(
                controller: controller.districtCtr,
                labelText: 'Enter Distric',
                errorMessage: 'Please enter distric name',
                fontSize: 14.0,
                textColor: Colors.black,

                // prefixIcon: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(height: 16),
              CommonWidgets.text(
                controller: controller.entityTypeCtr,
                labelText: 'Enter Entity Type',
                errorMessage: 'Please enter entity type',
                fontSize: 14.0,
                textColor: Colors.black,

                // prefixIcon: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(height: 16),
              CommonWidgets.text(
                controller: controller.licenseTypeCtr,
                labelText: 'Enter Licence Type',
                errorMessage: 'Please enter licence type name',
                fontSize: 14.0,
                textColor: Colors.black,

                // prefixIcon: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(height: 16),
              CommonWidgets.text(
                controller: controller.shopTypeCtr,
                labelText: 'Enter Shop Type',
                errorMessage: 'Please enter shop type name',
                fontSize: 14.0,
                textColor: Colors.black,

                // prefixIcon: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(height: 16),
              CommonWidgets.text(
                controller: controller.unitNameCtr,
                labelText: 'Enter Unit name(Shop Name)',
                errorMessage: 'Please enter unit name',
                fontSize: 14.0,
                textColor: Colors.black,

                // prefixIcon: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(height: 16),
              CommonWidgets.text(
                controller: controller.licenseNameCtr,
                labelText: 'Enter Licence number',
                errorMessage: 'Please enter licence number',
                fontSize: 14.0,
                textColor: Colors.black,

                // prefixIcon: Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(height: 16),
              CommonWidgets.text(
                controller: controller.premisesAddressCtr,
                labelText: 'Enter Address',
                errorMessage: 'Please enter address',
                fontSize: 14.0,
                textColor: Colors.black,

                // prefixIcon: Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(height: 16),
              CommonWidgets.text(
                controller: controller.mobileNoCtr,
                labelText: 'Enter Mobile number',
                errorMessage: 'Please enter mobile number',
                fontSize: 14.0,
                textColor: Colors.black,
                // prefixIcon: Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Obx(
                () => buttonWithLoader(
                  disable: controller.isAddShopLoding.value,
                  isLoading: controller.isAddShopLoding.value,
                  context: context,
                  label: "Add Shop",
                  textColor: Colors.white,
                  progressColor: Colors.white,
                  color: Colors.deepPurple,
                  onPressed: () {
                    controller.createShop();
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
