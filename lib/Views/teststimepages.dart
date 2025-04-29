import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  Future deletetests(BuildContext context, String testID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "tests/deletetests.php?testID=" + testID;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    setState(() { });
    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog(BuildContext context, String testID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this test record?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => deletetests(context, testID),
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
        future: getMytests(),
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
                          Test test = projectSnap.data[index];

                          return Card(
                              child: ListTile(
                                onTap: () {
                                  // Any action when tapping on the list item
                                },
                                title: Text(test.studentID!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                subtitle: Text(test.startTime! + " " + test.endTime!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, test.testID!);
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
              builder: (context) => const newtestpage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new test',
      ),
    );
  }
}