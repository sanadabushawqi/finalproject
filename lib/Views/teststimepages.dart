import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrivingTestRegistration extends StatefulWidget {
  const DrivingTestRegistration({Key? key}) : super(key: key);

  @override
  _DrivingTestRegistrationState createState() => _DrivingTestRegistrationState();
}

class _DrivingTestRegistrationState extends State<DrivingTestRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  DateTime? _selectedDateTime;

  void _saveTestRegistration() {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      // Here you would typically save the data to your database
      print('Test Registration Saved:');
      print('Student Name: ${_nameController.text}');
      print('Student ID: ${_idController.text}');
      print('Test Date and Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)}');

      // Clear the form
      _nameController.clear();
      _idController.clear();
      setState(() {
        _selectedDateTime = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test registration saved successfully!')),
      );
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving Test Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
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
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectDateTime,
                child: Text(
                  _selectedDateTime == null
                      ? 'Select Test Date and Time'
                      : 'Test Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)}',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTestRegistration,
                child: const Text('Save Test Registration'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }
}