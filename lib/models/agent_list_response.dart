class AgentListResponse {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<AgentModel>? results;
  String? invoiceUrl;
  bool? lastPage;

  AgentListResponse({
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

  AgentListResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <AgentModel>[];
      json['results'].forEach((v) {
        results!.add(AgentModel.fromJson(v));
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

//I/flutter (13322): ║                 "createdBy": null,
// I/flutter (13322): ║                 "updatedBy": null,
// I/flutter (13322): ║                 "updatedDate": null,
// I/flutter (13322): ║                 "managerName": "Pawan Kumar (ASM)",
// I/flutter (13322): ║                 "managerId": "manager@hamster.com"
class AgentModel {
  
  int? id;
  String? userName;
  String? password;
  String? organizationName;
  String? address;
  String? contactNo;
  String? emailId;
  String? organizationGroupId;
  int? isActive;
  String? role;
  String? avatar;
  String? department;
  String? position;
  String? fullName;
  // Null createdBy;
  // Null updatedBy;
  // Null updatedDate;
  String? managerName;
  String? managerId;

  AgentModel(
      {this.id,
      this.userName,
      this.password,
      this.organizationName,
      this.address,
      this.contactNo,
      this.emailId,
      this.organizationGroupId,
      this.isActive,
      this.role,
      this.avatar,
      this.department,
      this.position,
      this.fullName,
      // this.createdBy,
      // this.updatedBy,
      // this.updatedDate,
      this.managerName,
      this.managerId});

  AgentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    password = json['password'];
    organizationName = json['organizationName'];
    address = json['address'];
    contactNo = json['contactNo'];
    emailId = json['emailId'];
    organizationGroupId = json['organizationGroupId'];
    isActive = json['isActive'];
    role = json['role'];
    avatar = json['avatar'];
    department = json['department'];
    position = json['position'];
    fullName = json['fullName'];
    // createdBy = json['createdBy'];
    // updatedBy = json['updatedBy'];
    // updatedDate = json['updatedDate'];
    managerName = json['managerName'];
    managerId = json['managerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['password'] = password;
    data['organizationName'] = organizationName;
    data['address'] = address;
    data['contactNo'] = contactNo;
    data['emailId'] = emailId;
    data['organizationGroupId'] = organizationGroupId;
    data['isActive'] = isActive;
    data['role'] = role;
    data['avatar'] = avatar;
    data['department'] = department;
    data['position'] = position;
    data['fullName'] = fullName;
    // data['createdBy'] = createdBy;
    // data['updatedBy'] = updatedBy;
    // data['updatedDate'] = updatedDate;
    data['managerName'] = managerName;
    data['managerId'] = managerId;
    return data;
  }

  @override
  String toString() {
    return '$fullName';
  }
 
}




class AgentAddressResponse {
  String? action;
  int? responseStatus;
  String? responseCode;
  String? responseMessage;
  int? totalSize;
  int? totalPages;
  int? currentPage;
  int? currentSize;
  List<String>? results;

  AgentAddressResponse({
    this.action,
    this.responseStatus,
    this.responseCode,
    this.responseMessage,
    this.totalSize,
    this.totalPages,
    this.currentPage,
    this.currentSize,
    this.results
  });

  AgentAddressResponse.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    responseStatus = json['responseStatus'];
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    totalSize = json['totalSize'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    currentSize = json['currentSize'];
    if (json['results'] != null) {
      results = <String>[];
      json['results'].forEach((v) {
        results!.add(v);
      });
    }
  }
}