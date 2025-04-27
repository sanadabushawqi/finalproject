import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/Models/Kilometer.dart';
import '../Models/Kilometer.dart';
import '../Utils/clientConfeg.dart';
import 'NewKilometerPage.dart';
import 'NewTestPage.dart';
import 'NewVehiclePage.dart';
import 'package:http/http.dart' as http;

class kilometersPage extends StatefulWidget {
  const kilometersPage({Key? key}) : super(key: key);

  @override
  _kilometersPageState createState() => _kilometersPageState();
}

class _kilometersPageState extends State<kilometersPage> {
  Future getMykilometers() async {

    var url = "kilometers/getkilometers.php";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<Kilometer> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(Kilometer.fromJson(i));
    }

    return arr;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Added Scaffold
      body: FutureBuilder(
        future: getMykilometers(),
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
                          Kilometer kilometer = projectSnap.data[index];

                          return Card(
                              child: ListTile(
                                onTap: () {


                                },
                                title: Text(kilometer.kilometerID!  , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),), // Icon(Icons.timer),
                                subtitle: Text( kilometer.vehicleID! + " " + kilometer.startKilo! + " " + kilometer.endKilo! + " " + kilometer.date, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
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
        onPressed: ()
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (
                  context) => const newkilometerpage(), // Assuming you have this screen
            ),
          );
        },
      ),
    );
  }
}