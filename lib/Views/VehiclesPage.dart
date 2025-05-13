import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Vehicle.dart';
import '../Utils/clientConfeg.dart';
import 'NewVehiclePage.dart';
import 'package:http/http.dart' as http;

class DrivingInstructorVehiclesPage extends StatefulWidget {
  const DrivingInstructorVehiclesPage({Key? key}) : super(key: key);

  @override
  _DrivingInstructorVehiclesPageState createState() => _DrivingInstructorVehiclesPageState();
}

class _DrivingInstructorVehiclesPageState extends State<DrivingInstructorVehiclesPage> {
  Future getMyvehicles() async {
    var url = "vehicles/getvehicles.php";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<Vehicle> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(Vehicle.fromJson(i));
    }

    return arr;
  }

  Future deletevehicles(BuildContext context, String vehicleID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "vehicles/deletevehicles.php?vehicleID=" + vehicleID;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    setState(() { });
    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog(BuildContext context, String vehicleID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this vehicle?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => deletevehicles(context, vehicleID),
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
          'Vehicles',
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
          future: getMyvehicles(),
          builder: (context, projectSnap) {
            if (projectSnap.hasData) {
              if (projectSnap.data.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_car, size: 80, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'No vehicles found',
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
                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: projectSnap.data.length,
                  itemBuilder: (context, index) {
                    Vehicle vehicle = projectSnap.data[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          // Any action when tapping on a vehicle
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        title: Text(
                          vehicle.vehicleName!,
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
                                Icon(Icons.speed, size: 16, color: Colors.blue),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    "Kilometers: ${vehicle.vehicleKilo}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.build, size: 16, color: Colors.blue),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    "Maintenance: ${vehicle.vehicleMaintenance}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Icon(Icons.directions_car, color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, vehicle.vehicleID!);
                          },
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
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
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const newvehiclepage(),
            ),
          ).then((value) => setState(() {}));  // Refresh the list when returning
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        tooltip: 'Add new vehicle',
      ),
    );
  }
}


