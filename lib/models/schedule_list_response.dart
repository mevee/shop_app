class ScheduleListResponse {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<ScheduleDateTimeModel>? results;
  String? invoiceUrl;
  bool? lastPage;

  ScheduleListResponse({
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

  ScheduleListResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <ScheduleDateTimeModel>[];
      json['results'].forEach((v) {
        results!.add(ScheduleDateTimeModel.fromJson(v));
      });
    }
    invoiceUrl = json['invoiceUrl'];
    lastPage = json['lastPage'];
  }
}

class ScheduleDateTimeModel {
  int? id;
  String? userName;
  String? scheduleDateTime;
  String? shopId;
  String? status;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? shopName;
  String? day;
  int? isVisitDone;
  String? isAuthorized;
  String? authorizedRemarks;

  ScheduleDateTimeModel({
    this.id,
    this.userName,
    this.scheduleDateTime,
    this.shopId,
    this.status,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.shopName,
    this.day,
    this.isVisitDone,
    this.isAuthorized,
    this.authorizedRemarks,
  });

  ScheduleDateTimeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    scheduleDateTime = json['scheduleDateTime'];
    shopId = json['shopId'];
    status = json['status'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    shopName = json['shopName'];
    day = json['day'];
    isVisitDone = json['isVisitDone'];
    isAuthorized = json['isAuthorized'];
    authorizedRemarks = json['authorizedRemarks'];
  }
}
