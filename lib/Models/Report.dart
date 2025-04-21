class Report{
  String studentName ;
  String studentID ;
  String lessonDuration;
  String lessonLerning;
  String notes;
  String evaluation;
  String date;


  Report({
    this.studentName ="",
    this.studentID ="",
    this.lessonDuration="",
    this.lessonLerning="",
    this.notes="",
    this.evaluation="",
    this.date="",

  });

  factory Report.fromJson(Map<String, dynamic> json)=>Report(
    studentName :json["studentName "],
    studentID :json["studentID "],
    lessonDuration:json[" lessonDuration"],
    lessonLerning:json["lessonLerning"],
    notes:json["notes"],
    evaluation:json["evaluation"],
    date:json["date"],

  );

  Map<String,dynamic>tojson()=>{
    "studentName ":studentName ,
    "studentID ":studentID ,
    "lessonDuration":lessonDuration,
    "lessonLerning":lessonLerning,
    "notes":notes,
    "evaluation":evaluation,
    "date":date,

  };
}