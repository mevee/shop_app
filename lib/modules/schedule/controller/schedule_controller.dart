import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/common/date_util.dart';
import 'package:shop_app/common/select_image.dart';
import 'package:shop_app/data/manager_service.dart';
import 'package:shop_app/data/meeting_model.dart';
import 'package:shop_app/data/schedule_service.dart';
import 'package:shop_app/data/shop_master_service.dart';
import 'package:shop_app/exception/exceptions.dart';
import 'package:shop_app/models/add_schedule_request.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/models/schedule_detail_request.dart'
    hide QuantityDetailsList, MeetingDetails, MeetingImagesList;
import 'package:shop_app/models/schedule_detail_response.dart';
import 'package:shop_app/models/schedule_image_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/models/schedule_qty_response.dart';
import 'package:shop_app/models/schedule_request.dart';
import 'package:shop_app/models/shop_master_response.dart';
import 'package:velocity_x/velocity_x.dart';

enum MeetingStatus {
  IDEAL,
  STARTED,
  COMPLETED,
  USER_AT_SHOP,
  CANCELLED,
  CANCEL_REJECTED,
}

class ScheduleController extends BaseController {
  final ScheduleServiceProtocol scheduleService = Get.put(ScheduleService());
  final ShopMasterServiceProtocol masterService = Get.put(ShopMasterService());
  final ManagerServiceProtocol _manageSchedule = Get.put(ManagerService());

  UploadImageController selectedImageCtr = UploadImageController(maxCount: 5);
  UploadImageController profileImage = UploadImageController(maxCount: 1);

  final TextEditingController searchCtr = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  RxBool isRetail = true.obs;
  final dropDownOptions = ["Retail", "Whole Sale"];
  RxString selected = "Retail".obs;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  RxBool isLoading = false.obs;
  RxBool isDateWiseLoading = false.obs;
  RxBool isSearchLoading = false.obs;
  RxBool isImageLoading = false.obs;
  RxBool isGetQtyLoading = false.obs;
  RxBool past = false.obs;
  RxBool today = false.obs;
  RxBool future = false.obs;
  RxBool visited = false.obs;

  RxBool scheduleDetailAdded = false.obs;
  RxBool updateScheduleLoading = false.obs;
  RxBool addScheduleLoading = false.obs;
  RxBool isLoginButtonLoading = false.obs;
  Rx<LoginResponse> userData = LoginResponse().obs;

  RxList<ShopMasterModel> shopDetailsOptions = <ShopMasterModel>[].obs;
  RxList<QuantityDetailsReq> skListQtyInput = <QuantityDetailsReq>[].obs;
  RxInt totalExtQty = 0.obs;
  RxInt currentQty = 0.obs;
  RxInt stockQty = 0.obs;

  RxDouble totalPrice = (0.0).obs;
  RxInt totalSale = (0).obs;
  RxDouble total = (0.0).obs;

  void selectSeller() {
    selected.value = dropDownOptions[1];
  }

  void calculateTotal() {
    totalExtQty.value = 0;
    currentQty.value = 0;
    totalPrice.value = 0.0;
    stockQty.value = 0;
    totalSale.value = 0;
    total.value = 0;

    for (var e in skListQtyInput) {
      totalExtQty += (e.existingQuantity ?? 0);
      currentQty += (e.currentQuantity ?? 0);
      stockQty += (e.stockIn ?? 0);
      totalPrice.value += (e.totalPrice ?? 0.0);
      totalSale.value += e.sales ?? 0;
      total.value += (e.totalPrice ?? 0.0);
    }
    total.value = total.value.round().toDouble();
  }

  final TextEditingController shopController = TextEditingController();
  ShopMasterModel? selectedShop;
  Rx<String> selectedShopStr = "Select Shop".obs;
  Rx<ScheduleDateTimeModel> schedule = ScheduleDateTimeModel().obs;
  String? scheduleDate;
  RxList<ScheduleDateTimeModel> scheduleList = <ScheduleDateTimeModel>[].obs;
  RxList<ScheduleDateTimeModel> skuListInput = <ScheduleDateTimeModel>[].obs;
  RxBool detailWasAdded = false.obs;
  bool isOnInitRan = false;

  void resetUi() {
    print("resetUi()");
    schedule.value = ScheduleDateTimeModel();
    is20minCrossed.value = false;
    secondPassed.value = 0;
    meetingStarted.value = false;
    detailWasAdded.value = false;
    remarksController.text = "";
    skListQtyInput.value = [];
    skuListInput.value = [];
    profileImage.reset();
    selectedImageCtr.reset();
    skuListInput.refresh();
    calculateTotal();
    closeTime();
  }

  //----time related
  RxBool meetingStarted = false.obs;
  Rx<MeetingStatus> meetingStatus = MeetingStatus.IDEAL.obs;
  RxBool is20minCrossed = false.obs;
  RxInt secondPassed = 0.obs;

  void checkIfMeetingWasStarted() {
    aLog("checkIfMeetingWasStarted()");
    final meet1 = userManager.getMeetingSession(schedule.value.id.toString());
    if (meet1 != null) {
      meetingStarted.value = true;
      updateSeconds();
    }
  }

  bool isMeetingStarted() {
    meetingStarted.value =
        userManager.getMeetingSession(schedule.value.id.toString()) != null;
    return meetingStarted.value;
  }

  void startMeetingTime() {
    aLog("startMeetingTime()");
    final scheduleId = schedule.value.id.toString();
    meetingStarted.value = true;
    is20minCrossed.value = false;
    secondPassed.value = 0;
    final meeting = MeetingData(
      sessionId: scheduleId,
      startTimeMillis: DateTime.now().millisecondsSinceEpoch,
    );
    userManager.saveMeetingSession(scheduleId, meeting);
  }

  void updateSeconds() {
    aLog("updateSeconds()");
    final scheduleId = schedule.value.id.toString();
    final meeting = userManager.getMeetingSession(scheduleId);
    if (meeting != null) {
      secondPassed.value = meeting.timePassedInSeconds();
    } else {
      secondPassed.value = 0;
    }
    if (secondPassed.value >= 20 * 60) {
      is20minCrossed.value = true;
    } else {
      is20minCrossed.value = false;
    }
  }

  @override
  void onClose() {
    closeTime();
    super.onClose();
  }

  void closeTime() {
    meetingStatus.value = MeetingStatus.IDEAL;
    meetingStarted.value = false;
    is20minCrossed.value = false;
    secondPassed.value = 0;
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
      schedule.value = data?['id']!;
      scheduleDetailAdded.value = false;
      past.value = false;
      visited.value = false;
      print("(arg${data?['id']})");
      getScheduleDetails(schedule.value.id);
      if (schedule.value.isVisitDone == 2) {
        meetingStatus.value = MeetingStatus.CANCELLED;
      } else if (schedule.value.isVisitDone == 1) {
        meetingStatus.value = MeetingStatus.COMPLETED;
      } else if (schedule.value.isVisitDone == 0 &&
          schedule.value.isAuthorized == "Authorized") {
        meetingStatus.value = MeetingStatus.IDEAL;
      } else if (schedule.value.isVisitDone == 0 &&
          schedule.value.isAuthorized == "Cancel Rejected") {
        meetingStatus.value = MeetingStatus.CANCEL_REJECTED;
      } else if (schedule.value.isVisitDone == 0 &&
          schedule.value.isAuthorized == "Cancel Accepted") {
        meetingStatus.value = MeetingStatus.COMPLETED;
      } else {
        meetingStatus.value = MeetingStatus.COMPLETED;
      }
    } else if (data?.containsKey('date') == true) {
      scheduleDate = data?['date']!;
      getTodaysScheduleList(scheduleDate);
    }
    loadUserData();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    timeController.text = TimeOfDay.now().format(Get.context!);
    checkIfMeetingWasStarted();
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
    isDateWiseLoading.value = true;
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
      isDateWiseLoading.value = false;
    }
  }

  Future<void> checkUserInParameter(String? date) async {
    print("getTodaysScheduleList($date)");
    isDateWiseLoading.value = true;
    try {
      final request = CheckUserAtShopRequest(scheduleId: schedule.value.id);
      final response = await scheduleService.checkUserAtShopLocation(request);

      if (response.responseCode == "Fail") {
        AppToast.showToast(message: "Failed to check user at shop location");
      } else {
        meetingStatus.value = MeetingStatus.USER_AT_SHOP;
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Failed to check user at shop location";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(
        message: e.message ?? "Failed to check user at shop location",
      );
    } on ServerException catch (e) {
      AppToast.showToast(
        message: e.message ?? "Failed to check user at shop location",
      );
    } catch (e) {
      AppToast.showToast();
    } finally {
      isDateWiseLoading.value = false;
    }
  }

  Future<void> getScheduleDetails(int? scheduleId) async {
    isLoading.value = true;
    try {
      final response = await scheduleService.getScheduleDetails("$scheduleId");
      if (response.results != null && response.results!.isNotEmpty) {
        // scheduleList.value = response.results!.first;
        updaetUiAsPerOldScheduleData(response.results!.first);
        setUiAsPerSchedule(schedule.value, response.results!.first);
        getImages(schedule.value.id.toString());
        getQtyList(schedule.value.id.toString());
      } else {
        setUiAsPerSchedule(schedule.value, null);
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
      isLoading.value = false;
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
      final future = selected.value == "Retail"
          ? masterService.getShopByName(query)
          : masterService.getWholeSellerName(query);
      completer?.complete(future);
      final response = await completer!.future;
      shopDetailsOptions.value = response.results ?? [];
    } on DioException catch (e) {
      // final errorMessage = e.response?.data['error'] ?? "Failed to update password";
      // AppToast.showToast(message: errorMessage);
      shopDetailsOptions.value = [];
      shopDetailsOptions.refresh();
    } on SocketException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to update Password");
      shopDetailsOptions.value = [];
      shopDetailsOptions.refresh();
    } on ServerException catch (e) {
      // AppToast.showToast(message: e.message ?? "Failed to Update Password");
      shopDetailsOptions.value = [];
      shopDetailsOptions.refresh();
    } catch (e) {
      // AppToast.showToast();
      shopDetailsOptions.value = [];
      shopDetailsOptions.refresh();
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
      final response = await loadImagesTask!.future;
      List<ImgResult> imageList = response.results ?? [];
      if (imageList.isNotEmpty) {
        final mList = <ImgData>[];
        for (var img in imageList) {
          mList.add(
            ImgData(
              imagePath: img.images ?? "",
              canEdit: false,
              isbase64: true,

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
      final response = await loadQtyTask!.future;
      List<QtyResults> result = response.results ?? [];
      final mShopList = <QuantityDetailsReq>[];
      for (var img in result) {
        mShopList.add(
          QuantityDetailsReq(
            prodName: img.productName ?? "Id:${img.productId}",
            editable: false,
            existingQuantity: img.existingQuantity,
            currentQuantity: img.currentQuantity,
            productId: img.productId,
            totalPrice: img.totalPrice,
            stockIn: img.stockIn,
            sales: img.sales,
            wholeSellerId: img.wholeSellerId,
            shopId: img.shopId,
          ),
        );
      }
      skListQtyInput.value = [];
      skListQtyInput.addAll(mShopList);
      skListQtyInput.refresh();
      calculateTotal();
      detailWasAdded.refresh();
      print("Qty::${skuListInput.length}");
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
      scheduleDateTime: combinedTime,
      //todo
      // scheduleDateTime: DateFormatter.to24Format(combinedTime), //todo
      status: "ACTIVE",
      createdBy: userData.value.login?.role,
      day: dateController.text,
      isVisitDone: 0,
    );
    addScheduleLoading.value = true;

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
      addScheduleLoading.value = false;
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

  Future<void> submitForm({bool is20MinCrossed = false}) async {
    if (profileImage.isEmpty.value) {
      AppToast.showToast(message: 'Please select a profile photo.');
      return;
    }

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

    updateScheduleLoading.value = true;
    final shop = selectedShop;
    final meetingDetail = MeetingDetails();
    final imageList = <MeetingImagesList>[];
    final quantityList = <QuantityDetailsReq>[];
    final request = UpdateScheduleRequest(
      meetingDetails: meetingDetail,
      meetingImagesList: imageList,
      quantityDetailsList: quantityList,
    );
    meetingDetail.scheduleId = schedule.value.id;
    meetingDetail.shopId = shop?.id;
    meetingDetail.shopName = shop?.unitName;
    meetingDetail.meetingPersonName = shop?.ownerName;
    meetingDetail.meetingPersonContactNumber = shop?.mobileNumber;

    meetingDetail.meetingStartDateTime =
        '${dateController.text}T${timeController.text}'; //todo
    meetingDetail.meetingEndDateTime = DateFormatter.getCurrentDateTimeString();
    meetingDetail.meetingRemarks = remarksController.text;
    final mNewQtyList = skListQtyInput.filter((n) => n.editable).toList();
    quantityList.addAll(mNewQtyList);
    profileImage.getImagesBase64().forEach((image) {
      final imageMeeting = MeetingImagesList(
        images: image,
        type: "profle-image",
      );
      imageList.add(imageMeeting);
    });
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
        if (is20MinCrossed = false) {
          userManager.removeMeetingSession(schedule.value.id.toString());
        }
      } else {
        closeTime();
        Get.back();
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
      updateScheduleLoading.value = false;
    }
  }

  Future<void> cancelMeeting() async {
    updateScheduleLoading.value = true;
    AuthorizeRequest request = AuthorizeRequest(
      id: schedule.value.id,
      authorizedRemarks: remarksController.text,
      isAuthorized: "Request to Cancel",
    );
    try {
      final response = await _manageSchedule.updateAuthorizeSchedule(request);
      if (response.responseCode?.toLowerCase() == "fail".toLowerCase()) {
        AppToast.showToast(
          message: response.responseMessage ?? 'Failed to add schedule.',
        );
      } else {
        Get.back(canPop: true);
        schedule.value.isAuthorized = "Request to Cancel";
        AppToast.showToast(message: 'Cancel request sent');
      }
      aLog("cancelSchedule${response.responseMessage}");
    } on DioException catch (e) {
      final errorMessage = e.response?.data['error'] ?? "Failed to cancelled";
      AppToast.showToast(message: errorMessage);
    } on SocketException catch (e) {
      AppToast.showToast(message: e.message);
    } on ServerException catch (e) {
      AppToast.showToast(message: e.message);
    } catch (e) {
      // AppToast.showToast();
    } finally {
      updateScheduleLoading.value = false;
    }
  }

  void updaetUiAsPerOldScheduleData(SchedulApiResults scheduleApi) {
    scheduleDetailAdded.value = true;
    detailWasAdded.value = true;
    final mSchedule = schedule.value;
    mSchedule.createdBy = scheduleApi.createdBy;
    mSchedule.shopName = scheduleApi.shopName;
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
    schedule.value = mSchedule;
  }

  void setUiAsPerSchedule(
    ScheduleDateTimeModel value,
    SchedulApiResults? apiResultDetail,
  ) {
    past.value = DateFormatter.isPastDate(value.scheduleDateTime!);
    today.value = DateFormatter.isToday(value.scheduleDateTime!);
    future.value = DateFormatter.isToday(value.scheduleDateTime!);

    final mSchedule = schedule.value;
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
    }
    if (dateTime != null) {}
    schedule.refresh();
    checkIfMeetingWasStarted();
  }
}
