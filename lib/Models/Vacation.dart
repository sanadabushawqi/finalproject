class Vacation{
  String vacationID;
  String vacationName ;
  String startDate ;
  String endDate ;



  Vacation({
    this.vacationID="",
    this.vacationName ="",
    this.startDate ="",
    this.endDate ="",

  });

  factory Vacation.fromJson(Map<String, dynamic> json)=>Vacation(
    vacationID :json["vacationID"],
    vacationName :json["vacationName"],
    startDate :json["startDate"],
    endDate :json["endDate"],

  );

  Map<String,dynamic>tojson()=>{
    "vacationID":vacationID ,
    "vacationName":vacationName ,
    "startDate":startDate ,
    "endDate":endDate ,

  };
}