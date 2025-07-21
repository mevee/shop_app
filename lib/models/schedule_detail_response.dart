class ScheduleDetailResponse {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<SchedulApiResults>? results;
  String? invoiceUrl;
  bool? lastPage;

  ScheduleDetailResponse({
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

  ScheduleDetailResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <SchedulApiResults>[];
      json['results'].forEach((v) {
        if (v != null) {
          results!.add(SchedulApiResults.fromJson(v));
        }
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

class SchedulApiResults {
  int? id;
  int? scheduleId;
  int? shopId;
  String? shopName;
  String? meetingStartDateTime;
  String? meetingEndDateTime;
  String? meetingPersonName;
  String? meetingPersonContactNumber;
  String? meetingRemarks;
  String? createdBy;
  String? createdDate;

  SchedulApiResults(
      {this.id,
      this.scheduleId,
      this.shopId,
      this.shopName,
      this.meetingStartDateTime,
      this.meetingEndDateTime,
      this.meetingPersonName,
      this.meetingPersonContactNumber,
      this.meetingRemarks,
      this.createdBy,
      this.createdDate});

  SchedulApiResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduleId = json['scheduleId'];
    shopId = json['shopId'];
    shopName = json['shopName'];
    meetingStartDateTime = json['meetingStartDateTime'];
    meetingEndDateTime = json['meetingEndDateTime'];
    meetingPersonName = json['meetingPersonName'];
    meetingPersonContactNumber = json['meetingPersonContactNumber'];
    meetingRemarks = json['meetingRemarks'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['scheduleId'] = scheduleId;
    data['shopId'] = shopId;
    data['shopName'] = shopName;
    data['meetingStartDateTime'] = meetingStartDateTime;
    data['meetingEndDateTime'] = meetingEndDateTime;
    data['meetingPersonName'] = meetingPersonName;
    data['meetingPersonContactNumber'] = meetingPersonContactNumber;
    data['meetingRemarks'] = meetingRemarks;
    data['createdBy'] = createdBy;
    data['createdDate'] = createdDate;
    return data;
  }
}
