class Vehicle{
  String vehicleName	 ;
  String vehicleKilo  ;
  String vehicleMaintenance  ;



  Vehicle({
    this.vehicleName	  ="",
    this.vehicleKilo  ="",
    this.vehicleMaintenance  ="",

  });

  factory Vehicle.fromJson(Map<String, dynamic> json)=>Vehicle(
    vehicleName	  :json["vehicleName	 "],
    vehicleKilo  :json[" vehicleKilo "],
    vehicleMaintenance  :json["vehicleMaintenance "],

  );

  Map<String,dynamic>tojson()=>{
    "vehicleName	 ":vehicleName	  ,
    "vehicleKilo ":vehicleKilo  ,
    "vehicleMaintenance ":vehicleMaintenance  ,

  };
}