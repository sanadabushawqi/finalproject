class Test{
  String studentID  ;
  String startTime  ;
  String endTime  ;



  Test({
    this.studentID  ="",
    this.startTime  ="",
    this.endTime  ="",

  });

  factory Test.fromJson(Map<String, dynamic> json)=>Test(
    studentID  :json["studentID "],
    startTime  :json[" startTime "],
    endTime  :json["endTime "],

  );

  Map<String,dynamic>tojson()=>{
    "studentID ":studentID  ,
    "startTime ":startTime  ,
    "endTime ":endTime  ,

  };
}