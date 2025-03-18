import 'package:flutter/material.dart';

class DrivingInstructorVehiclesPage extends StatefulWidget {
  final String instructorId;

  const DrivingInstructorVehiclesPage({
    Key? key,
    required this.instructorId,
  }) : super(key: key);

  @override
  _DrivingInstructorVehiclesPageState createState() =>
      _DrivingInstructorVehiclesPageState();
}

class _DrivingInstructorVehiclesPageState
    extends State<DrivingInstructorVehiclesPage> {
  bool _isLoading = true;
  List<Vehicle> _vehicles = [];
  String _selectedFilter = 'All Vehicles';
  final List<String> _filterOptions = [
    'All Vehicles',
    'Available',
    'In Maintenance',
    'In Use'
  ];

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    // Simulating data retrieval from database
    await Future.delayed(const Duration(seconds: 1));

    // Here you can replace this with a real API call
    setState(() {
      _vehicles = [
        Vehicle(
          id: '1',
          model: 'Toyota Corolla',
          licensePlate: 'ABC 123',
          year: 2022,
          lastMaintenance: DateTime.now().subtract(const Duration(days: 25)),
          nextMaintenance: DateTime.now().add(const Duration(days: 5)),
          status: VehicleStatus.available,
          fuelLevel: 80,
          mileage: 25000,
          features: ['Dual Control', 'Automatic', 'Rear Camera'],
        ),
        Vehicle(
          id: '2',
          model: 'Honda Civic',
          licensePlate: 'XYZ 789',
          year: 2021,
          lastMaintenance: DateTime.now().subtract(const Duration(days: 12)),
          nextMaintenance: DateTime.now().add(const Duration(days: 18)),
          status: VehicleStatus.inUse,
          fuelLevel: 65,
          mileage: 32000,
          features: ['Dual Control', 'Manual', 'Parking Sensors'],
        ),
        Vehicle(
          id: '3',
          model: 'Ford Focus',
          licensePlate: 'DEF 456',
          year: 2023,
          lastMaintenance: DateTime.now().subtract(const Duration(days: 5)),
          nextMaintenance: DateTime.now().add(const Duration(days: 25)),
          status: VehicleStatus.maintenance,
          fuelLevel: 40,
          mileage: 18000,
          features: ['Dual Control', 'Manual', 'Beginner Friendly'],
        ),
      ];
      _isLoading = false;
    });
  }

  List<Vehicle> _getFilteredVehicles() {
    switch (_selectedFilter) {
      case 'Available':
        return _vehicles
            .where((vehicle) => vehicle.status == VehicleStatus.available)
            .toList();
      case 'In Maintenance':
        return _vehicles
            .where((vehicle) => vehicle.status == VehicleStatus.maintenance)
            .toList();
      case 'In Use':
        return _vehicles
            .where((vehicle) => vehicle.status == VehicleStatus.inUse)
            .toList();
      default:
        return _vehicles;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredVehicles = _getFilteredVehicles();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _fetchVehicles();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Count: ${filteredVehicles.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: _filterOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredVehicles.isEmpty
                ? const Center(
              child: Text(
                'No vehicles available',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                final vehicle = filteredVehicles[index];
                return VehicleCard(vehicle: vehicle);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Here you can add a new vehicle
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVehiclePage(instructorId: widget.instructorId),
            ),
          ).then((_) => _fetchVehicles());
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Vehicle',
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vehicle.model,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.directions_car, size: 16),
                const SizedBox(width: 4),
                Text('${vehicle.year} • ${vehicle.licensePlate}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildFuelIndicator(),
                const SizedBox(width: 16),
                const Icon(Icons.speed, size: 16),
                const SizedBox(width: 4),
                Text('${vehicle.mileage} km'),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: vehicle.features
                  .map(
                    (feature) => Chip(
                  label: Text(feature),
                  backgroundColor: Colors.blue[50],
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text('Next maintenance: ${_formatDate(vehicle.nextMaintenance)}'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleMaintenanceLogPage(vehicle: vehicle),
                      ),
                    );
                  },
                  child: const Text('Maintenance Log'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDetailsPage(vehicle: vehicle),
                      ),
                    );
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String statusText;

    switch (vehicle.status) {
      case VehicleStatus.available:
        badgeColor = Colors.green;
        statusText = 'Available';
        break;
      case VehicleStatus.inUse:
        badgeColor = Colors.blue;
        statusText = 'In Use';
        break;
      case VehicleStatus.maintenance:
        badgeColor = Colors.orange;
        statusText = 'Maintenance';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFuelIndicator() {
    Color fuelColor;
    if (vehicle.fuelLevel > 70) {
      fuelColor = Colors.green;
    } else if (vehicle.fuelLevel > 30) {
      fuelColor = Colors.orange;
    } else {
      fuelColor = Colors.red;
    }

    return Row(
      children: [
        const Icon(Icons.local_gas_station, size: 16),
        const SizedBox(width: 4),
        Container(
          width: 60,
          height: 10,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Container(
                width: 60 * vehicle.fuelLevel / 100,
                decoration: BoxDecoration(
                  color: fuelColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text('${vehicle.fuelLevel}%'),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Add Vehicle Page (stub)
class AddVehiclePage extends StatelessWidget {
  final String instructorId;

  const AddVehiclePage({Key? key, required this.instructorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Vehicle'),
      ),
      body: const Center(
        child: Text('Add New Vehicle Interface'),
      ),
    );
  }
}

// Vehicle Details Page (stub)
class VehicleDetailsPage extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailsPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.model} Details'),
      ),
      body: const Center(
        child: Text('Full Vehicle Details'),
      ),
    );
  }
}

// Vehicle Maintenance Log Page (stub)
class VehicleMaintenanceLogPage extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleMaintenanceLogPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.model} Maintenance Log'),
      ),
      body: const Center(
        child: Text('Maintenance History'),
      ),
    );
  }
}

// Vehicle Status Enum
enum VehicleStatus {
  available,
  inUse,
  maintenance,
}

// Vehicle Data Model
class Vehicle {
  final String id;
  final String model;
  final String licensePlate;
  final int year;
  final DateTime lastMaintenance;
  final DateTime nextMaintenance;
  final VehicleStatus status;
  final int fuelLevel;
  final int mileage;
  final List<String> features;

  Vehicle({
    required this.id,
    required this.model,
    required this.licensePlate,
    required this.year,
    required this.lastMaintenance,
    required this.nextMaintenance,
    required this.status,
    required this.fuelLevel,
    required this.mileage,
    required this.features,
  });
}