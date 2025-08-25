class RememberModel { 
  String? userName;
  String? password;
     RememberModel({
    userName,
    password,
  });

  RememberModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['password'] =password;
    return data;
  }
}