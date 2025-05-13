import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Models/Test.dart';
import '../Utils/clientConfeg.dart';

class newtestpage extends StatefulWidget {
  const newtestpage({Key? key}) : super(key: key);

  @override
  _newtestpageState createState() => _newtestpageState();
}

class _newtestpageState extends State<newtestpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIDController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _testDateController = TextEditingController();

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    // Initialize with current date
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Format the initial time values
    _startTimeController.text = _formatTimeOfDay(_startTime);

    // Set end time to one hour later
    _endTime = TimeOfDay(
        hour: (_startTime.hour + 1) % 24,
        minute: _startTime.minute
    );
    _endTimeController.text = _formatTimeOfDay(_endTime);
  }

  // Helper method to format TimeOfDay to string
  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _testDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay initialTime = isStartTime ? _startTime : _endTime;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          _startTimeController.text = _formatTimeOfDay(picked);

          // If end time is earlier than start time, update it
          if (_timeToMinutes(_endTime) <= _timeToMinutes(_startTime)) {
            _endTime = TimeOfDay(
                hour: (_startTime.hour + 1) % 24,
                minute: _startTime.minute
            );
            _endTimeController.text = _formatTimeOfDay(_endTime);
          }
        } else {
          _endTime = picked;
          _endTimeController.text = _formatTimeOfDay(picked);
        }
      });
    }
  }

  // Helper method to convert TimeOfDay to minutes for comparison
  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Driving Test',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Test Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Student ID field
                        TextFormField(
                          controller: _studentIDController,
                          decoration: InputDecoration(
                            labelText: 'Student ID',
                            labelStyle: TextStyle(
                              color: Colors.blue.shade800,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.blue),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter student ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Test Date field with date picker
                        TextFormField(
                          controller: _testDateController,
                          decoration: InputDecoration(
                            labelText: 'Test Date',
                            labelStyle: TextStyle(
                              color: Colors.blue.shade800,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_month, color: Colors.blue),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a test date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Start Time field with time picker
                        TextFormField(
                          controller: _startTimeController,
                          decoration: InputDecoration(
                            labelText: 'Start Time',
                            labelStyle: TextStyle(
                              color: Colors.blue.shade800,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            prefixIcon: Icon(Icons.access_time, color: Colors.blue),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.schedule, color: Colors.blue),
                              onPressed: () => _selectTime(context, true),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectTime(context, true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a start time';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // End Time field with time picker
                        TextFormField(
                          controller: _endTimeController,
                          decoration: InputDecoration(
                            labelText: 'End Time',
                            labelStyle: TextStyle(
                              color: Colors.blue.shade800,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            prefixIcon: Icon(Icons.access_time, color: Colors.blue),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.schedule, color: Colors.blue),
                              onPressed: () => _selectTime(context, false),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectTime(context, false),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an end time';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var test = new Test();
                      test.studentID = _studentIDController.text;
                      test.startTime = _startTimeController.text;
                      test.endTime = _endTimeController.text;
                      // Add test date - assuming your Test model has this field
                      // If it doesn't, you can modify the URL to include it

                      var url = "tests/inserttest.php?studentID=" + test.studentID +
                          "&startTime=" + test.startTime +
                          "&endtime=" + test.endTime +
                          "&testDate=" + _testDateController.text; // Add test date

                      final response = await http.get(Uri.parse(serverPath + url));
                      print(serverPath + url);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Test added successfully'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Navigate back after success
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _studentIDController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _testDateController.dispose();
    super.dispose();
  }
}


