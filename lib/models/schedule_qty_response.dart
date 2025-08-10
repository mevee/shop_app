class ScheduleQtyResponse {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<QtyResults>? results;
  String? invoiceUrl;
  bool? lastPage;

  ScheduleQtyResponse(
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

  ScheduleQtyResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <QtyResults>[];
      json['results'].forEach((v) {
        results!.add(QtyResults.fromJson(v));
      });
    }
    invoiceUrl = json['invoiceUrl'];
    lastPage = json['lastPage'];
  }

}


class QtyResults {
  int? id;
  int? productId;
  int? existingQuantity;
  int? currentQuantity;
  int? stockIn;
  int? sales;
  int? totalQuantity;
  double? totalPrice;
  int? scheduleId;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;
  String? productName;

  QtyResults(
      {this.id,
      this.productId,
      this.existingQuantity,
      this.currentQuantity,
      this.stockIn,
      this.totalQuantity,
      this.totalPrice,
      this.sales,
      this.scheduleId,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate,
      this.productName,
      });

  QtyResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    existingQuantity = json['existingQuantity'];
    stockIn = json['stockIn'];
    currentQuantity = json['currentQuantity'];
    totalQuantity = json['totalQuantity'];
    totalPrice = json['totalPrice'];
    sales = json['sales'];
    scheduleId = json['scheduleId'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    productName = json['productName'];
  }

}