class User{
  String id;
  String name;
  String phone;
  String note;
  String Address;

  User({
    this.id="",
    this.name="",
    this.phone="",
    this.note="",
    this.Address="",
  });

  factory User.fromJson(Map<String, dynamic> json)=>User(
    id:json["id"],
    name:json["name"],
    phone:json["phone"],
    note:json["note"],
    Address:json["Address"],
  );

  Map<String,dynamic>tojson()=>{
    "id":id,
    "name":name,
    "phone":phone,
    "note":note,
    "Address":Address,
  };
}