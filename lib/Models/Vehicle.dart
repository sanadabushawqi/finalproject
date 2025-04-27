class Vehicle{
  String vehicleID	 ;
  String vehicleName	 ;
  String vehicleKilo  ;
  String vehicleMaintenance  ;



  Vehicle({
    this.vehicleID	  ="",
    this.vehicleName	  ="",
    this.vehicleKilo  ="",
    this.vehicleMaintenance  ="",

  });

  factory Vehicle.fromJson(Map<String, dynamic> json)=>Vehicle(
    vehicleID	  :json["vehicleID"],
    vehicleName	  :json["vehicleName"],
    vehicleKilo  :json["vehicleKilo"],
    vehicleMaintenance  :json["vehicleMaintenance"],

  );

  Map<String,dynamic>tojson()=>{
    "vehicleID	 ":vehicleID	  ,
    "vehicleName	 ":vehicleName	  ,
    "vehicleKilo ":vehicleKilo  ,
    "vehicleMaintenance ":vehicleMaintenance  ,

  };
}