import 'package:flutter/material.dart';
import 'NewStudentScreen.dart';
import 'newscheduleday.dart';
import 'drivingteacherprofile.dart';
import 'teststimepages.dart';
import 'viewreportspage.dart';
import 'vehiclespage.dart';
import 'settingspage.dart';
import 'vacationspage.dart';
import 'kilometers.dart';

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
              onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => DrivingInstructorVacationsPage(instructorId: '',)))},
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
                onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => DrivingInstructorReportsPage(instructorId: '',)))},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Added Scaffold
      body: ListView.builder(
        itemCount: 10, // Replace with actual student data
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text('Student ${index + 1}'),
            subtitle: const Text('Last lesson: 01/02/2025'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // TODO: Implement student options menu
              },
            ),
          );
        },
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Schedule Screen - Coming Soon'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DrivingScheduleScreen(),  // Assuming you have this screen
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new student',
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