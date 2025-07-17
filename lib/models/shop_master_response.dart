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




