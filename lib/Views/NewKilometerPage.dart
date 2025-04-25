import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Models/Kilometer.dart';
import 'package:untitled/Models/Vehicle.dart';
import '../Models/Vehicle.dart';
import '../Utils/clientConfeg.dart';

class newkilometerpage extends StatefulWidget {
  const newkilometerpage({Key? key, required List<String> availableCars}) : super(key: key);

  @override
  _newkilometerpageState createState() => _newkilometerpageState();
}

class _newkilometerpageState extends State<newkilometerpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _vehicleIDController = TextEditingController();
  final TextEditingController _startKiloController = TextEditingController();
  final TextEditingController _endKiloController = TextEditingController();

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
        title: const Text('New kilometer Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'date	',
                  border: OutlineInputBorder(),
                  // prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehicleIDController,
                decoration: const InputDecoration(
                  labelText: 'vehicleID ',
                  border: OutlineInputBorder(),
                  // prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle ID ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              TextFormField(
                controller: _startKiloController,
                decoration: InputDecoration(
                  labelText: 'startKilo ',
                  border: const OutlineInputBorder(),
                  // prefixIcon: const Icon(Icons.calendar_today),
                  // suffixIcon: IconButton(
                    // icon: const Icon(Icons.calendar_month),
                    // onPressed: () => _selectDate(context),
                  ),
                ),
                // readOnly: true,
                // onTap: () => _selectDate(context),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please select endDate ';
                //   }
                //   return null;
                // },
              // ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endKiloController,
                decoration: const InputDecoration(
                  labelText: 'endKilo ',
                  // border: OutlineInputBorder(),
                  // prefixIcon: Icon(Icons.phone),
                ),
                // keyboardType: TextInputType.phone,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter vehicleMaintenance ';
                //   }
                //   return null;
                // },
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  var kilometer = new Kilometer();
                  kilometer.date	  = _dateController.text;
                  kilometer.vehicleID  = _vehicleIDController.text;
                  kilometer.startKilo  = _startKiloController.text;
                  kilometer.endKilo  = _endKiloController.text;

                  print("dfdgfgd");

                  var url = "kilometers/insertkilometer.php?date	 =" + kilometer.date	  + "&vehicleID =" + kilometer.vehicleID  + "&startKilo =" + kilometer.startKilo + "&endKilo =" + kilometer.endKilo ;
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
    _dateController.dispose();
    _vehicleIDController.dispose();
    _startKiloController.dispose();
    _endKiloController.dispose();
    super.dispose();
  }
}

