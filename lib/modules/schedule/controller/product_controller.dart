import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/product_service.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/product_master_response.dart';

class ProductController extends BaseController {
  final SessionPref _userManager = Get.find();
  final ProductServiceProtocol scheduleService = Get.find();
  final TextEditingController searchCtr = TextEditingController();
  final TextEditingController existingQuantityController =
      TextEditingController();
  final TextEditingController newOrderQuantityController =
      TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  RxBool isLoding = false.obs;
  RxList<ProductMaster> productList = <ProductMaster>[].obs;
  Rx<ProductMaster> product = ProductMaster().obs;


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
      final future = scheduleService.getProductList();
      completer?.complete(future);
      final response = await completer!.future;
      productList.value = response.results ?? [];
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
}
