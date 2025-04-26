class Schedule{
  String scheduleID ;
  String teacherID ;
  String studentID  ;
  String startTime  ;
  String endTime  ;
  String studentName  ;



  Schedule({
    this.teacherID  ="",
    this.studentID  ="",
    this.startTime  ="",
    this.endTime  ="",
    this.scheduleID  ="",
    this.studentName  ="",

  });

  factory Schedule.fromJson(Map<String, dynamic> json)=>Schedule(
    scheduleID: json["scheduleID"],
    teacherID: json["teacherID"],
    studentID: json["studentID"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    studentName: json["studentName"],


  );




  Map<String,dynamic>tojson()=>{
    "scheduleID":scheduleID  ,
    "teacherID":teacherID  ,
    "studentID":studentID  ,
    "startTime":startTime  ,
    "endTime":endTime  ,
    "scheduleID":studentName  ,


  };
}