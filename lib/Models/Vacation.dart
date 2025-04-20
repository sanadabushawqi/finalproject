class Vacation{
  String vacationName ;
  String startDate ;
  String endDate ;
  String vacationLength ;



  Vacation({
    this.vacationName ="",
    this.startDate ="",
    this.endDate ="",
    this.vacationLength ="",

  });

  factory Vacation.fromJson(Map<String, dynamic> json)=>Vacation(
    vacationName :json["userID"],
    startDate :json["firstName"],
    endDate :json[" lastName"],
    vacationLength :json["password"],

  );

  Map<String,dynamic>tojson()=>{
    "userID":vacationName ,
    "firstName":startDate ,
    "lastName":endDate ,
    "password":vacationLength ,

  };
}