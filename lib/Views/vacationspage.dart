import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../Models/Vacation.dart';
import '../Utils/clientConfeg.dart';
import 'NewVacationPage.dart';

class DrivingInstructorVacationsPage extends StatefulWidget {
  const DrivingInstructorVacationsPage({Key? key}) : super(key: key);

  @override
  State<DrivingInstructorVacationsPage> createState() => _DrivingInstructorVacationsPageState();
}

class _DrivingInstructorVacationsPageState extends State<DrivingInstructorVacationsPage> {




  Future getMyvacations() async {

    var url = "vacations/getvacations.php";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<Vacation> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(Vacation.fromJson(i));
    }

    return arr;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Added Scaffold
      body: FutureBuilder(
        future: getMyvacations(),
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
                          Vacation vacation = projectSnap.data[index];

                          return Card(
                              child: ListTile(
                                onTap: () {


                                },
                                title: Text(vacation.vacationName!  , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),), // Icon(Icons.timer),
                                subtitle: Text( vacation.startDate! + " " + vacation.endDate!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
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
              builder: (context) => const NewVacationScreen(),  // Assuming you have this screen
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new vacation',
      ),
    );
  }
}
