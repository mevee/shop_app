class ShopMasterListResponse {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<ShopMasterResponse>? results;
  String? invoiceUrl;
  bool? lastPage;

  ShopMasterListResponse(
      {this.action,
      this.responseStatus,
      this.responseCode,
      this.responseMessage,
      this.totalSize,
      this.totalPages,
      this.currentPage,
      this.currentSize,
      this.results,
      this.invoiceUrl,
      this.lastPage});

  ShopMasterListResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <ShopMasterResponse>[];
      json['results'].forEach((v) {
        results!.add(ShopMasterResponse.fromJson(v));
      });
    }
    invoiceUrl = json['invoiceUrl'];
    lastPage = json['lastPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['responseStatus'] = responseStatus;
    data['responseCode'] = responseCode;
    data['responseMessage'] = responseMessage;
    data['totalSize'] = totalSize;
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    data['currentSize'] = currentSize;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['invoiceUrl'] = invoiceUrl;
    data['lastPage'] = lastPage;
    return data;
  }
}

class ShopMasterResponse {
  int? id;
  String? districtName;
  String? entityType;
  String? licenceType;
  String? shopType;
  String? unitName;
  String? premisesAddress;
  String? mobileNumber;
  String? ownerName;
  int? isActive;
  String? createdBy;
  String? updatedBy;
  String? updatedDate;
  String? createdDate;

  ShopMasterResponse(
      {this.id,
      this.districtName,
      this.entityType,
      this.licenceType,
      this.shopType,
      this.unitName,
      this.premisesAddress,
      this.mobileNumber,
      this.ownerName,
      this.isActive,
      this.createdBy,
      this.updatedBy,
      this.updatedDate,
      this.createdDate});
      
  ShopMasterResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtName = json['districtName'];
    entityType = json['entityType'];
    licenceType = json['licenceType'];
    shopType = json['shopType'];
    unitName = json['unitName'];
    premisesAddress = json['premisesAddress'];
    mobileNumber = json['mobileNumber'];
    ownerName = json['ownerName'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['districtName'] = districtName;
    data['entityType'] = entityType;
    data['licenceType'] = licenceType;
    data['shopType'] = shopType;
    data['unitName'] = unitName;
    data['premisesAddress'] = premisesAddress;
    data['mobileNumber'] = mobileNumber;
    data['ownerName'] = ownerName;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    data['createdDate'] = createdDate;
    return data;
  }
}




