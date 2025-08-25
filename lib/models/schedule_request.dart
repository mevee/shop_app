import 'package:shop_app/models/shop_master_response.dart';

class UpdateScheduleRequest {
  MeetingDetails? meetingDetails;
  List<MeetingImagesList>? meetingImagesList;
  List<QuantityDetailsReq>? quantityDetailsList;

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

class QuantityDetailsReq {
  int? existingQuantity;
  int? currentQuantity;
  int? stockIn;
  int? sales;
  double? totalPrice;
  int? wholeSellerId;
  int? shopId;

  int? productId;
  bool editable = true;
  String? prodName = "";
  String? sku = "";
  String? category = "";
  ShopMasterModel? seller;
  
  QuantityDetailsReq({
    this.existingQuantity,
    this.currentQuantity,
    this.stockIn,
    this.sales,
    this.totalPrice,
    this.productId,
    this.editable = true,
    this.prodName,
    this.sku,
    this.category,
    this.wholeSellerId,
    this.shopId,
    this.seller,
  });

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
    data['currentQuantity'] = currentQuantity;
    data['stockIn'] = stockIn;
    data['sales'] = sales;
    data['totalPrice'] = totalPrice;
    data['productId'] = productId;
    data['wholeSellerId'] = wholeSellerId;
    data['shopId'] = shopId;
    return data;
  }
}

class AuthorizeRequest {
  int? id;
  String? isAuthorized;
  String? authorizedRemarks;

  AuthorizeRequest({this.isAuthorized, this.authorizedRemarks, this.id});

  AuthorizeRequest.fromJson(Map<String, dynamic> json) {
    isAuthorized = json['isAuthorized'];
    authorizedRemarks = json['authorizedRemarks'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isAuthorized'] = isAuthorized;
    data['authorizedRemarks'] = authorizedRemarks;
    data['id'] = id;
    return data;
  }
}

class UpdateShopLatLongRequestst {
  String? id;
  String? lat;
  String? lng;
  UpdateShopLatLongRequestst({this.id, this.lat, this.lng});

  UpdateShopLatLongRequestst.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
