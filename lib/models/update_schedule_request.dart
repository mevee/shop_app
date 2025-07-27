import 'package:fpdart/fpdart.dart';
import 'package:shop_app/models/product_master_response.dart';

class UpdateScheduleRequest {
  MeetingDetails? meetingDetails;
  List<MeetingImagesList>? meetingImagesList;
  List<QuantityDetailsList>? quantityDetailsList;

  UpdateScheduleRequest({
    this.meetingDetails,
    this.meetingImagesList,
    this.quantityDetailsList,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (meetingDetails != null) {
      data['meetingDetails'] = meetingDetails!.toJson();
    }
    if (meetingImagesList != null) {
      data['meetingImagesList'] = meetingImagesList!
          .map((v) => v.toJson())
          .toList();
    }
    if (quantityDetailsList != null) {
      data['quantityDetailsList'] = quantityDetailsList!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class MeetingDetails {
  int? scheduleId;
  int? shopId;
  String? shopName;
  String? meetingStartDateTime;
  String? meetingEndDateTime;
  String? meetingPersonName;
  String? meetingPersonContactNumber;
  String? meetingRemarks;

  MeetingDetails({
    this.scheduleId,
    this.shopId,
    this.shopName,
    this.meetingStartDateTime,
    this.meetingEndDateTime,
    this.meetingPersonName,
    this.meetingPersonContactNumber,
    this.meetingRemarks,
  });

  MeetingDetails.fromJson(Map<String, dynamic> json) {
    scheduleId = json['scheduleId'];
    shopId = json['shopId'];
    shopName = json['shopName'];
    meetingStartDateTime = json['meetingStartDateTime'];
    meetingEndDateTime = json['meetingEndDateTime'];
    meetingPersonName = json['meetingPersonName'];
    meetingPersonContactNumber = json['meetingPersonContactNumber'];
    meetingRemarks = json['meetingRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheduleId'] = scheduleId;
    data['shopId'] = shopId;
    data['shopName'] = shopName;
    data['meetingStartDateTime'] = meetingStartDateTime;
    data['meetingEndDateTime'] = meetingEndDateTime;
    data['meetingPersonName'] = meetingPersonName;
    data['meetingPersonContactNumber'] = meetingPersonContactNumber;
    data['meetingRemarks'] = meetingRemarks;
    return data;
  }
}

class MeetingImagesList {
  String? images;
  String? type;

  MeetingImagesList({this.images, this.type});

  MeetingImagesList.fromJson(Map<String, dynamic> json) {
    images = json['images'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['images'] = images;
    data['type'] = type;
    return data;
  }
}

class QuantityDetailsList {
  int? existingQuantity;
  int? newQuantity;
  int? totalQuantity;
  int? quantityDifference;
  double? totalPrice;
  int? productId;
  bool editable = true;
  String? prodName = "";
  String? sku = "";
  String? category = "";
  QuantityDetailsList({
    this.existingQuantity,
    this.newQuantity,
    this.totalQuantity,
    this.quantityDifference,
    this.totalPrice,
    this.productId,
    this.editable=true,
    this.prodName,
    this.sku,
    this.category,
  });

  QuantityDetailsList.fromJson(Map<String, dynamic> json) {
    existingQuantity = json['existingQuantity'];
    newQuantity = json['newQuantity'];
    totalQuantity = json['totalQuantity'];
    quantityDifference = json['quantityDifference'];
    totalPrice = json['totalPrice'];
    productId = json['productId'];
  }
  double getPrice(String? mPrice) {
    double price = 0.0;
    try {
      price = double.parse(mPrice ?? "0.0");
    } catch (e) {}

    return price;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['existingQuantity'] = existingQuantity;
    data['newQuantity'] = newQuantity;
    data['totalQuantity'] = totalQuantity;
    data['quantityDifference'] = quantityDifference;
    data['totalPrice'] = totalPrice;
    data['productId'] = productId;
    return data;
  }
}

class AuthorizeRequest {
  int? id;
  String? isAuthorized;
  String? authorizedRemarks;

  AuthorizeRequest({this.isAuthorized, this.authorizedRemarks,this.id});

  AuthorizeRequest.fromJson(Map<String, dynamic> json) {
    isAuthorized = json['images'];
    authorizedRemarks = json['authorizedRemarks'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['images'] = isAuthorized;
    data['authorizedRemarks'] = authorizedRemarks;
    data['id'] = id;
    return data;
  }
}