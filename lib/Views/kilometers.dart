import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future deletekilometers(BuildContext context, String kilometerID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "kilometers/deletekilometers.php?kilometerID=" + kilometerID;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    setState(() { });
    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog(BuildContext context, String kilometerID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this kilometer record?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => deletekilometers(context, kilometerID),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Text('No Results', style: TextStyle(fontSize: 23, color: Colors.black))
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
                                  // Any action when tapping on the list item
                                },
                                title: Text(kilometer.kilometerID!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                subtitle: Text(kilometer.vehicleID! + " " + kilometer.startKilo! + " " + kilometer.endKilo! + " " + kilometer.date, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, kilometer.kilometerID!);
                                  },
                                ),
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
            return Center(child: Text('Error, try again', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
          }
          return Center(child: CircularProgressIndicator(color: Colors.red));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const newkilometerpage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}