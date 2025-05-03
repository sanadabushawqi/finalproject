import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  Future deleteVacation(BuildContext context, String vacationID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "vacations/deletevacations.php?vacationID=" + vacationID;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    setState(() { });
    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog(BuildContext context, String vacationID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this vacation?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => deleteVacation(context, vacationID),
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
        title: Text('Instructor Vacations',
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
      body: FutureBuilder(
        future: getMyvacations(),
        builder: (context, projectSnap) {
          if (projectSnap.hasData) {
            var vacations = projectSnap.data as List;
            if (vacations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      'No vacations found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: vacations.length,
                  itemBuilder: (context, index) {
                    Vacation vacation = vacations[index];

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onTap: () {
                          // Action when tapping on a vacation item
                        },
                        title: Text(
                          vacation.vacationName!,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.date_range, size: 16, color: Colors.blue),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${vacation.startDate!} - ${vacation.endDate!}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, vacation.vacationID!);
                          },
                        ),
                        isThreeLine: false,
                      ),
                    );
                  },
                ),
              );
            }
          } else if (projectSnap.hasError) {
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
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewVacationScreen(),
            ),
          ).then((value) => setState(() {})); // Refresh the list when returning
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new vacation',
        backgroundColor: Colors.blue,
      ),
    );
  }
}