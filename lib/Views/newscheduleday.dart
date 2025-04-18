import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrivingScheduleScreen extends StatefulWidget {
  const DrivingScheduleScreen({Key? key}) : super(key: key);

  @override
  _DrivingScheduleScreenState createState() => _DrivingScheduleScreenState();
}

class _DrivingScheduleScreenState extends State<DrivingScheduleScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();

  // Updated schedule data structure to include end time
  List<Map<String, dynamic>> scheduleData = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  void _addScheduleEntry() {
    if (_studentNameController.text.isNotEmpty &&
        _studentIdController.text.isNotEmpty) {
      setState(() {
        scheduleData.add({
          'studentName': _studentNameController.text,
          'studentId': _studentIdController.text,
          'date': selectedDate,
          'startTime': startTime,
          'endTime': endTime,
        });
      });
      _clearInputs();
    }
  }

  void _clearInputs() {
    _studentNameController.clear();
    _studentIdController.clear();
  }

  void _editScheduleEntry(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Schedule'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(
                    text: scheduleData[index]['studentName']),
                decoration: const InputDecoration(labelText: 'Student Name'),
                onChanged: (value) {
                  scheduleData[index]['studentName'] = value;
                },
              ),
              TextField(
                controller: TextEditingController(
                    text: scheduleData[index]['studentId']),
                decoration: const InputDecoration(labelText: 'Student ID'),
                onChanged: (value) {
                  scheduleData[index]['studentId'] = value;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final newTime = await showTimePicker(
                        context: context,
                        initialTime: scheduleData[index]['startTime'],
                      );
                      if (newTime != null) {
                        setState(() {
                          scheduleData[index]['startTime'] = newTime;
                        });
                      }
                    },
                    child: const Text('Start Time'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newTime = await showTimePicker(
                        context: context,
                        initialTime: scheduleData[index]['endTime'],
                      );
                      if (newTime != null) {
                        setState(() {
                          scheduleData[index]['endTime'] = newTime;
                        });
                      }
                    },
                    child: const Text('End Time'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving Lesson Schedule'),
      ),
      body: Column(
        children: [
          // Date Display and Selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ),

          // Input Form
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _studentNameController,
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    labelText: 'Student ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _selectStartTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text('Start Time: ${startTime.format(context)}'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _selectEndTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text('End Time: ${endTime.format(context)}'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addScheduleEntry,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Add to Schedule'),
                ),
              ],
            ),
          ),

          // Schedule List
          Expanded(
            child: ListView.builder(
              itemCount: scheduleData.length,
              itemBuilder: (context, index) {
                final schedule = scheduleData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(schedule['studentName']),
                    subtitle: Text(
                      'ID: ${schedule['studentId']}\n'
                          'Time: ${schedule['startTime'].format(context)} - ${schedule['endTime'].format(context)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editScheduleEntry(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }
}