class Schedule{
  String teacherID ;
  String studentID  ;
  String startTime  ;
  String endTime  ;



  Schedule({
    this.teacherID  ="",
    this.studentID  ="",
    this.startTime  ="",
    this.endTime  ="",

  });

  factory Schedule.fromJson(Map<String, dynamic> json)=>Schedule(
    teacherID  :json["teacherID "],
    studentID  :json["studentID "],
    startTime  :json[" startTime "],
    endTime  :json["endTime "],

  );

  Map<String,dynamic>tojson()=>{
    "teacherID ":teacherID  ,
    "studentID ":studentID  ,
    "startTime ":startTime  ,
    "endTime ":endTime  ,

  };
}