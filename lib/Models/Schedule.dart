class Schedule{
  String studentName ;
  String studentID  ;
  String startTime  ;
  String endTime  ;



  Schedule({
    this.studentName  ="",
    this.studentID  ="",
    this.startTime  ="",
    this.endTime  ="",

  });

  factory Schedule.fromJson(Map<String, dynamic> json)=>Schedule(
    studentName  :json["studentName "],
    studentID  :json["studentID "],
    startTime  :json[" startTime "],
    endTime  :json["endTime "],

  );

  Map<String,dynamic>tojson()=>{
    "studentName ":studentName  ,
    "studentID ":studentID  ,
    "startTime ":startTime  ,
    "endTime ":endTime  ,

  };
}