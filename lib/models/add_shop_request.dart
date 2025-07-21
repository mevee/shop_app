class AddShopRequest {
  String? district;
  String? entityType;
  String? licenseType;
  String? shopType;
  String? unitName;
  String? premisesAddress;
  String? licenseName;
  String? mobileNo;

  AddShopRequest({
    this.district,
    this.entityType,
    this.licenseType,
    this.shopType,
    this.unitName,
    this.premisesAddress,
    this.licenseName,
    this.mobileNo,
  });

  AddShopRequest.fromJson(Map<String, dynamic> json) {
    district = json['district'];
    entityType = json['entityType'];
    licenseType = json['licenseType'];
    shopType = json['shopType'];
    unitName = json['unitName'];
    premisesAddress = json['premisesAddress'];
    licenseName = json['licenseName'];
    mobileNo = json['mobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['district'] = district;
    data['entityType'] = entityType;
    data['licenseType'] = licenseType;
    data['shopType'] = shopType;
    data['unitName'] = unitName;
    data['premisesAddress'] = premisesAddress;
    data['licenseName'] = licenseName;
    data['mobileNo'] = mobileNo;
    return data;
  }
}
