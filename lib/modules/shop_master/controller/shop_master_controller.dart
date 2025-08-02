import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/location_util.dart';
import 'package:shop_app/common/select_image.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/shop_image_list_response.dart';
import 'package:shop_app/data/shop_master_service.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/add_shop_request.dart';
import 'package:shop_app/models/employee_response.dart';
import 'package:shop_app/models/product_master_response.dart';
import 'package:shop_app/models/schedule_request.dart';
import 'package:shop_app/models/shop_master_response.dart';

class ShopMasterController extends BaseController {
  final SessionPref _userManager = Get.find();
  final ShopMasterServiceProtocol masterService = Get.put(ShopMasterService());
  final TextEditingController searchCtr = TextEditingController(text: "a");
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
  final TextEditingController latLongCtr = TextEditingController();

  UploadImageController selectedImageCtr = UploadImageController(maxCount: 1);

  RxBool isLoding = false.obs;
  RxBool isSkuListLoding = false.obs;
  RxBool isAddShopLoding = false.obs;
  RxBool isExpanded = false.obs;
  RxBool photoMode = false.obs;
  RxList<ProductMaster> skuListApi = <ProductMaster>[].obs;
  RxList<ShopMasterModel> shopListApi = <ShopMasterModel>[].obs;

  Rx<ProductMaster> product = ProductMaster().obs;
  RxList<ProductMaster> selectedSkuList = <ProductMaster>[].obs;

  final dropDownOptions = ["Retail", "Whole Sale"];
  RxString selected = "Retail".obs;

  RxString latLonError = "".obs;
  String? scheduleId = "";

  ShopMasterModel? shop;
  Rx<ShopMasterModel> currentShop = ShopMasterModel().obs;

  @override
  void onInit() {
    super.onInit();
    _searchShopList("");
    // getShopList("");
  }

  void onProducSelected(ProductMaster prod) {
    product.value = prod;
    getScheduleSku();
  }

  Completer? completer;
  Future<void> getShopList(String query) async {
    if (completer != null && !completer!.isCompleted) {
      completer!.complete();
      isLoding.value = false;
    }
    completer = Completer();
    isLoding.value = true;
    try {
      final future = selected.value == "Retail"
          ? masterService.getShopByName(query)
          : masterService.getWholeSellerName(query);
      completer?.complete(future);
      final response = await completer!.future;
      shopListApi.value = response?.results ?? [];
      shopListApi.refresh();
      print(
        "selected.value::${selected.value}shopListApi.value${shopListApi.length}",
      );
      isLoding.value = false;
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
      shopListApi.value = [];
      shopListApi.refresh();
    } on SocketException catch (e) {
      shopListApi.value = [];
      shopListApi.refresh();
      // AppToast.showToast(message: e.message ?? "Failed to update Password");
    } on ServerException catch (e) {
      shopListApi.value = [];
      shopListApi.refresh();
      // AppToast.showToast(message: e.message ?? "Failed to Update Password");
    } catch (e) {
      shopListApi.value = [];
      shopListApi.refresh();
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

  Completer? taskSkuSchedule;
  Future<void> getScheduleSku() async {
    if (taskSkuSchedule != null && !taskSkuSchedule!.isCompleted) {
      taskSkuSchedule!.complete();
      isSkuListLoding.value = false;
    }
    taskSkuSchedule = Completer();
    isSkuListLoding.value = true;
    try {
      final future = masterService.getSkuListForSchedule(scheduleId);
      taskSkuSchedule?.complete(future);
      final response = await taskSkuSchedule!.future;
      (response.results ?? []).forEach((ProductMaster e) {
        if (product.value.id != null) {
          final p = product.value;
          if (p.sku == e.sku &&
              p.category == e.category &&
              p.productName == e.productName) {
            p.existingQuantity = e.existingQuantity;
            p.eQtyController.text = e.existingQuantity?.toString() ?? "0";
            product.value = p;
          }
        }
      });
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

  Completer? searchSopListTask;

  Rx<LocationLatLon> location = LocationLatLon().obs;
  Future<void> _searchShopList(String query) async {
    if (searchSopListTask != null && !searchSopListTask!.isCompleted) {
      searchSopListTask!.complete();
      isLoding.value = false;
    }

    searchSopListTask = Completer();
    isLoding.value = true;
    try {
      final future = masterService.getShopByName(query);
      searchSopListTask?.complete(future);
      final response = await searchSopListTask!.future;
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

  Future<void> updateShopImage() async {
    if (completer != null && !completer!.isCompleted) {
      completer!.complete();
      isAddShopLoding.value = false;
    }

    completer = Completer();
    isAddShopLoding.value = true;
    try {
      String image65 = "";
      selectedImageCtr.getImagesBase64().forEach((image) {
        image65 = image;
      });

      final request = AddShopImageRequest(
        shopId: shop?.id,
        isShop: selected.value == "Retail" ? 1 : 0,
        documentName: "SHOP_IMAG",
        image: image65,
      );

      final future = masterService.addShopImage(request);
      completer?.complete(future);
      final response = await completer!.future;
      if (response.responseCode == "Fail") {
        AppToast.showToast(message: "Failed to create new Shop");
      } else {
        Get.back(closeOverlays: true);
        AppToast.showToast(message: "Image uploaded sucessfull");
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

  void getMyLatLong() {
    LocationUtil.getLocation((location) {
      this.location.value = location;
      latLongCtr.text = "${location.lat}, ${location.long}";
    });
  }

  void resetAddShopDetail() {
    districtCtr.text = "";
    entityTypeCtr.text = "";
    licenseTypeCtr.text = "";
    shopTypeCtr.text = "";
    unitNameCtr.text = "";
    premisesAddressCtr.text = "";
    licenseNameCtr.text = "";
    createdByCtr.text = "";
    mobileNoCtr.text = "";
    photoMode.value = false;
    selectedImageCtr.setUploadedImages64([]);
  }

  void resetLocationUpdateDetail() {
    photoMode.value = false;
    latLongCtr.text = "";
    selectedImageCtr.setUploadedImages64([]);
  }

  Completer? updateLocationTask;
  Future<void> updateShopLocation() async {
    if (updateLocationTask != null && !updateLocationTask!.isCompleted) {
      updateLocationTask!.complete();
      isLoding.value = false;
    }
    updateLocationTask = Completer();
    isLoding.value = true;
    try {
      final request = UpdateShopLatLongRequestst(
        id: currentShop.value.id.toString(),
        lat: location.value.lat.toString(),
        lng: location.value.lat.toString(),
      );
      final future = selected.value == "Retail"
          ? masterService.updateShopLatlong(request)
          : masterService.updateShopWholeSellerLatlong(request);
      updateLocationTask?.complete(future);
      final response = await updateLocationTask!.future;
      if (response.responseCode == "fail") {
      } else {
        resetLocationUpdateDetail();
        Get.back();
        AppToast.showToast(message: "Update location Sucessfully");
      }
      isLoding.value = false;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Failed to update location";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message);
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message);
    } catch (e) {
      AppToast.showToast();
    } finally {
      isLoding.value = false;
    }
  }

  Completer? loadImagesTask;
  Future<void> getAllImagesOfShop(ShopMasterModel shop) async {
    final shopId = shop.id?.toString() ?? "";
    final shopType = selected.value == "Retail" ? "1" : "0";

    if (loadImagesTask != null && !loadImagesTask!.isCompleted) {
      loadImagesTask!.complete();
      isLoding.value = false;
    }
    loadImagesTask = Completer();
    isLoding.value = true;
    try {
      final future = masterService.getShopImage(shopId, shopType);
      loadImagesTask?.complete(future);
      final response = await loadImagesTask!.future;
      List<ShopImage> imageList = response.results ?? [];
      if (imageList.isNotEmpty) {
        final mList = <ImgData>[];
        for (var img in imageList) {
          mList.add(
            ImgData(
              imagePath: img.image ?? "",
              canEdit: false,
              isbase64: true,
              url: img.image,
            ),
          );
        }
        selectedImageCtr.setUploadedImages64(mList);
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
      isLoding.value = false;
    }
  }

  void setShopData(ShopMasterModel shop) {
    this.shop = shop;
    currentShop.value = shop;
    resetAddShopDetail();
    photoMode.value = true;
    districtCtr.text = shop.districtName ?? "";
    entityTypeCtr.text = shop.entityType ?? "";
    licenseTypeCtr.text = shop.licenceType ?? "";
    shopTypeCtr.text = shop.shopType ?? "";
    unitNameCtr.text = shop.unitName ?? "";
    premisesAddressCtr.text = shop.premisesAddress ?? "";
    licenseNameCtr.text = shop.licenceType ?? "";
    createdByCtr.text = shop.createdBy ?? "";
    mobileNoCtr.text = shop.mobileNumber ?? "";
    selectedImageCtr.reset();

  }
}
