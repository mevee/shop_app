class ShopImageLisResposne {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<ShopImage>? results;
  String? invoiceUrl;
  bool? lastPage;

  ShopImageLisResposne({
    this.action,
    this.responseStatus,
    this.responseCode,
    this.responseMessage,
    this.totalSize,
    this.totalPages,
    this.currentPage,
    this.currentSize,
    this.results,
    this.invoiceUrl,
    this.lastPage,
  });

  ShopImageLisResposne.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <ShopImage>[];
      json['results'].forEach((v) {
        results!.add(ShopImage.fromJson(v));
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

class ShopImage {
  int? id;
  int? shopId;
  int? isShop;
  String? image;
  int? isActive;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? documentName;

  ShopImage({
    this.id,
    this.shopId,
    this.isShop,
    this.image,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.documentName,
  });

  ShopImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shopId'];
    isShop = json['isShop'];
    image = json['image'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    documentName = json['documentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shopId'] = shopId;
    data['isShop'] = isShop;
    data['image'] = image;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdDate'] = createdDate;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    data['documentName'] = documentName;
    return data;
  }
}
