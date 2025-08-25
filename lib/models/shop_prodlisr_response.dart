class ShopProductResponse {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<ShopProduct>? results;
  String? invoiceUrl;
  bool? lastPage;

  ShopProductResponse(
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

  ShopProductResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <ShopProduct>[];
      json['results'].forEach((v) {
        results!.add(ShopProduct.fromJson(v));
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

class ShopProduct {
  int? id;
  String? productName;
  String? category;
  String? sku;
  String? unitPrice;

  ShopProduct({this.id, this.productName, this.category, this.sku, this.unitPrice});

  ShopProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    category = json['category'];
    sku = json['sku'];
    unitPrice = json['unitPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productName'] = productName;
    data['category'] = category;
    data['sku'] = sku;
    data['unitPrice'] = unitPrice;
    return data;
  }
}