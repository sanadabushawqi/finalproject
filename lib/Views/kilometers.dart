import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// نموذج بيانات لتسجيل الكيلومترات
class KilometerRecord {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final int startKilometers;
  final int endKilometers;
  final DateTime date;
  final bool isCompleted;

  KilometerRecord({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.startKilometers,
    this.endKilometers = 0,
    required this.date,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'startKilometers': startKilometers,
      'endKilometers': endKilometers,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory KilometerRecord.fromJson(Map<String, dynamic> json) {
    return KilometerRecord(
      id: json['id'],
      vehicleId: json['vehicleId'],
      vehicleName: json['vehicleName'],
      startKilometers: json['startKilometers'],
      endKilometers: json['endKilometers'],
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'],
    );
  }
}

// نموذج بيانات للسيارة
class Vehicle {
  final String id;
  final String name;
  final String plateNumber;

  Vehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
  });
}

class KilometersPage extends StatefulWidget {
  const KilometersPage({Key? key}) : super(key: key);

  @override
  _KilometersPageState createState() => _KilometersPageState();
}

class _KilometersPageState extends State<KilometersPage> {
  List<Vehicle> _vehicles = [];
  List<KilometerRecord> _records = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // تحميل البيانات (في تطبيق حقيقي ستأتي من قاعدة بيانات أو API)
  Future<void> _loadData() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(Duration(milliseconds: 800));

    // قائمة وهمية للسيارات
    final vehicles = [
      Vehicle(id: '1', name: 'تويوتا كورولا', plateNumber: '12-34567'),
      Vehicle(id: '2', name: 'هوندا سيفيك', plateNumber: '23-45678'),
      Vehicle(id: '3', name: 'كيا سبورتاج', plateNumber: '34-56789'),
    ];

    // محاولة تحميل السجلات المخزنة مسبقًا
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList('kilometer_records') ?? [];
    final records = recordsJson
        .map((json) => KilometerRecord.fromJson(Map<String, dynamic>.from(
        Map<String, dynamic>.from(Map.castFrom<dynamic, dynamic, String, dynamic>(
            Map<String, dynamic>.from(const JsonDecoder().convert(json)))))))
        .where((record) =>
    DateFormat('yyyy-MM-dd').format(record.date) ==
        DateFormat('yyyy-MM-dd').format(_selectedDate))
        .toList();

    setState(() {
      _vehicles = vehicles;
      _records = records;
      _isLoading = false;
    });

    // إنشاء سجلات فارغة لكل سيارة إذا لم تكن موجودة لليوم المحدد
    _initializeRecordsForDate();
  }

  // إنشاء سجلات فارغة لكل سيارة لليوم المحدد
  void _initializeRecordsForDate() {
    for (final vehicle in _vehicles) {
      final existingRecord = _records.any((r) =>
      r.vehicleId == vehicle.id &&
          DateFormat('yyyy-MM-dd').format(r.date) ==
              DateFormat('yyyy-MM-dd').format(_selectedDate));

      if (!existingRecord) {
        final newRecord = KilometerRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString() + vehicle.id,
          vehicleId: vehicle.id,
          vehicleName: vehicle.name,
          startKilometers: 0,
          date: _selectedDate,
        );

        setState(() {
          _records.add(newRecord);
        });
      }
    }
    _saveRecords();
  }

  // حفظ السجلات
  Future<void> _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = _records.map((r) => const JsonEncoder().convert(r.toJson())).toList();
    await prefs.setStringList('kilometer_records', recordsJson);
  }

  // تغيير التاريخ المحدد
  void _changeDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _isLoading = true;
    });
    _loadData();
  }

  // تحديث قيمة الكيلومترات البداية
  void _updateStartKilometers(String vehicleId, int value) {
    setState(() {
      final index = _records.indexWhere((r) =>
      r.vehicleId == vehicleId &&
          DateFormat('yyyy-MM-dd').format(r.date) ==
              DateFormat('yyyy-MM-dd').format(_selectedDate));

      if (index != -1) {
        final record = _records[index];
        _records[index] = KilometerRecord(
          id: record.id,
          vehicleId: record.vehicleId,
          vehicleName: record.vehicleName,
          startKilometers: value,
          endKilometers: record.endKilometers,
          date: record.date,
          isCompleted: record.isCompleted,
        );
      }
    });
    _saveRecords();
  }

  // تحديث قيمة الكيلومترات النهاية
  void _updateEndKilometers(String vehicleId, int value) {
    setState(() {
      final index = _records.indexWhere((r) =>
      r.vehicleId == vehicleId &&
          DateFormat('yyyy-MM-dd').format(r.date) ==
              DateFormat('yyyy-MM-dd').format(_selectedDate));

      if (index != -1) {
        final record = _records[index];
        _records[index] = KilometerRecord(
          id: record.id,
          vehicleId: record.vehicleId,
          vehicleName: record.vehicleName,
          startKilometers: record.startKilometers,
          endKilometers: value,
          date: record.date,
          isCompleted: true,
        );
      }
    });
    _saveRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الكيلومترات'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                _changeDate(date);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'التاريخ: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return _buildVehicleKilometerCard(record);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleKilometerCard(KilometerRecord record) {
    // البحث عن السيارة المرتبطة بالسجل
    final vehicle = _vehicles.firstWhere(
          (v) => v.id == record.vehicleId,
      orElse: () => Vehicle(id: '', name: 'غير معروف', plateNumber: ''),
    );

    // حساب إجمالي الكيلومترات المقطوعة
    final totalDistance = record.endKilometers - record.startKilometers;

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
                  vehicle.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  'رقم اللوحة: ${vehicle.plateNumber}',
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
                  child: _buildKilometerField(
                    label: 'قراءة العداد (بداية اليوم)',
                    value: record.startKilometers,
                    onChanged: (value) {
                      if (value != null) {
                        _updateStartKilometers(record.vehicleId, value);
                      }
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildKilometerField(
                    label: 'قراءة العداد (نهاية اليوم)',
                    value: record.endKilometers,
                    onChanged: (value) {
                      if (value != null) {
                        _updateEndKilometers(record.vehicleId, value);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (record.isCompleted && record.endKilometers >= record.startKilometers)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'المسافة المقطوعة اليوم: $totalDistance كم',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            if (record.isCompleted && record.endKilometers < record.startKilometers)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'خطأ: قراءة نهاية اليوم أقل من قراءة البداية',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKilometerField({
    required String label,
    required int value,
    required Function(int?) onChanged,
  }) {
    final controller = TextEditingController(text: value > 0 ? value.toString() : '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixText: 'كم',
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          onChanged: (value) {
            final intValue = int.tryParse(value);
            onChanged(intValue);
          },
        ),
      ],
    );
  }
}