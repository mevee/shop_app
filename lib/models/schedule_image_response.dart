class ScheduleImageResponse {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<ImgResult>? results;
  String? invoiceUrl;
  bool? lastPage;

  ScheduleImageResponse(
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

  ScheduleImageResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <ImgResult>[];
      json['results'].forEach((v) {
        results!.add(ImgResult.fromJson(v));
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

class ImgResult {
  int? id;
  int? scheduleId;
  String? images;
  String? type;
  String? createdBy;
  Null updatedBy;
  String? createdDate;
  Null updatedDate;

  ImgResult(
      {this.id,
      this.scheduleId,
      this.images,
      this.type,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  ImgResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduleId = json['scheduleId'];
    images = json['images'];
    type = json['type'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['scheduleId'] = scheduleId;
    data['images'] = images;
    data['type'] = type;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    return data;
  }
}