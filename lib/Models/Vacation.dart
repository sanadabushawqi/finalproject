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
    vacationName :json["vacationName"],
    startDate :json["startDate"],
    endDate :json[" endDate"],
    vacationLength :json["vacationLength"],

  );

  Map<String,dynamic>tojson()=>{
    "vacationName":vacationName ,
    "startDate":startDate ,
    "endDate":endDate ,
    "vacationLength":vacationLength ,

  };
}