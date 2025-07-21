class CommonResponse {
  String? responseMessage;
  String? responseCode;
  List<String>? results;

  CommonResponse({this.responseMessage, this.responseCode});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    if (json['results'] != null) {
      results = <String>[];
      json['results'].forEach((v) {
        results!.add(v);
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['responseMessage'] = responseMessage;
  //   data['responseCode'] = responseCode;
  //   return data;
  // }
}

class CommonModel {
  String? responseMessage;
  String? responseCode;

  CommonModel({this.responseMessage, this.responseCode});

  CommonModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
  }
}
