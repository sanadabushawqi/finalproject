import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driving Instructor KM Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: KilometerTrackerPage(),
    );
  }
}

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
  // List of available cars (can be fetched from a database in the future)
  final List<String> availableCars = [
    'Toyota Camry',
    'Honda Accord',
    'Nissan Altima',
    'Ford Focus',
    'Hyundai Elantra',
  ];

  // List of kilometer records (this would be stored in a database in the future)
  List<KilometerRecord> kmRecords = [];

  // Controller for the filter functionality
  TextEditingController searchController = TextEditingController();
  DateTime? selectedFilterDate;
  List<KilometerRecord> filteredRecords = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered records with all records
    filteredRecords = kmRecords;
  }

  // Filter records based on search text and selected date
  void filterRecords() {
    setState(() {
      filteredRecords = kmRecords.where((record) {
        bool matchesSearch = searchController.text.isEmpty ||
            record.carName.toLowerCase().contains(searchController.text.toLowerCase());

        bool matchesDate = selectedFilterDate == null ||
            (record.date.year == selectedFilterDate!.year &&
                record.date.month == selectedFilterDate!.month &&
                record.date.day == selectedFilterDate!.day);

        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  // Reset all filters
  void resetFilters() {
    setState(() {
      searchController.clear();
      selectedFilterDate = null;
      filteredRecords = kmRecords;
    });
  }

  // Add a new kilometer record
  void addNewRecord() async {
    // Show dialog to collect information
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AddKilometerRecordDialog(
          availableCars: availableCars,
        );
      },
    );

    // If dialog is cancelled or closed, result will be null
    if (result != null) {
      setState(() {
        // Create a new record with the information from the dialog
        final newRecord = KilometerRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: result['date'],
          carName: result['carName'],
          startKilometers: result['startKm'],
          endKilometers: result['endKm'] ?? 0,
          isCompleted: result['endKm'] != null && result['endKm'] > 0,
        );

        // Add to records list
        kmRecords.add(newRecord);

        // Update filtered records
        filterRecords();
      });
    }
  }

  // Update an existing record with end kilometers
  void updateRecordEndKm(KilometerRecord record) async {
    final TextEditingController endKmController = TextEditingController();

    // Show dialog to enter end kilometers
    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter End Kilometers'),
          content: TextField(
            controller: endKmController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'End Kilometers',
              hintText: 'Enter end kilometers',
              suffixText: 'km',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                // Parse the entered value
                final endKm = int.tryParse(endKmController.text);
                if (endKm != null && endKm > 0) {
                  Navigator.of(context).pop(endKm);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid number')),
                  );
                }
              },
              child: Text('SAVE'),
            ),
          ],
        );
      },
    );

    // If dialog is cancelled or closed, result will be null
    if (result != null) {
      setState(() {
        // Find the index of the record in the list
        final index = kmRecords.indexWhere((r) => r.id == record.id);
        if (index != -1) {
          // Update the record with end kilometers
          kmRecords[index] = record.copyWith(
            endKilometers: result,
            isCompleted: true,
          );

          // Update filtered records
          filterRecords();
        }
      });
    }
  }

  // Delete a record
  void deleteRecord(KilometerRecord record) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Record'),
          content: Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('CANCEL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        // Remove the record from the list
        kmRecords.removeWhere((r) => r.id == record.id);

        // Update filtered records
        filterRecords();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driving Instructor KM Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              // Show filter options
              showModalBottomSheet(
                context: context,
                builder: (context) => buildFilterOptions(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by car name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: searchController.text.isNotEmpty || selectedFilterDate != null
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: resetFilters,
                )
                    : null,
              ),
              onChanged: (value) => filterRecords(),
            ),
          ),

          // Filter indicator
          if (selectedFilterDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Filtered by date: ${DateFormat('yyyy-MM-dd').format(selectedFilterDate!)}',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 16),
                    onPressed: () {
                      setState(() {
                        selectedFilterDate = null;
                        filterRecords();
                      });
                    },
                  ),
                ],
              ),
            ),

          // Records list
          Expanded(
            child: filteredRecords.isEmpty
                ? Center(
              child: Text(
                'No records found.\nTap the + button to add a new record.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.builder(
              itemCount: filteredRecords.length,
              itemBuilder: (context, index) {
                final record = filteredRecords[index];
                return buildRecordCard(record);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewRecord,
        child: Icon(Icons.add),
        tooltip: 'Add New Record',
      ),
    );
  }

  Widget buildFilterOptions() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Records',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Filter by Date'),
            subtitle: selectedFilterDate != null
                ? Text(DateFormat('yyyy-MM-dd').format(selectedFilterDate!))
                : Text('No date selected'),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedFilterDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );

              if (date != null) {
                setState(() {
                  selectedFilterDate = date;
                  filterRecords();
                });
              }

              Navigator.pop(context); // Close the bottom sheet
            },
          ),
          SizedBox(height: 8),
          if (selectedFilterDate != null || searchController.text.isNotEmpty)
            ListTile(
              leading: Icon(Icons.clear_all),
              title: Text('Clear All Filters'),
              onTap: () {
                resetFilters();
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
        ],
      ),
    );
  }

  Widget buildRecordCard(KilometerRecord record) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(record.date);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: record.isCompleted ? Colors.green : Colors.grey.shade300,
          width: record.isCompleted ? 2 : 1,
        ),
      ),
      child: InkWell(
        onLongPress: () => deleteRecord(record),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_car, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    record.carName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Kilometers',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${record.startKilometers} km',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Kilometers',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        record.isCompleted
                            ? Text(
                          '${record.endKilometers} km',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : TextButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Add End KM'),
                          onPressed: () => updateRecordEndKm(record),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (record.isCompleted) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: record.totalDistance >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: record.totalDistance >= 0 ? Colors.green.shade200 : Colors.red.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        record.totalDistance >= 0 ? Icons.check_circle : Icons.error,
                        color: record.totalDistance >= 0 ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text(
                        record.totalDistance >= 0
                            ? 'Distance traveled: ${record.totalDistance} km'
                            : 'Error: End KM less than Start KM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: record.totalDistance >= 0
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Dialog for adding a new kilometer record
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Kilometer Record',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Date selector
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );

                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                    Spacer(),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Car selector
            DropdownButtonFormField<String>(
              value: selectedCar,
              decoration: InputDecoration(
                labelText: 'Select Car',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.directions_car),
              ),
              items: widget.availableCars.map((car) {
                return DropdownMenuItem(
                  value: car,
                  child: Text(car),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCar = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Start kilometers
            TextField(
              controller: startKmController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Start Kilometers',
                hintText: 'Enter starting kilometers',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.speed),
                suffixText: 'km',
              ),
            ),
            SizedBox(height: 16),
            // End kilometers (optional)
            TextField(
              controller: endKmController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'End Kilometers (Optional)',
                hintText: 'Enter ending kilometers',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.flag),
                suffixText: 'km',
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('CANCEL'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Validate input
                    if (selectedCar == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a car')),
                      );
                      return;
                    }

                    final startKm = int.tryParse(startKmController.text);
                    if (startKm == null || startKm <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter valid start kilometers')),
                      );
                      return;
                    }

                    // Prepare result
                    final result = {
                      'date': selectedDate,
                      'carName': selectedCar,
                      'startKm': startKm,
                    };

                    // Add end kilometers if provided
                    if (endKmController.text.isNotEmpty) {
                      final endKm = int.tryParse(endKmController.text);
                      if (endKm != null && endKm > 0) {
                        result['endKm'] = endKm;
                      }
                    }

                    Navigator.of(context).pop(result);
                  },
                  child: Text('SAVE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}