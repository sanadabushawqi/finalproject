class Test{
  String studentName ;
  String studentID  ;
  String startTime  ;
  String endTime  ;



  Test({
    this.studentName  ="",
    this.studentID  ="",
    this.startTime  ="",
    this.endTime  ="",

  });

  factory Test.fromJson(Map<String, dynamic> json)=>Test(
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