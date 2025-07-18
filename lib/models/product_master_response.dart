class ProductMasterListResponse {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<ProductMaster>? results;
  String? invoiceUrl;
  bool? lastPage;

  ProductMasterListResponse({
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

  ProductMasterListResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <ProductMaster>[];
      json['results'].forEach((v) {
        results!.add(ProductMaster.fromJson(v));
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

class ProductMaster {
  int? id;
  String? productName;
  String? category;
  String? sku;
  String? unitPrice;
  ProductMaster({
    this.id,
    this.productName,
    this.category,
    this.sku,
    this.unitPrice,
  });

  ProductMaster.fromJson(Map<String, dynamic> json) {
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
