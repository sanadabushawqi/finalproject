import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Models/Report.dart';
import '../Models/Report.dart';
import '../Utils/clientConfeg.dart';


class Newreportpage extends StatefulWidget {
  const Newreportpage({Key? key, required String instructorId}) : super(key: key);

  @override
  _NewreportpageState createState() => _NewreportpageState();
}

class _NewreportpageState extends State<Newreportpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentIDController = TextEditingController();
  final TextEditingController _lessonDurationController = TextEditingController();
  final TextEditingController _lessonLerningController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _evaluationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

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
        title: const Text('New report Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _studentNameController,
                decoration: const InputDecoration(
                  labelText: 'studentName',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student name';
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
                controller: _lessonDurationController,
                decoration: InputDecoration(
                  labelText: 'lessonDuration',
                  border: const OutlineInputBorder(),
                  // prefixIcon: const Icon(Icons.calendar_today),
                  // suffixIcon: IconButton(
                  //   // icon: const Icon(Icons.calendar_month),
                  //   onPressed: () => _selectDate(context),
                  // ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter lesson duration';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lessonLerningController,
                decoration: const InputDecoration(
                  labelText: 'lessonlerning',
                  border: OutlineInputBorder(),
                  // prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lesson lerning';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'notes',
                  border: OutlineInputBorder(),
                  // prefixIcon: Icon(Icons.phone),
                ),
                // keyboardType: TextInputType.phone,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter lesson lerning';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _evaluationController,
                decoration: const InputDecoration(
                  labelText: 'evaluation',
                  border: OutlineInputBorder(),
                  // prefixIcon: Icon(Icons.phone),
                ),
                // keyboardType: TextInputType.phone,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter lesson lerning';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'date',
                  border: OutlineInputBorder(),
                  // prefixIcon: Icon(Icons.email),
                ),
                // keyboardType: TextInputType.emailAddress,
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
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  var report = new Report();
                  report.studentName = _studentNameController.text;
                  report.studentID = _studentIDController.text;
                  report.lessonDuration = _lessonDurationController.text;
                  report.lessonLerning = _lessonLerningController.text;
                  report.notes = _notesController.text;
                  report.evaluation = _evaluationController.text;
                  report.date = _dateController.text;

                  print("dfdgfgd");

                  var url = "reports/insertreport.php?studentName=" + report.studentName + "&studentID=" + report.studentID + "&lessonDuration=" + report.lessonDuration+ "&lessonLerning=" + report.lessonLerning + "&notes=" + report.notes+ "&evaluation=" + report.evaluation+ "&date=" + report.date;
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
    _studentNameController.dispose();
    _studentIDController.dispose();
    _lessonDurationController.dispose();
    _lessonLerningController.dispose();
    _notesController.dispose();
    _evaluationController.dispose();
    _dateController.dispose();

    super.dispose();
  }
}

