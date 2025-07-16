import 'dart:ffi';

class ClockRequest {
  int? id;
  String? userName;
  String? loginTime; // "2025-07-06T10:00:00"
  String? loginLat;
  String? loginLong;
  String? logoutLat;
  String? logoutLong;
  ClockRequest({
    this.id,
    this.userName,
    this.loginTime,
    this.loginLat,
    this.loginLong,
    this.logoutLat,
    this.logoutLong,
  });

  ClockRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    loginTime = json['loginTime'];
    loginLat = json['loginLat'];
    loginLong = json['loginLong'];
    logoutLat = json['logoutLat'];
    logoutLong = json['logoutLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
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

class LocationLatLon{
  double? lat=0;
  double? long=0;
}

class GetDistanceResponse {
  String? responseCode;
  String? responseMessage;
  List<double>? results;
  GetDistanceResponse({this.responseCode, this.responseMessage,this.results});
  GetDistanceResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['results'] != null) {
      results = <double>[];
      json['results'].forEach((v) {
        results!.add(v.toDouble());
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
