import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/common/select_image.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/shop_master_service.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/add_schedule_request.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/models/schedule_detail_response.dart';
import 'package:shop_app/models/schedule_image_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/models/schedule_qty_response.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:shop_app/models/update_schedule_request.dart';
import 'package:velocity_x/velocity_x.dart';

enum ScheduleType {
  FRESH,
  FUTURE,
  VISITED,
  NOT_VISITED,
  TODAY_VISTED,
  TODAY_NOT_VISITED,
}

enum MeetingStatus { IDEAL, STARTED, END }

class ScheduleController extends BaseController {
  final SessionPref _userManager = Get.find();
  final ScheduleServiceProtocol scheduleService = Get.find();
  final ShopMasterServiceProtocol masterService = Get.put(ShopMasterService());
  UploadImageController selectedImageCtr = UploadImageController(maxCount: 5);

  final TextEditingController searchCtr = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  RxBool isLoding = false.obs;
  RxBool isDateWiseLoding = false.obs;
  RxBool isSearchLoading = false.obs;
  RxBool isImageLoading = false.obs;
  RxBool isGetQtyLoading = false.obs;
  RxBool past = false.obs;
  RxBool today = false.obs;
  RxBool future = false.obs;
  RxBool visted = false.obs;
  Rx<ScheduleType> type = ScheduleType.FUTURE.obs;

  RxBool scheduleDetailAdded = false.obs;
  RxBool updateScheduleLoding = false.obs;
  RxBool addScheduleLoding = false.obs;
  RxBool isLoginButtonLoading = false.obs;
  Rx<LoginResponse> userData = LoginResponse().obs;

  RxList<ShopMasterModel> shopDetailsOptions = <ShopMasterModel>[].obs;
  RxList<QuantityDetailsList> shopQtyListInput = <QuantityDetailsList>[].obs;
  RxInt totalExtQty = 0.obs;
  RxInt totalNewQty = 0.obs;
  RxDouble totalPrice = (0.0).obs;
  void calculateTotal() {
    totalExtQty.value = 0;
    totalNewQty.value = 0;
    totalPrice.value = 0.0;

    for (var e in shopQtyListInput) {
      totalExtQty += (e.existingQuantity ?? 0);
      totalNewQty += (e.newQuantity ?? 0);
      totalPrice.value += (e.totalPrice ?? 0.0);
    }
  }

  final TextEditingController shopController = TextEditingController();
  ShopMasterModel? selectedShop;
  Rx<String> selectedShopStr = "Select Shop".obs;
  Rx<ScheduleDateTimeModel> schedue = ScheduleDateTimeModel().obs;
  String? scheduleDate;
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;
  RxList<ScheduleDateTimeModel> skuListInput = <ScheduleDateTimeModel>[].obs;
  RxBool detailWasAdded = false.obs;
  bool isOnInitRan = false;

  void resetUi() {
    calculateTotal();
    skuListInput.clear();
    schedue.value = ScheduleDateTimeModel();
    isButtonEnabled.value = false;
    remainingSeconds.value = 0;
    meetingStarted.value = false;
    detailWasAdded.value = false;
    remarksController.text = "";
    closeTime();
  }

  //----time related
  RxBool meetingStarted = false.obs;
  Rx<MeetingStatus> meetingStatus = MeetingStatus.IDEAL.obs;
  RxBool isButtonEnabled = false.obs;
  RxInt remainingSeconds = 0.obs;
  Timer? _timer;

  // Start a 20-minute countdown
  void startCountdown() {
    meetingStarted.value = true;
    isButtonEnabled.value = true;
    remainingSeconds.value = 20 * 60; // 20 minutes in seconds
    meetingStatus.value = MeetingStatus.STARTED;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
        isButtonEnabled.value = false;
        meetingStatus.value = MeetingStatus.END;
      }
    });
  }

  // Format seconds to MM:SS
  String get formattedTime {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    closeTime();
    super.onClose();
  }

  void closeTime() {
    meetingStatus.value = MeetingStatus.IDEAL;
    meetingStarted.value = false;
    isButtonEnabled.value = false;
    remainingSeconds.value = 0;
    _timer?.cancel();
  }

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic>? data = Get.arguments;
    isOnInitRan = true;
    print("onInit()");

    _setInitialDate(data);
  }

  void _setInitialDate(Map<String, dynamic>? data) {
    print("setInitialDate(arg$data)");
    resetUi();

    if (data?.containsKey('id') == true) {
      schedue.value = data?['id']!;
      scheduleDetailAdded.value = false;
      past.value = false;
      visted.value = false;
      getScheduleDetails(schedue.value.id);
    } else if (data?.containsKey('date') == true) {
      scheduleDate = data?['date']!;
      getTodaysScheduleList(scheduleDate);
    }
    loadUserData();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    timeController.text = TimeOfDay.now().format(Get.context!);
  }

  void setManualArguments(Map<String, dynamic>? data) async {
    final Map<String, dynamic>? data = Get.arguments;
    if (isOnInitRan) {
      print("setManualArguments(arg$data)");
      _setInitialDate(data);
    }
  }

  Future<void> getTodaysScheduleList(String? date) async {
    print("getTodaysScheduleList($date)");
    isDateWiseLoding.value = true;
    try {
      final response = await scheduleService.getScheduleByDate(date);
      if (response.results != null && response.results!.isNotEmpty) {
        scheduleList.value = response.results!;
      } else {
        scheduleList.value = [];
      }
      scheduleList.refresh();
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
      isDateWiseLoding.value = false;
    }
  }

  Future<void> getScheduleDetails(int? scheduleId) async {
    isLoding.value = true;
    try {
      final response = await scheduleService.getScheduleDetails("$scheduleId");
      if (response.results != null && response.results!.isNotEmpty) {
        // scheduleList.value = response.results!.first;
        updaetUiAsPerOldScheduleData(response.results!.first);
        setUiAsPerSchedule(schedue.value, response.results!.first);
      } else {
        setUiAsPerSchedule(schedue.value, null);
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

  void loadUserData() async {
    await userManager.initPreferences();
    userData.value = userManager.getUserData() ?? LoginResponse();
  }

  void selectShop(ShopMasterModel shop) {
    selectedShop = shop;
    selectedShopStr.value = shop.unitName ?? "Select Shop";
    shopController.text = shop.unitName ?? 'Unknown Shop';
  }

  Completer? completer;
  Future<void> getShopList(String query) async {
    if (completer != null && !completer!.isCompleted) {
      completer!.complete();
      isSearchLoading.value = false;
    }

    if (query.isEmpty) {
      return;
    }
    completer = Completer();
    isSearchLoading.value = true;
    try {
      final future = masterService.getShopByName(query);
      completer?.complete(future);
      final response = await completer!.future;
      shopDetailsOptions.value = response.results ?? [];
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
      isSearchLoading.value = false;
    }
  }

  Completer? loadImagesTask;
  Future<void> getImages(String scheduleId) async {
    if (loadImagesTask != null && !loadImagesTask!.isCompleted) {
      loadImagesTask!.complete();
      isImageLoading.value = false;
    }
    loadImagesTask = Completer();
    isImageLoading.value = true;
    try {
      final future = scheduleService.getScheduleImages(scheduleId);
      loadImagesTask?.complete(future);
      final response = await completer!.future;
      List<ImgResult> imageList = response.results ?? [];
      if (imageList.isNotEmpty) {
        final mList = <ImgData>[];
        for (var img in imageList) {
          mList.add(
            ImgData(
              imagePath: img.images ?? "",
              canEdit: false,
              url: img.images,
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
      isImageLoading.value = false;
    }
  }

  Completer? loadQtyTask;
  Future<void> getQtyList(String scheduleId) async {
    if (loadQtyTask != null && !loadQtyTask!.isCompleted) {
      loadQtyTask!.complete();
      isGetQtyLoading.value = false;
    }
    loadQtyTask = Completer();
    isGetQtyLoading.value = true;
    try {
      final future = scheduleService.getScheduleQuantity(scheduleId);
      loadQtyTask?.complete(future);
      final response = await completer!.future;
      List<QtyResults> imageList = response.results ?? [];
      final mShopList = <QuantityDetailsList>[];

      for (var img in imageList) {
        mShopList.add(
          QuantityDetailsList(
            editable: false,
            existingQuantity: img.existingQuantity,
            newQuantity: img.newQuantity,
            productId: img.productId,
            totalPrice: img.totalPrice,
            totalQuantity: img.totalQuantity,
          ),
        );
        shopQtyListInput.clear();
        shopQtyListInput.value = mShopList;
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
      isGetQtyLoading.value = false;
    }
  }

  Future<void> addSchedule() async {
    if (dateController.text.isEmpty) {
      AppToast.showToast(message: 'Please select a date.');
      return;
    }
    if (timeController.text.isEmpty) {
      AppToast.showToast(message: 'Please select a time.');
      return;
    }
    if (selectedShop == null) {
      AppToast.showToast(message: 'Please select a shop.');
      return;
    }
    final shop = selectedShop;
    final combinedTime = '${dateController.text}T${timeController.text}';
    final request = AddScheduleRequest(
      userName: userData.value.login?.userName,
      shopId: shop?.id.toString(),
      shopName: shop?.unitName,
      scheduleDateTime: combinedTime, //todo
      // scheduleDateTime: DateFormatter.to24Format(combinedTime), //todo
      status: "ACTIVE",
      createdBy: userData.value.login?.role,
      day: dateController.text,
      isVisitDone: 0,
    );
    addScheduleLoding.value = true;

    try {
      final response = await scheduleService.addSchedule(request);
      if (response.responseCode?.toLowerCase() == "fail".toLowerCase()) {
        AppToast.showToast(
          message: response.responseMessage ?? 'Failed to add schedule.',
        );
      } else {
        Get.back(closeOverlays: true);
        AppToast.showToast(message: 'Schedule added successfully!');
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
      addScheduleLoding.value = false;
    }
  }

  void resetForm() {
    dateController.clear();
    timeController.clear();
    remarksController.clear();
    selectedShop = null;
    selectedDate = null;
    selectedTime = null;
  }

  Future<void> submitForm(Function() onDone) async {
    if (dateController.text.isEmpty) {
      AppToast.showToast(message: 'Please select a date.');
      return;
    }
    if (timeController.text.isEmpty) {
      AppToast.showToast(message: 'Please select a time.');
      return;
    }
    if (selectedShop == null) {
      AppToast.showToast(message: 'Please select a shop.');
      return;
    }

    updateScheduleLoding.value = true;
    final shop = selectedShop;
    final meetingDetail = MeetingDetails();
    final imageList = <MeetingImagesList>[];
    final quantityList = <QuantityDetailsList>[];
    final request = UpdateScheduleRequest(
      meetingDetails: meetingDetail,
      meetingImagesList: imageList,
      quantityDetailsList: quantityList,
    );
    meetingDetail.scheduleId = schedue.value.id;
    meetingDetail.shopId = shop?.id;
    meetingDetail.shopName = shop?.unitName;
    meetingDetail.meetingPersonName = shop?.ownerName;
    meetingDetail.meetingPersonContactNumber = shop?.mobileNumber;

    meetingDetail.meetingStartDateTime =
        '${dateController.text}T${timeController.text}'; //todo
    meetingDetail.meetingEndDateTime = DateFormatter.getCurrentDateTimeString();
    meetingDetail.meetingRemarks = remarksController.text;
    final mNewQtyList = shopQtyListInput.filter((n) => n.editable).toList();
    quantityList.addAll(mNewQtyList);
    selectedImageCtr.getImagesBase64().forEach((image) {
      final imageMeeting = MeetingImagesList(images: image, type: "shop-front");
      imageList.add(imageMeeting);
    });

    try {
      final response = await scheduleService.updateSchedule(request);
      if (response.responseCode?.toLowerCase() == "fail".toLowerCase()) {
        AppToast.showToast(
          message: response.responseMessage ?? 'Failed to add schedule.',
        );
      } else {
        closeTime();
        onDone();
        AppToast.showToast(message: 'Schedule update successfully!');
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
      updateScheduleLoding.value = false;
    }
  }

  void updaetUiAsPerOldScheduleData(SchedulApiResults scheduleApi) {
    scheduleDetailAdded.value = true;
    detailWasAdded.value = true;
    final mSchedule = schedue.value;
    mSchedule.createdBy = scheduleApi.createdBy;
    mSchedule.shopName = scheduleApi.shopName;
    shopController.text = scheduleApi.shopName ?? "";
    selectedShop = ShopMasterModel(
      id: scheduleApi.shopId,
      mobileNumber: scheduleApi.meetingPersonContactNumber,
      ownerName: scheduleApi.meetingPersonContactNumber,
      unitName: scheduleApi.shopName,
    );
    shopController.text = scheduleApi.shopName ?? "";
    remarksController.text = scheduleApi.meetingRemarks ?? "";
    mSchedule.scheduleDateTime = scheduleApi.meetingStartDateTime;

    if (scheduleApi.meetingStartDateTime != null &&
        scheduleApi.meetingStartDateTime!.split("T").length > 1) {
      final dateTimeArray = scheduleApi.meetingStartDateTime!.split("T");
      dateController.text = dateTimeArray[0];
      timeController.text = dateTimeArray[1];
    }
    schedue.value = mSchedule;
  }

  void setUiAsPerSchedule(
    ScheduleDateTimeModel value,
    SchedulApiResults? apiResultDetail,
  ) {
    type.value = ScheduleType.FUTURE;
    past.value = DateFormatter.isPastDate(value.scheduleDateTime!);
    today.value = DateFormatter.isToday(value.scheduleDateTime!);
    future.value = DateFormatter.isToday(value.scheduleDateTime!);
    type.value = value.isVisitDone == 0
        ? ScheduleType.NOT_VISITED
        : ScheduleType.VISITED;

    final mSchedule = schedue.value;
    if (apiResultDetail == null) {
      selectedShop = ShopMasterModel(
        id: int.parse(value.shopId ?? "0"),
        mobileNumber: value.shopName,
        ownerName: value.shopName,
        unitName: value.shopName,
      );
      shopController.text = mSchedule.shopName ?? "";
    }
    DateTime? dateTime;
    if (mSchedule.scheduleDateTime != null &&
        mSchedule.scheduleDateTime!.split("T").length > 1) {
      dateTime = DateFormatter.parse(mSchedule.scheduleDateTime!);
      final dateTimeArray = mSchedule.scheduleDateTime!.split("T");
      dateController.text = dateTimeArray[0];
      timeController.text = dateTimeArray[1];
      getImages(value.id.toString());
      getQtyList(value.id.toString());
    }
    if (dateTime != null) {}
    schedue.refresh();
  }
}
