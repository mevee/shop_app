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


class QtyResults {
  int? id;
  int? productId;
  int? existingQuantity;
  int? newQuantity;
  int? totalQuantity;
  int? totalPrice;
  int? scheduleId;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;

  QtyResults(
      {this.id,
      this.productId,
      this.existingQuantity,
      this.newQuantity,
      this.totalQuantity,
      this.totalPrice,
      this.scheduleId,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  QtyResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    existingQuantity = json['existingQuantity'];
    newQuantity = json['newQuantity'];
    totalQuantity = json['totalQuantity'];
    totalPrice = json['totalPrice'];
    scheduleId = json['scheduleId'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['existingQuantity'] = existingQuantity;
    data['newQuantity'] = newQuantity;
    data['totalQuantity'] = totalQuantity;
    data['totalPrice'] = totalPrice;
    data['scheduleId'] = scheduleId;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    return data;
  }
}