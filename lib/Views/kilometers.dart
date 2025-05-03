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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => deletekilometers(context, kilometerID),
              child: Text('Delete'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kilometers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: FutureBuilder(
          future: getMykilometers(),
          builder: (context, projectSnap) {
            if (projectSnap.hasData) {
              if (projectSnap.data.length == 0)
              {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_car, size: 80, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'No kilometers found',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(12),
                        itemCount: projectSnap.data.length,
                        itemBuilder: (context, index) {
                          Kilometer kilometer = projectSnap.data[index];

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: () {
                                // Any action when tapping on the list item
                              },
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: Text(
                                "Vehicle: " + kilometer.vehicleID!,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.timeline, size: 16, color: Colors.blue),
                                      SizedBox(width: 4),
                                      Text(
                                        "Start: ${kilometer.startKilo} - End: ${kilometer.endKilo}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                      SizedBox(width: 4),
                                      Text(
                                        kilometer.date,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.directions_car, color: Colors.white),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, kilometer.kilometerID!);
                                },
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }
            else if (projectSnap.hasError)
            {
              print(projectSnap.error);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error loading data. Please try again.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const newkilometerpage(),
            ),
          ).then((value) => setState(() {}));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        tooltip: 'Add new kilometer',
      ),
    );
  }
}


