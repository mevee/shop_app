class AddScheduleRequest {
  int? id;
  String? userName;
  String? scheduleDateTime;
  String? shopId;
  String? status;
  String? createdBy;
  String? day;
  String? shopName;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  int? isVisitDone;

  AddScheduleRequest(
      {
      this.id,
      this.userName,
      this.scheduleDateTime,
      this.shopId,
      this.status,
      this.createdBy,
      this.day,
      this.shopName,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.isVisitDone});

  AddScheduleRequest.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    scheduleDateTime = json['scheduleDateTime'];
    shopId = json['shopId'];
    status = json['status'];
    createdBy = json['createdBy'];
    day = json['day'];
    shopName = json['shopName'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    isVisitDone = json['isVisitDone'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    data['userName'] = userName;
    data['scheduleDateTime'] = scheduleDateTime;
    data['shopId'] = shopId;
    data['status'] = status;
    data['createdBy'] = createdBy;
    data['day'] = day;
    data['shopName'] = shopName;
    data['createdDate'] = createdDate;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    data['isVisitDone'] = isVisitDone;   
    return data;
  }
}