import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/shop_master_service.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/add_shop_request.dart';
import 'package:shop_app/models/product_master_response.dart';
import 'package:shop_app/models/shop_master_response.dart';

class ShopMasterController extends BaseController {
  final SessionPref _userManager = Get.find();
  final ShopMasterServiceProtocol masterService = Get.put(ShopMasterService());
  final TextEditingController searchCtr = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  final TextEditingController districtCtr = TextEditingController();
  final TextEditingController entityTypeCtr = TextEditingController();
  final TextEditingController licenseTypeCtr = TextEditingController();
  final TextEditingController shopTypeCtr = TextEditingController();
  final TextEditingController unitNameCtr = TextEditingController();
  final TextEditingController premisesAddressCtr = TextEditingController();
  final TextEditingController licenseNameCtr = TextEditingController();
  final TextEditingController createdByCtr = TextEditingController();
  final TextEditingController mobileNoCtr = TextEditingController();

  RxBool isLoding = false.obs;
  RxBool isSkuListLoding = false.obs;
  RxBool isAddShopLoding = false.obs;
  RxList<ProductMaster> skuListApi = <ProductMaster>[].obs;
  RxList<ShopMasterModel> shopListApi = <ShopMasterModel>[].obs;

  Rx<ProductMaster> product = ProductMaster().obs;
  RxList<ProductMaster> selectedSkuList = <ProductMaster>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchShopList("");
  }

  void onProducSelected(ProductMaster prod) {
    product.value = prod;
  }

  Completer? completer;
  Future<void> getShopList() async {
    if (completer != null && !completer!.isCompleted) {
      completer!.complete();
      isLoding.value = false;
    }
    completer = Completer();
    isLoding.value = true;
    try {
      final future = masterService.getShopList();
      completer?.complete(future);
      final response = await completer!.future;
      shopListApi.value = response ?? [];
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      // AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  Completer? taskSkyList;
  Future<void> getSkuList() async {
    if (taskSkyList != null && !taskSkyList!.isCompleted) {
      taskSkyList!.complete();
      isSkuListLoding.value = false;
    }

    taskSkyList = Completer();
    isSkuListLoding.value = true;
    try {
      final future = masterService.getSkuList();
      taskSkyList?.complete(future);
      final response = await taskSkyList!.future;
      skuListApi.value = response.results ?? [];
      skuListApi.refresh();
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      // AppToast.showToast();
    } finally {
      isSkuListLoding.value = false;
    }
  }

  Future<void> searchShopList(String query) async {
    if (completer != null && !completer!.isCompleted) {
      completer!.complete();
      isLoding.value = false;
    }

    completer = Completer();
    isLoding.value = true;
    try {
      final future = masterService.getShopByName(query);
      completer?.complete(future);
      final response = await completer!.future;
      shopListApi.value = response.results ?? [];
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      // AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  Future<void> createShop() async {
    if (completer != null && !completer!.isCompleted) {
      completer!.complete();
      isAddShopLoding.value = false;
    }

    if (districtCtr.text.isEmpty) {
      AppToast.showToast(message: "Distric field is required");
      return;
    }

    if (entityTypeCtr.text.isEmpty) {
      AppToast.showToast(message: "Entity type field is required");
      return;
    }

    if (licenseTypeCtr.text.isEmpty) {
      AppToast.showToast(message: "Licence type field is required");
      return;
    }

    if (shopTypeCtr.text.isEmpty) {
      AppToast.showToast(message: "Shop type field is required");
      return;
    }

    if (unitNameCtr.text.isEmpty) {
      AppToast.showToast(message: "Unit name field is required");
      return;
    }

    if (licenseNameCtr.text.isEmpty) {
      AppToast.showToast(message: "Licence number field is required");
      return;
    }

    if (licenseNameCtr.text.isEmpty) {
      AppToast.showToast(message: "Address field is required");
      return;
    }

    if (mobileNoCtr.text.isEmpty) {
      AppToast.showToast(message: "Mobile field is required");
      return;
    }

    completer = Completer();
    isAddShopLoding.value = true;
    try {
      final request = AddShopRequest(
        district: districtCtr.text,
        entityType: entityTypeCtr.text,
        licenseType: licenseTypeCtr.text,
        licenseName: licenseNameCtr.text,
        shopType: shopTypeCtr.text,
        unitName: unitNameCtr.text,
        premisesAddress: premisesAddressCtr.text,
        mobileNo: mobileNoCtr.text,
      );
      final future = masterService.addShop(request);
      completer?.complete(future);
      final response = await completer!.future;
      if (response.responseCode == "Fail") {
        AppToast.showToast(message: "Failed to create new Shop");
      } else {
        AppToast.showToast(message: "Shop create sucessfull");
        Get.back(closeOverlays: true);
      }
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      // AppToast.showToast();
    } finally {
      isAddShopLoding.value = false;
    }
  }
}
