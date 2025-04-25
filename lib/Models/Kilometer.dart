class Kilometer{
  String date	 ;
  String vehicleID  ;
  String startKilo  ;
  String endKilo  ;



  Kilometer({
    this.date	  ="",
    this.vehicleID  ="",
    this.startKilo  ="",
    this.endKilo  ="",

  });

  factory Kilometer.fromJson(Map<String, dynamic> json)=>Kilometer(
    date	  :json["date	 "],
    vehicleID  :json["vehicleID "],
    startKilo  :json[" startKilo "],
    endKilo  :json["endKilo "],

  );

  Map<String,dynamic>tojson()=>{
    "date	 ":date	  ,
    "vehicleID ":vehicleID  ,
    "startKilo ":startKilo  ,
    "endKilo ":endKilo  ,

  };
}