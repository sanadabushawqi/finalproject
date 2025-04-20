import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'NewVacationPage.dart';

class DrivingInstructorVacationsPage extends StatefulWidget {
  final String instructorId;

  const DrivingInstructorVacationsPage({
    Key? key,
    required this.instructorId,
  }) : super(key: key);

  @override
  _DrivingInstructorVacationsPageState createState() =>
      _DrivingInstructorVacationsPageState();
}

class _DrivingInstructorVacationsPageState
    extends State<DrivingInstructorVacationsPage> {
  bool _isLoading = true;
  List<Vacation> _vacations = [];
  String _selectedFilter = 'All Vacations';
  final List<String> _filterOptions = [
    'All Vacations',
    'Upcoming',
    'Past',
    'Pending Approval'
  ];
  int _remainingVacationDays = 15;

  @override
  void initState() {
    super.initState();
    _fetchVacations();
  }

  Future<void> _fetchVacations() async {
    // Simulating data retrieval from database
    await Future.delayed(const Duration(seconds: 1));

    // Here you can replace this with a real API call
    setState(() {
      _vacations = [
        Vacation(
          id: '1',
          startDate: DateTime.now().add(const Duration(days: 15)),
          endDate: DateTime.now().add(const Duration(days: 22)),
          status: VacationStatus.approved,
          reason: 'Annual leave',
          approved: true,
          approvedBy: 'Admin',
          approvedOn: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Vacation(
          id: '2',
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().subtract(const Duration(days: 25)),
          status: VacationStatus.completed,
          reason: 'Family vacation',
          approved: true,
          approvedBy: 'Manager',
          approvedOn: DateTime.now().subtract(const Duration(days: 45)),
        ),
        Vacation(
          id: '3',
          startDate: DateTime.now().add(const Duration(days: 45)),
          endDate: DateTime.now().add(const Duration(days: 47)),
          status: VacationStatus.pending,
          reason: 'Personal leave',
          approved: false,
          approvedBy: '',
          approvedOn: null,
        ),
      ];
      _isLoading = false;
    });
  }

  List<Vacation> _getFilteredVacations() {
    final now = DateTime.now();

    switch (_selectedFilter) {
      case 'Upcoming':
        return _vacations
            .where((vacation) => vacation.startDate.isAfter(now) && vacation.approved)
            .toList();
      case 'Past':
        return _vacations
            .where((vacation) => vacation.endDate.isBefore(now))
            .toList();
      case 'Pending Approval':
        return _vacations
            .where((vacation) => vacation.status == VacationStatus.pending)
            .toList();
      default:
        return _vacations;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredVacations = _getFilteredVacations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacations & Time Off'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildVacationSummary(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Requests: ${filteredVacations.length}',
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
            child: filteredVacations.isEmpty
                ? const Center(
              child: Text(
                'No vacation requests found',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: filteredVacations.length,
              itemBuilder: (context, index) {
                final vacation = filteredVacations[index];
                return VacationCard(vacation: vacation);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewVacationScreen(),  // Assuming you have this screen
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new student',
      ),
    );
  }

  Widget _buildVacationSummary() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            icon: Icons.event_available,
            label: 'Remaining Days',
            value: '$_remainingVacationDays days',
            color: Colors.green,
          ),
          _buildSummaryItem(
            icon: Icons.event_busy,
            label: 'Used Days',
            value: '${20 - _remainingVacationDays} days',
            color: Colors.orange,
          ),
          _buildSummaryItem(
            icon: Icons.pending_actions,
            label: 'Pending',
            value: '${_vacations.where((v) => v.status == VacationStatus.pending).length} requests',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class VacationCard extends StatelessWidget {
  final Vacation vacation;

  const VacationCard({Key? key, required this.vacation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vacation.reason,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.date_range, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${_formatDate(vacation.startDate)} - ${_formatDate(vacation.endDate)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timelapse, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${_calculateDuration(vacation.startDate, vacation.endDate)} days',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            if (vacation.approved && vacation.approvedOn != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    'Approved by ${vacation.approvedBy} on ${_formatDate(vacation.approvedOn!)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (vacation.status == VacationStatus.pending)
                  TextButton(
                    onPressed: () {
                      // Cancel vacation request logic
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Cancel Request'),
                          content: const Text('Are you sure you want to cancel this vacation request?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Add cancellation logic here
                                Navigator.of(context).pop();
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Cancel Request'),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VacationDetailsPage(vacation: vacation),
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

    switch (vacation.status) {
      case VacationStatus.pending:
        badgeColor = Colors.amber;
        statusText = 'Pending';
        break;
      case VacationStatus.approved:
        badgeColor = Colors.green;
        statusText = 'Approved';
        break;
      case VacationStatus.rejected:
        badgeColor = Colors.red;
        statusText = 'Rejected';
        break;
      case VacationStatus.completed:
        badgeColor = Colors.blue;
        statusText = 'Completed';
        break;
      case VacationStatus.cancelled:
        badgeColor = Colors.grey;
        statusText = 'Cancelled';
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

  String _formatDate(DateTime date) {
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(date);
  }

  int _calculateDuration(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }
}

// Request Vacation Page (stub)
class RequestVacationPage extends StatelessWidget {
  final String instructorId;
  final int remainingDays;

  const RequestVacationPage({
    Key? key,
    required this.instructorId,
    required this.remainingDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

// Vacation Details Page (stub)
class VacationDetailsPage extends StatelessWidget {
  final Vacation vacation;

  const VacationDetailsPage({
    Key? key,
    required this.vacation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacation Details'),
      ),
      body: const Center(
        child: Text('Full Vacation Request Details'),
      ),
    );
  }
}

// Vacation Status Enum
enum VacationStatus {
  pending,
  approved,
  rejected,
  completed,
  cancelled,
}

// Vacation Data Model
class Vacation {
  final String id;
  late final DateTime startDate;
  final DateTime endDate;
  final VacationStatus status;
  final String reason;
  final bool approved;
  final String approvedBy;
  final DateTime? approvedOn;

  Vacation({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.reason,
    required this.approved,
    required this.approvedBy,
    this.approvedOn,
  });

  set vacationName(String vacationName) {}
}