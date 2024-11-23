class User{
  String userID;
  String firstName;
  String lastName;
  String password;
  String createdDateTime;


  User({
    this.userID="",
    this.firstName="",
    this.lastName="",
    this.password="",
    this.createdDateTime="",
  });

  factory User.fromJson(Map<String, dynamic> json)=>User(
    userID:json["id"],
    firstName:json["name"],
    lastName:json["phone"],
    password:json["note"],
    createdDateTime:json["Address"],
  );

  Map<String,dynamic>tojson()=>{
    "id":userID,
    "name":firstName,
    "phone":lastName,
    "note":password,
    "Address":createdDateTime,
  };
}