import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Models/Test.dart';
import '../Models/Vacation.dart';
import '../Utils/clientConfeg.dart';
import 'NewTestPage.dart';
import 'NewVacationPage.dart';

class DrivingTestRegistration extends StatefulWidget {
  const DrivingTestRegistration({Key? key}) : super(key: key);

  @override
  State<DrivingTestRegistration> createState() => _DrivingTestRegistrationState();
}

class _DrivingTestRegistrationState extends State<DrivingTestRegistration> {




  Future getMytests() async {

    var url = "tests/gettests.php";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<Test> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(Test.fromJson(i));
    }

    return arr;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Added Scaffold
      body: FutureBuilder(
        future: getMytests(),
        builder: (context, projectSnap) {
          if (projectSnap.hasData) {
            if (projectSnap.data.length == 0)
            {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 2,
                child: Align(
                    alignment: Alignment.center,
                    child: Text('אין תוצאות', style: TextStyle(fontSize: 23, color: Colors.black))
                ),
              );
            }
            else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Expanded(
                      child:ListView.builder(
                        itemCount: projectSnap.data.length,
                        itemBuilder: (context, index) {
                          Test test = projectSnap.data[index];

                          return Card(
                              child: ListTile(
                                onTap: () {


                                },
                                title: Text(test.studentID!  , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),), // Icon(Icons.timer),
                                subtitle: Text( test.startTime! + " " + test.endTime!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                // trailing: Container(
                                //   decoration: const BoxDecoration(
                                //     color: Colors.blue,
                                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                                //   ),
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 12,
                                //     vertical: 4,
                                //   ),
                                //   child: Text(
                                //     project.totalHours!,   // + "שעות "
                                //     overflow: TextOverflow.ellipsis,
                                //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                //   ),
                                // ),

                                isThreeLine: false,
                              ));
                        },
                      )),
                ],
              );
            }
          }
          else if (projectSnap.hasError)
          {
            print(projectSnap.error);
            return  Center(child: Text('שגיאה, נסה שוב', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
          }
          return Center(child: new CircularProgressIndicator(color: Colors.red,));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const newtestpage(),  // Assuming you have this screen
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new vacation',
      ),
    );
  }
}
