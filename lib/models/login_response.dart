class LoginResponse { 
  String? token;
  String? message;
  String? status;
  UserData? login;
  LoginResponse({
    token,
    message,
    status, 
    login,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
    status = json['status'];
    login =
        json['login'] != null ? UserData.fromJson(json['login']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['message'] = message;
    data['status'] = status;
  
    if (login != null) {
      data['login'] = login!.toJson();
    }
    return data;
  }
}
 
class UserData {
 
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
  String? createdBy;
  String? updatedBy;
  String? updatedDate;
  String? managerName;
  UserData({
    id,
    userName,
    password,
    organizationName,
    address,
    contactNo,
    emailId,
    organizationGroupId,
    isActive,
    role,
    avatar,
    department,
    position,
    fullName,
    createdBy,
    updatedBy,
    updatedDate,
    managerName,
  });

  UserData.fromJson(Map<String, dynamic> json) {
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
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    managerName = json['managerName'];
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
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    data['managerName'] = managerName; 
    return data;
  }
}

class LoginRequest {
  String? userName;
  String? password;

  LoginRequest({userName, password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['password'] = password;
    return data;
  }
}

class VerifyEmailRequest {
  String? otp;
  String? email;

  VerifyEmailRequest({otp, email});

  VerifyEmailRequest.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    data['email'] = email;
    return data;
  }
}

class SignupRequest {
  String? message;
  String? status;
  String? email;
  String? password;
  String? countryCode;
  String? registrationType;
  String? type;

  SignupRequest({
    message,
    status,
    email,
    password,
    countryCode,
    registrationType,
    type,
  });

  SignupRequest.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    email = json['email'];
    password = json['password'];
    countryCode = json['countryCode'];
    registrationType = json['registrationType'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['email'] = email;
    data['password'] = password;
    data['countryCode'] = countryCode;
    data['registrationType'] = registrationType;
    data['type'] = type;
    return data;
  }
}
