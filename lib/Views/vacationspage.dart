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

  Future deletevacations(BuildContext context, String vacationID) async {
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
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد من حذف هذه الإجازة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => deletevacations(context, vacationID),
              child: Text('حذف'),
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
                      child: ListView.builder(
                        itemCount: projectSnap.data.length,
                        itemBuilder: (context, index) {
                          Vacation vacation = projectSnap.data[index];

                          return Card(
                              child: ListTile(
                                onTap: () {
                                  // أي إجراء عند النقر على عنصر القائمة
                                },
                                title: Text(vacation.vacationName!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                subtitle: Text(vacation.startDate! + " " + vacation.endDate!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, vacation.vacationID!);
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
            return Center(child: Text('שגיאה, נסה שוב', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
          }
          return Center(child: CircularProgressIndicator(color: Colors.red));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewVacationScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new vacation',
      ),
    );
  }
}