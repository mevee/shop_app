class CommonEntity<T> {
  String? responseCode;
  String? responseMessage;
  List<T>? results;
  CommonEntity({this.responseCode, this.responseMessage, this.results});
  CommonEntity.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    if (json['results'] != null) {
      results = <T>[];
      json['results'].forEach((v) {
        try {
          results!.add(v as T);
        } catch (e) {
          //print(e);
        }
      });
    }
  }
}
