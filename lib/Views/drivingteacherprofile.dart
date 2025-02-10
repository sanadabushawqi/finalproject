import 'package:flutter/material.dart';

class DrivingTeacherProfile extends StatelessWidget {
  // Mock data - in real app would come from backend
  final Map<String, dynamic> teacherData = {
    'name': 'John Doe',
    'id': 'DT123456',
    'experience': '8 years',
    'rating': 4.8,
    'totalStudents': 245,
    'specializations': ['Manual', 'Automatic', 'Heavy Vehicles'],
    'activeStudents': 12,
    'completedTests': 89,
    'upcomingTests': 5,
  };

  DrivingTeacherProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
              print('Navigate to settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    teacherData['name'],
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'ID: ${teacherData['id']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Text(' ${teacherData['rating']} / 5.0'),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.calendar_today,
                          label: 'Schedule\nTests',
                          onPressed: () {
                            // Navigate to test scheduling
                            print('Navigate to test scheduling');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.people,
                          label: 'View\nStudents',
                          onPressed: () {
                            // Navigate to students list
                            print('Navigate to students list');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.assignment,
                          label: 'Test\nResults',
                          onPressed: () {
                            // Navigate to test results
                            print('Navigate to test results');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Statistics
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Statistics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _StatisticCard(
                    title: 'Active Students',
                    value: teacherData['activeStudents'].toString(),
                    icon: Icons.school,
                  ),
                  const SizedBox(height: 8),
                  _StatisticCard(
                    title: 'Completed Tests',
                    value: teacherData['completedTests'].toString(),
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(height: 8),
                  _StatisticCard(
                    title: 'Upcoming Tests',
                    value: teacherData['upcomingTests'].toString(),
                    icon: Icons.upcoming,
                  ),
                ],
              ),
            ),

            // Additional Actions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Additional Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Teaching History'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to teaching history
                      print('Navigate to teaching history');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_rate),
                    title: const Text('Reviews & Ratings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to reviews
                      print('Navigate to reviews');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('Reports'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to reports
                      print('Navigate to reports');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('Availability Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to availability settings
                      print('Navigate to availability settings');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quick Action Button Widget
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Statistic Card Widget
class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(value, style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}