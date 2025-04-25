import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../Models/Schedule.dart';
import '../Utils/clientConfeg.dart';

class newschedulelesson extends StatefulWidget {
  const newschedulelesson({Key? key}) : super(key: key);

  @override
  _newschedulelessonState createState() => _newschedulelessonState();
}

class _newschedulelessonState extends State<newschedulelesson> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teacherIDController = TextEditingController();
  final TextEditingController _studentIDController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    // if (picked != null) {
    //   setState(() {
    //     _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New schedule lesson'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _teacherIDController,
                decoration: const InputDecoration(
                  labelText: 'teacherID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter teacherID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _studentIDController,
                decoration: const InputDecoration(
                  labelText: 'studentID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(
                  labelText: 'startTime',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                // readOnly: true,
                // onTap: () => _selectDate(context),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please select start time';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endTimeController,
                decoration: const InputDecoration(
                  labelText: 'endtime',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter end time';
                  }
                  return null;
                },
              ),

                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter email';
                //   }
                //   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                //       .hasMatch(value)) {
                //     return 'Please enter a valid email';
                //   }
                //   return null;
                // },

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  var schedule = new Schedule();
                  schedule.teacherID = _teacherIDController.text;
                  schedule.studentID = _studentIDController.text;
                  schedule.startTime = _startTimeController.text;
                  schedule.endTime = _endTimeController.text;

                  print("dfdgfgd");

                  var url = "schedules/insertschedule.php?teacherID=" + schedule.teacherID + "&studentID=" + schedule.studentID + "&startTime=" + schedule.startTime+ "&endtime=" + schedule.endTime;
                  final response = await http.get(Uri.parse(serverPath + url));
                  print(serverPath + url);
                  if (_formKey.currentState!.validate()) {
                    // TODO: Handle form submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _teacherIDController.dispose();
    _studentIDController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }
}

