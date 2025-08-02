class ClockInRequest {
  String? username;
  String? loginLong; // "2025-07-06T10:00:00"
  String? loginLat;
  ClockInRequest({this.username, this.loginLat, this.loginLong});

  ClockInRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    loginLong = json['loginLong'];
    loginLat = json['loginLat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['loginLat'] = loginLat;
    data['loginLong'] = loginLong;
    return data;
  }
}

class ClockRequest {
  int? id;
  String? username;
  String? loginTime; // "2025-07-06T10:00:00"
  String? loginLat;
  String? loginLong;
  String? logoutLat;
  String? logoutLong;
  ClockRequest({
    this.id,
    this.username,
    this.loginTime,
    this.loginLat,
    this.loginLong,
    this.logoutLat,
    this.logoutLong,
  });

  ClockRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    loginTime = json['loginTime'];
    loginLat = json['loginLat'];
    loginLong = json['loginLong'];
    logoutLat = json['logoutLat'];
    logoutLong = json['logoutLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['loginTime'] = loginTime;
    data['loginLat'] = loginLat;
    data['loginLong'] = loginLong;
    data['logoutLat'] = logoutLat;
    data['logoutLong'] = logoutLong;
    return data;
  }
}

class UserDateLatRequest {
  String? userName;
  String? loginTime; // "2025-07-06T10:00:00"
  double? lat;
  double? lng;
  UserDateLatRequest({this.userName, this.loginTime, this.lat, this.lng});

  UserDateLatRequest.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    loginTime = json['loginTime'];
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['loginTime'] = loginTime;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class GetDistanceRequest {
  String? userName;
  String? date;

  GetDistanceRequest({this.userName, this.date});

  GetDistanceRequest.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['date'] = date;
    return data;
  }
}

class LocationLatLon {
  double? lat = 0;
  double? long = 0;
  LocationLatLon({this.lat, this.long});
}

class GetDistanceResponse {
  String? responseCode;
  String? responseMessage;
  List<double>? results;
  GetDistanceResponse({this.responseCode, this.responseMessage, this.results});
  GetDistanceResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['results'] != null) {
      results = <double>[];
      json['results'].forEach((v) {
        if (v != null) {
          results!.add(v.toDouble());
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseCode'] = responseCode;
    data['responseMessage'] = responseMessage;
    if (results != null) {
      data['results'] = results!.map((v) => v).toList();
    }
    return data;
  }
}

class AttandanceResponse {
  String? responseMessage;
  String? responseCode;
  List<AttandanceModel>? results;
  AttandanceResponse({this.responseMessage, this.responseCode, this.results});

  AttandanceResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    if (json['results'] != null) {
      results = <AttandanceModel>[];
      json['results'].forEach((v) {
        results!.add(AttandanceModel.fromJson(v));
      });
    }
  }
}

class AttandanceModel {
  int? id;
  String? username;
  String? loginTime;
  String? loginLat;
  String? loginLong;
  String? logoutTime;
  String? logoutLat;
  String? logoutLong;
  int? isActive;
  String? createdBy;
  bool get isLoggedIn => loginTime != null && id != null;
  bool get isLoggedOut => logoutTime != null && id != null;
  AttandanceModel({
    this.id,
    this.username,
    this.loginTime,
    this.loginLat,
    this.loginLong,
    this.logoutTime,
    this.logoutLat,
    this.logoutLong,
    this.isActive,
    this.createdBy,
  });
  AttandanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    loginTime = json['loginTime'];
    loginLat = json['loginLat'];
    loginLong = json['loginLong'];
    logoutTime = json['logoutTime'];
    logoutLat = json['logoutLat'];
    logoutLong = json['logoutLong'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['loginTime'] = loginTime;
    data['loginLat'] = loginLat;
    data['loginLong'] = loginLong;
    data['logoutTime'] = logoutTime;
    data['logoutLat'] = logoutLat;
    data['logoutLong'] = logoutLong;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    return data;
  }

}
