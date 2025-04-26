import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/Models/Student.dart';
import '../Models/Schedule.dart';
import '../Utils/clientConfeg.dart';
import 'NewStudentScreen.dart';
import 'drivingteacherprofile.dart';
import 'newschedulelesson.dart';
import 'teststimepages.dart';
import 'viewreportspage.dart';
import 'vehiclespage.dart';
import 'settingspage.dart';
import 'vacationspage.dart';
import 'kilometers.dart';
import 'package:http/http.dart' as http;



class teacherHomeScreen extends StatefulWidget {
  const teacherHomeScreen({super.key});

  @override
  State<teacherHomeScreen> createState() => _teacherHomeScreen();
}

class _teacherHomeScreen extends State<teacherHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const StudentsScreen(),
    const ScheduleScreen(),
    DrivingTeacherProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving Instructor Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [

              FloatingActionButton(
              onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => DrivingInstructorVacationsPage( )))},
                child: _buildActionCard(

                context,
                'vacations',
                Icons.beach_access,

                    () {
                  // TODO: Implement vacations
                },
              ),
              ),
              FloatingActionButton(
                onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => DrivingInstructorReportsPage(instructorId: '',)))},
                child: _buildActionCard(
                  context,
                  'View Reports',
                  Icons.bar_chart,
                      () {
                    // TODO: Implement reports
                  },
                ),
              ),
              FloatingActionButton(
                onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => KilometerTrackerPage()))},
                child:
              _buildActionCard(
                context,
                'kilometers',
                Icons.add_circle,
                    () {
                  // TODO: Implement schedule lesson
                },
              ),),
              FloatingActionButton(
                onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => DrivingInstructorSettingsPage(instructorId: '',)))},
                child:
              _buildActionCard(
                context,
                'Settings',
                Icons.settings,
                    () {
                  // TODO: Implement settings
                },
              ),),
                 FloatingActionButton(
                 onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => DrivingTestRegistration()))},
                  child: _buildActionCard(

                context,
                'tests',
                Icons.fact_check,
                    () {
                  // TODO: Implement tests
                },
              ),
    ),
              FloatingActionButton(
                onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => DrivingInstructorVehiclesPage(instructorId: '',)))},
                child:
              _buildActionCard(
                context,
                'vehicles',
                Icons.directions_car,
                    () {
                  // TODO: Implement vehicles
                },
              ),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});




  Future getMyStudents() async {

    var url = "students/getstudents.php";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<Student> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(Student.fromJson(i));
    }

    return arr;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Added Scaffold
        body: FutureBuilder(
          future: getMyStudents(),
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
                            Student student = projectSnap.data[index];

                            return Card(
                                child: ListTile(
                                  onTap: () {


                                  },
                                  title: Text(student.firstName! + " " + student.lastName! , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),), // Icon(Icons.timer),
                                  // subtitle: Text("[" + project.ariveHour! + "-" + project.exitHour! + "]" + "\n" + project.comments!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
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

    // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewStudentScreen(),  // Assuming you have this screen
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new student',
      ),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  Future getMyschedules() async {

    var url = "schedules/getschedules.php";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<Schedule> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(Schedule.fromJson(i));
    }

    return arr;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Added Scaffold
      body: FutureBuilder(
        future: getMyschedules(),
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
                          Schedule schedule = projectSnap.data[index];

                          return Card(
                              child: ListTile(
                                onTap: () {


                                },
                                title: Text(schedule.studentID! + " " + schedule.studentName! + " " + schedule.teacherID+ " " + schedule.startTime!+ " " + schedule.endTime! , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),), // Icon(Icons.timer),
                                // subtitle: Text("[" + project.ariveHour! + "-" + project.exitHour! + "]" + "\n" + project.comments!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
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
              builder: (context) => const newschedulelesson(),  // Assuming you have this screen
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new schedule',
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen - Coming Soon'),
    );
  }
}