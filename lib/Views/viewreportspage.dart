import 'package:flutter/material.dart';
import 'NewReportPage.dart';
class DrivingInstructorReportsPage extends StatefulWidget {
  final String instructorId;

  const DrivingInstructorReportsPage({
    Key? key,
    required this.instructorId,
  }) : super(key: key);

  @override
  _DrivingInstructorReportsPageState createState() =>
      _DrivingInstructorReportsPageState();
}

class _DrivingInstructorReportsPageState
    extends State<DrivingInstructorReportsPage> {
  bool _isLoading = true;
  List<StudentReport> _reports = [];
  String _selectedFilter = 'All Reports';
  final List<String> _filterOptions = [
    'All Reports',
    'Last Week',
    'Last Month',
    'Today'
  ];

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    // Simulating data retrieval from database
    await Future.delayed(const Duration(seconds: 1));

    // Here you can replace this with a real API call
    setState(() {
      _reports = [
        StudentReport(
          id: '1',
          studentName: 'Mohammed Ahmed',
          date: DateTime.now().subtract(const Duration(days: 2)),
          lessonDuration: 60,
          skills: ['Parking', 'Reversing', 'Hill start'],
          notes: 'Needs to improve reversing skills',
          rating: 3.5,
        ),
        StudentReport(
          id: '2',
          studentName: 'Sarah Mahmoud',
          date: DateTime.now().subtract(const Duration(days: 4)),
          lessonDuration: 90,
          skills: ['Traffic lights', 'Turning', 'Lane changing'],
          notes: 'Excellent performance in turning and lane changing',
          rating: 4.5,
        ),
        StudentReport(
          id: '3',
          studentName: 'Ahmed Khaled',
          date: DateTime.now().subtract(const Duration(days: 10)),
          lessonDuration: 45,
          skills: ['Parallel parking', 'Highway driving'],
          notes: 'Needs more practice on parallel parking',
          rating: 3.0,
        ),
      ];
      _isLoading = false;
    });
  }

  List<StudentReport> _getFilteredReports() {
    switch (_selectedFilter) {
      case 'Today':
        return _reports
            .where((report) => report.date.day == DateTime.now().day)
            .toList();
      case 'Last Week':
        final weekAgo = DateTime.now().subtract(const Duration(days: 7));
        return _reports.where((report) => report.date.isAfter(weekAgo)).toList();
      case 'Last Month':
        final monthAgo = DateTime.now().subtract(const Duration(days: 30));
        return _reports
            .where((report) => report.date.isAfter(monthAgo))
            .toList();
      default:
        return _reports;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredReports = _getFilteredReports();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Reports'),
        centerTitle: true,
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
                  'Reports Count: ${filteredReports.length}',
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
            child: filteredReports.isEmpty
                ? const Center(
              child: Text(
                'No reports available',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return ReportCard(report: report);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Here you can add a new report
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Newreportpage(instructorId: widget.instructorId),
            ),
          ).then((_) => _fetchReports());
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Report',
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final StudentReport report;

  const ReportCard({Key? key, required this.report}) : super(key: key);

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
                  report.studentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${report.date.day}/${report.date.month}/${report.date.year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 4),
                Text('Lesson Duration: ${report.lessonDuration} minutes'),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: report.skills
                  .map(
                    (skill) => Chip(
                  label: Text(skill),
                  backgroundColor: Colors.blue[50],
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'Notes: ${report.notes}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      report.rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // View report details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportDetailsPage(report: report),
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
}

// Add Report Page (stub)
class AddReportPage extends StatelessWidget {
  final String instructorId;

  const AddReportPage({Key? key, required this.instructorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Report'),
      ),
      body: const Center(
        child: Text('Add New Report Interface'),
      ),
    );
  }
}

// Report Details Page (stub)
class ReportDetailsPage extends StatelessWidget {
  final StudentReport report;

  const ReportDetailsPage({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${report.studentName} Report Details'),
      ),
      body: const Center(
        child: Text('Full Report Details'),
      ),
    );
  }
}

// Student Report Data Model
class StudentReport {
  final String id;
  final String studentName;
  final DateTime date;
  final int lessonDuration;
  final List<String> skills;
  final String notes;
  final double rating;

  StudentReport({
    required this.id,
    required this.studentName,
    required this.date,
    required this.lessonDuration,
    required this.skills,
    required this.notes,
    required this.rating,
  });
}