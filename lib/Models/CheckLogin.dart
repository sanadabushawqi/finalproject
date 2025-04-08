class checkLoginModel {
  int? userID;
  // String? userTypeID;
  String? fullName;


  checkLoginModel({
    this.userID,
    // this.userTypeID,
    this.fullName,
  });


  factory checkLoginModel.fromJson(Map<String, dynamic> json) {
    return checkLoginModel(
      userID: json['userID'],
      // userTypeID: json['userTypeID'],
      fullName: json['fullName'],
    );
  }
}
