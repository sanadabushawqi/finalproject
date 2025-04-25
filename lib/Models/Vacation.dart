class Vacation{
  String vacationName ;
  String startDate ;
  String endDate ;



  Vacation({
    this.vacationName ="",
    this.startDate ="",
    this.endDate ="",

  });

  factory Vacation.fromJson(Map<String, dynamic> json)=>Vacation(
    vacationName :json["vacationName"],
    startDate :json["startDate"],
    endDate :json[" endDate"],

  );

  Map<String,dynamic>tojson()=>{
    "vacationName":vacationName ,
    "startDate":startDate ,
    "endDate":endDate ,

  };
}