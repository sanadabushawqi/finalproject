class Test{
  String testID;
  String studentID;
  String startTime;
  String endTime;



  Test({
    this.testID="",
    this.studentID="",
    this.startTime="",
    this.endTime="",

  });

  factory Test.fromJson(Map<String, dynamic> json)=>Test(
    testID  :json["testID"],
    studentID  :json["studentID"],
    startTime  :json["startTime"],
    endTime  :json["endTime"],

  );

  Map<String,dynamic>tojson()=>{
    "testID ":testID,
    "studentID ":studentID,
    "startTime ":startTime,
    "endTime ":endTime,

  };
}