import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'NewKilometerPage.dart';

// Model for tracking kilometers
class KilometerRecord {
  final String id;
  final DateTime date;
  final String carName;
  final int startKilometers;
  final int endKilometers;
  final bool isCompleted;

  KilometerRecord({
    required this.id,
    required this.date,
    required this.carName,
    required this.startKilometers,
    this.endKilometers = 0,
    this.isCompleted = false,
  });

  // Calculate the total distance
  int get totalDistance => endKilometers - startKilometers;

  // Create a copy of this record with updated values
  KilometerRecord copyWith({
    String? id,
    DateTime? date,
    String? carName,
    int? startKilometers,
    int? endKilometers,
    bool? isCompleted,
  }) {
    return KilometerRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      carName: carName ?? this.carName,
      startKilometers: startKilometers ?? this.startKilometers,
      endKilometers: endKilometers ?? this.endKilometers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class KilometerTrackerPage extends StatefulWidget {
  @override
  _KilometerTrackerPageState createState() => _KilometerTrackerPageState();
}

class _KilometerTrackerPageState extends State<KilometerTrackerPage> {
  void _navigateToNextPage() {
    // Navigate to the next page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newkilometerpage(availableCars: [
          'Toyota Camry',
          'Honda Accord',
          'Nissan Altima',
          'Ford Focus',
          'Hyundai Elantra',
        ]), // 👈 هنا يمكنك تغيير الصفحة التي ينتقل إليها المستخدم
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driving Instructor KM Tracker'),
      ),
      body: const Center(), // صفحة فارغة
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNextPage,
        child: Icon(Icons.add),
        tooltip: 'Add New Record',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // الزر في أسفل اليمين
    );
  }
}

// 👈 يمكنك استبدال هذا الكلاس بالصفحة الجديدة التي تريد الانتقال إليها
class AddKilometerRecordDialog extends StatefulWidget {
  final List<String> availableCars;

  AddKilometerRecordDialog({required this.availableCars});

  @override
  _AddKilometerRecordDialogState createState() =>
      _AddKilometerRecordDialogState();
}

class _AddKilometerRecordDialogState extends State<AddKilometerRecordDialog> {
  DateTime selectedDate = DateTime.now();
  String? selectedCar;
  final TextEditingController startKmController = TextEditingController();
  final TextEditingController endKmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Kilometer Record'),
      ),
      body: const Center(
        child: Text('Add New Record Interface'),
      ),
    );
  }
}