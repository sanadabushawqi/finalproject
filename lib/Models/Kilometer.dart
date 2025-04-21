class Kilometer{
  String vehicleName	 ;
  String vehicleID  ;
  String startKilo  ;
  String endKilo  ;



  Kilometer({
    this.vehicleName	  ="",
    this.vehicleID  ="",
    this.startKilo  ="",
    this.endKilo  ="",

  });

  factory Kilometer.fromJson(Map<String, dynamic> json)=>Kilometer(
    vehicleName	  :json["vehicleName	 "],
    vehicleID  :json["vehicleID "],
    startKilo  :json[" startKilo "],
    endKilo  :json["endKilo "],

  );

  Map<String,dynamic>tojson()=>{
    "vehicleName	 ":vehicleName	  ,
    "vehicleID ":vehicleID  ,
    "startKilo ":startKilo  ,
    "endKilo ":endKilo  ,

  };
}