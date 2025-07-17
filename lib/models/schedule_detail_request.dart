class ScheduleDetailRequest {
  MeetingDetails? meetingDetails;
  List<MeetingImagesList>? meetingImagesList;
  List<QuantityDetailsList>? quantityDetailsList;

  ScheduleDetailRequest(
      {this.meetingDetails, this.meetingImagesList, this.quantityDetailsList});

  ScheduleDetailRequest.fromJson(Map<String, dynamic> json) {
    meetingDetails = json['meetingDetails'] != null
        ?  MeetingDetails.fromJson(json['meetingDetails'])
        : null;
    if (json['meetingImagesList'] != null) {
      meetingImagesList = <MeetingImagesList>[];
      json['meetingImagesList'].forEach((v) {
        meetingImagesList!.add( MeetingImagesList.fromJson(v));
      });
    }
    if (json['quantityDetailsList'] != null) {
      quantityDetailsList = <QuantityDetailsList>[];
      json['quantityDetailsList'].forEach((v) {
        quantityDetailsList!.add( QuantityDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (meetingDetails != null) {
      data['meetingDetails'] = meetingDetails!.toJson();
    }
    if (meetingImagesList != null) {
      data['meetingImagesList'] =
          meetingImagesList!.map((v) => v.toJson()).toList();
    }
    if (quantityDetailsList != null) {
      data['quantityDetailsList'] =
          quantityDetailsList!.map((v) => v.toJson()).toList();
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

  MeetingDetails(
      {this.scheduleId,
      this.shopId,
      this.shopName,
      this.meetingStartDateTime,
      this.meetingEndDateTime,
      this.meetingPersonName,
      this.meetingPersonContactNumber,
      this.meetingRemarks});

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
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['images'] = images;
    data['type'] = type;
    return data;
  }
}

class QuantityDetailsList {
  int? existingQuantity;
  int? Quantity;
  int? totalQuantity;
  int? quantityDifference;
  int? totalPrice;
  int? productId;

  QuantityDetailsList(
      {this.existingQuantity,
      this.Quantity,
      this.totalQuantity,
      this.quantityDifference,
      this.totalPrice,
      this.productId});

  QuantityDetailsList.fromJson(Map<String, dynamic> json) {
    existingQuantity = json['existingQuantity'];
    Quantity = json['Quantity'];
    totalQuantity = json['totalQuantity'];
    quantityDifference = json['quantityDifference'];
    totalPrice = json['totalPrice'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['existingQuantity'] = existingQuantity;
    data['Quantity'] = Quantity;
    data['totalQuantity'] = totalQuantity;
    data['quantityDifference'] = quantityDifference;
    data['totalPrice'] = totalPrice;
    data['productId'] = productId;
    return data;
  }
}