import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        backgroundColor: Color(0xFF3F51B5), // لون أزرق داكن منعش
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
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
        backgroundColor: Color(0xFF3F51B5),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
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
    // تعريف ألوان مختلفة لكل بطاقة لإضافة تنوع وانتعاش
    final List<Map<String, dynamic>> cardStyles = [
      {
        'gradient': [Color(0xFF4CAF50), Color(0xFF8BC34A)], // أخضر منعش
        'icon': Icons.beach_access,
        'title': 'vacations',
        'route': DrivingInstructorVacationsPage(),
      },
      {
        'gradient': [Color(0xFF2196F3), Color(0xFF03A9F4)], // أزرق منعش
        'icon': Icons.add_circle,
        'title': 'kilometers',
        'route': kilometersPage(),
      },
      {
        'gradient': [Color(0xFFFF9800), Color(0xFFFFB74D)], // برتقالي منعش
        'icon': Icons.fact_check,
        'title': 'tests',
        'route': DrivingTestRegistration(),
      },
      {
        'gradient': [Color(0xFF9C27B0), Color(0xFFBA68C8)], // بنفسجي منعش
        'icon': Icons.directions_car,
        'title': 'vehicles',
        'route': DrivingInstructorVehiclesPage(),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF5F5F5)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F51B5),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9, // جعل البطاقات أطول قليلاً
              ),
              itemCount: cardStyles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => cardStyles[index]['route'])
                  ),
                  child: _buildActionCard(
                    context,
                    cardStyles[index]['title'],
                    cardStyles[index]['icon'],
                    cardStyles[index]['gradient'],
                        () {}, // هذه الدالة لن تستخدم
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      String title,
      IconData icon,
      List<Color> gradientColors,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 8, // ظل أكثر بروزاً
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // زوايا أكثر انحناءً
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {

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

  Future deletestudents(BuildContext context, String studentID ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "students/deletestudents.php?studentID=" + studentID ;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    setState(() {

    });
    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog(BuildContext context, String studentID ) {
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
              onPressed: () => deletestudents(context, studentID ),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: FutureBuilder(
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
                          padding: EdgeInsets.all(12),
                          itemCount: projectSnap.data.length,
                          itemBuilder: (context, index) {
                            Student student = projectSnap.data[index];

                            return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  onTap: () {},
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  title: Text(
                                    student.firstName! + " " + student.lastName!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3F51B5)
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xFF3F51B5),
                                    child: Text(
                                      student.firstName!.substring(0, 1).toUpperCase(),
                                      style: TextStyle(color: Colors.white),

                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, student.studentID !);
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
            return Center(child: CircularProgressIndicator(color: Color(0xFF3F51B5)));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewStudentScreen(),
            ),
          );
        },
        backgroundColor: Color(0xFF3F51B5),
        child: const Icon(Icons.add),
        tooltip: 'Add new student',
      ),
    );
  }
}
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {


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

  Future deleteschedules(BuildContext context, String scheduleID  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "shedules/deleteschedules.php?scheduleID =" + scheduleID  ;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    setState(() {

    });
    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog(BuildContext context, String scheduleID  ) {
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
              onPressed: () => deleteschedules(context, scheduleID  ),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: FutureBuilder(
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
                          padding: EdgeInsets.all(12),
                          itemCount: projectSnap.data.length,
                          itemBuilder: (context, index) {
                            Schedule schedule = projectSnap.data[index];

                            return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  onTap: () {},
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  title: Text(
                                    schedule.studentID! + " " + schedule.studentName! + " " + schedule.teacherID+ " " + schedule.startTime!+ " " + schedule.endTime!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3F51B5)
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xFF3F51B5),
                                    child: Icon(Icons.schedule, color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, schedule.scheduleID!);
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
            return Center(child: CircularProgressIndicator(color: Color(0xFF3F51B5)));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const newschedulelesson(),
            ),
          );
        },
        backgroundColor: Color(0xFF3F51B5),
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF5F5F5)],
        ),
      ),
      child: const Center(
        child: Text(
          'Profile Screen - Coming Soon',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3F51B5),
          ),
        ),
      ),
    );
  }
}