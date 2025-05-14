class Kilometer{
  String kilometerID;
  String date	 ;
  String vehicleID  ;
  String startKilo  ;
  String endKilo  ;



  Kilometer({
    this.kilometerID	  ="",
    this.date	  ="",
    this.vehicleID  ="",
    this.startKilo  ="",
    this.endKilo  ="",

  });

  factory Kilometer.fromJson(Map<String, dynamic> json)=>Kilometer(
    kilometerID	  :json["kilometerID"],
    date	  :json["date"],
    vehicleID  :json["vehicleID"],
    startKilo  :json["startKilo"],
    endKilo  :json["endKilo"],

  );

  Map<String,dynamic>tojson()=>{
    "kilometerID":kilometerID	  ,
    "date":date	  ,
    "vehicleID":vehicleID  ,
    "startKilo":startKilo  ,
    "endKilo":endKilo  ,

  };
}