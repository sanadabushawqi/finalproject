class Student{
  String studentID;
  String firstName;
  String lastName;
  String phone;
  String ID;
  String birthDate;
  String email;

  Student({
    this.studentID="",
    this.firstName="",
    this.lastName="",
    this.phone="",
    this.ID="",
    this.birthDate="",
    this.email="",
  });

  factory Student.fromJson(Map<String, dynamic> json)=>Student(
    studentID:json["studentID"],
    firstName:json["firstName"],
    lastName:json[" lastName"],
    phone:json["phone"],
    ID:json["ID"],
    birthDate:json["birthDate"],
    email:json["email"],
  );

  Map<String,dynamic>tojson()=>{
    "studentID":studentID,
    "firstName":firstName,
    " lastName": lastName,
    "phone":phone,
    "ID":ID,
    "birthDate":birthDate,
    "email":email,
  };
}