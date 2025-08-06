class AddShopRequest {
  String? districtName;
  String? entityType;
  String? licenceType;
  String? shopType;
  String? unitName;
  String? premisesAddress;
  String? licenseName;
  String? mobileNumber;
  String? ownerName;

  AddShopRequest({
    this.districtName,
    this.entityType,
    this.licenceType,
    this.shopType,
    this.unitName,
    this.premisesAddress,
    this.licenseName,
    this.mobileNumber,
    this.ownerName,
  });
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['districtName'] = districtName;
    data['entityType'] = entityType;
    data['licenceType'] = licenceType;
    data['shopType'] = shopType;
    data['unitName'] = unitName;
    data['premisesAddress'] = premisesAddress;
    data['licenseName'] = licenseName;
    data['mobileNumber'] = mobileNumber;
    data['ownerName'] = ownerName;
    return data;
  }
}

class AddShopImageRequest {
  int? shopId;
  int? isShop;
  String? image;
  String? documentName;

  AddShopImageRequest({
    this.shopId,
    this.isShop,
    this.image,
    this.documentName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['shopId'] = shopId;
    data['isShop'] = isShop;
    data['image'] = image;
    data['documentName'] = documentName;
    return data;
  }
}
