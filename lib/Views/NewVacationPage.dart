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
  final TextEditingController _vacationLengthController = TextEditingController();

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
        title: const Text('New vaacation Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _vacationNameController,
                decoration: const InputDecoration(
                  labelText: 'vacationName',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
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
                decoration: const InputDecoration(
                  labelText: 'startDate ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter startDate ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: 'endDate ',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please select endDate ';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vacationLengthController,
                decoration: const InputDecoration(
                  labelText: 'vacationLength ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vacationLength ';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  var vacation = new Vacation();
                  vacation.vacationName  = _vacationNameController.text;
                  vacation.startDate  = _startDateController.text;
                  vacation.endDate  = _endDateController.text;
                  vacation.vacationLength  = _vacationLengthController.text;

                  print("dfdgfgd");

                  var url = "vacations/insertvacation.php?vacationName =" + vacation.vacationName  + "&startDate =" + vacation.startDate  + "&endDate =" + vacation.endDate + "&vacationLength =" + vacation.vacationLength ;
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
    _vacationNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _vacationLengthController.dispose();
    super.dispose();
  }
}

