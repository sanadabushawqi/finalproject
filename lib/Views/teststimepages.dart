import 'package:flutter/material.dart';
import 'NewTestPage.dart';

class DrivingTestRegistration extends StatefulWidget {
  const DrivingTestRegistration({Key? key}) : super(key: key);

  @override
  _DrivingTestRegistrationState createState() => _DrivingTestRegistrationState();
}

class _DrivingTestRegistrationState extends State<DrivingTestRegistration> {
  void _navigateToNextPage() {
    // Navigate to the next page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const newtestpage(),  // 👈 هنا يمكنك تغيير الصفحة التي ينتقل إليها المستخدم. استبدل NextPage() بالصفحة التي تريدها
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving Test Registration'),
      ),
      body: const Center(),  // Empty body
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNextPage,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,  // Position at bottom right
    );
  }
}

// 👈 يمكنك استبدال هذا الكلاس بالكامل بالصفحة الجديدة التي تريد الانتقال إليها
class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Page'),
      ),
      body: const Center(
        child: Text('This is the next page'),
      ),
    );
  }
}