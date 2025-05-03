import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../Models/Vacation.dart';
import '../Utils/clientConfeg.dart';

class NewVacationScreen extends StatefulWidget {
  const NewVacationScreen({Key? key}) : super(key: key);

  @override
  _NewVacationScreenState createState() => _NewVacationScreenState();
}

class _NewVacationScreenState extends State<NewVacationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vacationNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    // Parse the start date if it exists to ensure end date is after start date
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);

    if (_startDateController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(_startDateController.text);
        firstDate = initialDate; // End date must be on or after start date
      } catch (e) {
        // Use default values if parsing fails
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        var vacation = Vacation();
        vacation.vacationName = _vacationNameController.text;
        vacation.startDate = _startDateController.text;
        vacation.endDate = _endDateController.text;

        // Fix URL encoding issues
        var url = "vacations/insertvacation.php?vacationName=" +
            Uri.encodeComponent(vacation.vacationName!) +
            "&startDate=" + Uri.encodeComponent(vacation.startDate!) +
            "&endDate=" + Uri.encodeComponent(vacation.endDate!);

        final response = await http.get(Uri.parse(serverPath + url));
        print(serverPath + url);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vacation added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add vacation'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Vacation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vacation Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _vacationNameController,
                        decoration: InputDecoration(
                          labelText: 'Vacation Name',
                          hintText: 'Enter vacation name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          prefixIcon: Icon(Icons.event_note, color: Colors.blue),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter vacation name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          hintText: 'Select start date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.date_range, color: Colors.blue),
                            onPressed: () => _selectStartDate(context),
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectStartDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a start date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          hintText: 'Select end date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.date_range, color: Colors.blue),
                            onPressed: () => _selectEndDate(context),
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectEndDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an end date';
                          }

                          // Validate that end date is after start date
                          if (_startDateController.text.isNotEmpty) {
                            try {
                              DateTime startDate = DateFormat('yyyy-MM-dd').parse(_startDateController.text);
                              DateTime endDate = DateFormat('yyyy-MM-dd').parse(value);

                              if (endDate.isBefore(startDate)) {
                                return 'End date must be after start date';
                              }
                            } catch (e) {
                              return 'Invalid date format';
                            }
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Vacation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    _vacationNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}