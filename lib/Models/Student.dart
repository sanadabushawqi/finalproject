class Student{
  String studentID;
  String firstName;
  String lastName;
  String phoneNumber;
  String ID;
  String birthDate;
  String email;
  String password;

  Student({
    this.studentID="",
    this.firstName="",
    this.lastName="",
    this.phoneNumber="",
    this.ID="",
    this.birthDate="",
    this.email="",
    this.password="",
  });

  factory Student.fromJson(Map<String, dynamic> json)=>Student(
    studentID:json["studentID"],
    firstName:json["firstName"],
    lastName:json["lastName"],
    phoneNumber:json["phoneNumber"],
    // ID:json["ID"],
    birthDate:json["birthDate"],
    email:json["email"],
    // password:json["password"],
  );


  // [{"studentID":1,"firstName":"sadasd","lastName":"sdasd","phone":"asdasd","birthDate":"sadasd","email":"asdsad"}]


  Map<String, dynamic>tojson()=>{
    "studentID":studentID,
    "firstName":firstName,
    "lastName": lastName,
    "phone":phoneNumber,
    "ID":ID,
    "birthDate":birthDate,
    "email":email,
    "password":password,
  };
}