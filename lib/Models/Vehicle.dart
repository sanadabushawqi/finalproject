class Vehicle{
  String vehicleName	 ;
  String vehicleID  ;
  String vehicleKilo  ;
  String vehicleMaintenance  ;



  Vehicle({
    this.vehicleName	  ="",
    this.vehicleID  ="",
    this.vehicleKilo  ="",
    this.vehicleMaintenance  ="",

  });

  factory Vehicle.fromJson(Map<String, dynamic> json)=>Vehicle(
    vehicleName	  :json["vehicleName	 "],
    vehicleID  :json["vehicleID "],
    vehicleKilo  :json[" vehicleKilo "],
    vehicleMaintenance  :json["vehicleMaintenance "],

  );

  Map<String,dynamic>tojson()=>{
    "vehicleName	 ":vehicleName	  ,
    "vehicleID ":vehicleID  ,
    "vehicleKilo ":vehicleKilo  ,
    "vehicleMaintenance ":vehicleMaintenance  ,

  };
}