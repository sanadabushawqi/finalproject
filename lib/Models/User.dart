class User{
  String userID;
  String firstName;
  String lastName;
  String password;
  String createdDateTime;
  String email;


  User({
    this.userID="",
    this.firstName="",
    this.lastName="",
    this.password="",
    this.createdDateTime="",
    this.email="",
  });

  factory User.fromJson(Map<String, dynamic> json)=>User(
    userID:json["userID"],
    firstName:json["firstName"],
    lastName:json["lastName"],
    password:json["password"],
    createdDateTime:json["createdDateTime"],
    email:json["email"],
  );

  Map<String,dynamic>tojson()=>{
    "userID":userID,
    "firstName":firstName,
    "lastName":lastName,
    "password":password,
    "createdDateTime":createdDateTime,
    "email":email,
  };
}