import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Models/Vehicle.dart';
import '../Models/Vehicle.dart';
import '../Utils/clientConfeg.dart';

class newvehiclepage extends StatefulWidget {
  const newvehiclepage({Key? key}) : super(key: key);

  @override
  _newvehiclepageState createState() => _newvehiclepageState();
}

class _newvehiclepageState extends State<newvehiclepage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _vehicleIDController = TextEditingController();
  final TextEditingController _vehicleKiloController = TextEditingController();
  final TextEditingController _vehicleMaintenanceController = TextEditingController();

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
        title: const Text('New vehicle Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _vehicleNameController,
                decoration: const InputDecoration(
                  labelText: 'vehicleName	',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle name';
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
                  prefixIcon: Icon(Icons.person),
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
                controller: _vehicleKiloController,
                decoration: InputDecoration(
                  labelText: 'vehiclekilo ',
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
                controller: _vehicleMaintenanceController,
                decoration: const InputDecoration(
                  labelText: 'vehicleMaintenance ',
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
                  var vehicle = new Vehicle();
                  vehicle.vehicleName	  = _vehicleNameController.text;
                  vehicle.vehicleID  = _vehicleIDController.text;
                  vehicle.vehicleKilo  = _vehicleKiloController.text;
                  vehicle.vehicleMaintenance  = _vehicleMaintenanceController.text;

                  print("dfdgfgd");

                  var url = "vehicles/insertvehicle.php?vehicleName	 =" + vehicle.vehicleName	  + "&vehicleID =" + vehicle.vehicleID  + "&vehicleKilo =" + vehicle.vehicleKilo + "&vehicleMaintenance =" + vehicle.vehicleMaintenance ;
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
    _vehicleNameController.dispose();
    _vehicleIDController.dispose();
    _vehicleKiloController.dispose();
    _vehicleMaintenanceController.dispose();
    super.dispose();
  }
}

