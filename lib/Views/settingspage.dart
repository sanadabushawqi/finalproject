import 'package:flutter/material.dart';

class DrivingInstructorSettingsPage extends StatefulWidget {
  final String instructorId;

  const DrivingInstructorSettingsPage({
    Key? key,
    required this.instructorId,
  }) : super(key: key);

  @override
  _DrivingInstructorSettingsPageState createState() =>
      _DrivingInstructorSettingsPageState();
}

class _DrivingInstructorSettingsPageState
    extends State<DrivingInstructorSettingsPage> {
  bool _isLoading = true;
  late InstructorSettings _settings;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _licenseController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    // Simulating data retrieval from database
    await Future.delayed(const Duration(seconds: 1));

    // Here you can replace this with a real API call
    setState(() {
      _settings = InstructorSettings(
        instructorId: widget.instructorId,
        name: 'John Smith',
        email: 'john.smith@example.com',
        phone: '+1 (555) 123-4567',
        licenseNumber: 'DI12345678',
        licenseExpiry: DateTime.now().add(const Duration(days: 365)),
        notificationsEnabled: true,
        darkModeEnabled: false,
        language: 'English',
        bio: 'Professional driving instructor with 10+ years of experience. Specialized in teaching defensive driving techniques.',
        availableDays: [
          WeekDay.monday,
          WeekDay.tuesday,
          WeekDay.wednesday,
          WeekDay.thursday,
          WeekDay.friday,
        ],
        workingHours: WorkingHours(
          start: const TimeOfDay(hour: 8, minute: 0),
          end: const TimeOfDay(hour: 17, minute: 0),
        ),
        breakTime: WorkingHours(
          start: const TimeOfDay(hour: 12, minute: 0),
          end: const TimeOfDay(hour: 13, minute: 0),
        ),
      );

      // Initialize controllers with current values
      _nameController = TextEditingController(text: _settings.name);
      _emailController = TextEditingController(text: _settings.email);
      _phoneController = TextEditingController(text: _settings.phone);
      _licenseController = TextEditingController(text: _settings.licenseNumber);
      _bioController = TextEditingController(text: _settings.bio);

      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      setState(() {
        _isLoading = true;
      });

      // Update settings object with form values
      _settings = _settings.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        licenseNumber: _licenseController.text,
        bio: _bioController.text,
      );

      // Simulate API call to save settings
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(),
              const SizedBox(height: 24),
              _buildAccountSection(),
              const SizedBox(height: 24),
              _buildPreferencesSection(),
              const SizedBox(height: 24),
              _buildScheduleSection(),
              const SizedBox(height: 24),
              _buildSecuritySection(),
              const SizedBox(height: 24),
              _buildSupportSection(),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Profile Information', Icons.person),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bioController,
          decoration: const InputDecoration(
            labelText: 'Bio',
            border: OutlineInputBorder(),
            hintText: 'Tell students about yourself and your experience',
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Account Information', Icons.badge),
        TextFormField(
          controller: _licenseController,
          decoration: const InputDecoration(
            labelText: 'License Number',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your license number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            // Show date picker for license expiry
            _selectLicenseExpiryDate(context);
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'License Expiry Date',
              border: OutlineInputBorder(),
            ),
            child: Text(
              '${_settings.licenseExpiry.day}/${_settings.licenseExpiry.month}/${_settings.licenseExpiry.year}',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Preferences', Icons.settings),
        SwitchListTile(
          title: const Text('Enable Notifications'),
          subtitle: const Text('Receive alerts for new bookings and updates'),
          value: _settings.notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _settings = _settings.copyWith(notificationsEnabled: value);
            });
          },
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme for the app'),
          value: _settings.darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _settings = _settings.copyWith(darkModeEnabled: value);
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Language',
            border: OutlineInputBorder(),
          ),
          value: _settings.language,
          items: const [
            DropdownMenuItem(value: 'English', child: Text('English')),
            DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
            DropdownMenuItem(value: 'French', child: Text('French')),
            DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _settings = _settings.copyWith(language: value);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Schedule', Icons.calendar_today),
        const Text('Available Days'),
        Wrap(
          spacing: 8,
          children: [
            _buildDayChip(WeekDay.monday),
            _buildDayChip(WeekDay.tuesday),
            _buildDayChip(WeekDay.wednesday),
            _buildDayChip(WeekDay.thursday),
            _buildDayChip(WeekDay.friday),
            _buildDayChip(WeekDay.saturday),
            _buildDayChip(WeekDay.sunday),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectTimeRange(context, true, true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Working Hours Start',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _formatTimeOfDay(_settings.workingHours.start),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectTimeRange(context, true, false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Working Hours End',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _formatTimeOfDay(_settings.workingHours.end),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectTimeRange(context, false, true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Break Time Start',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _formatTimeOfDay(_settings.breakTime.start),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectTimeRange(context, false, false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Break Time End',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _formatTimeOfDay(_settings.breakTime.end),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Security', Icons.security),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordPage(),
              ),
            );
          },
          icon: const Icon(Icons.lock),
          label: const Text('Change Password'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TwoFactorAuthPage(),
              ),
            );
          },
          icon: const Icon(Icons.security),
          label: const Text('Two-Factor Authentication'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Support', Icons.help),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help Center'),
          subtitle: const Text('Get help with common issues'),
          onTap: () {
            // Navigate to help center
          },
        ),
        ListTile(
          leading: const Icon(Icons.contact_support),
          title: const Text('Contact Support'),
          subtitle: const Text('Email or call our support team'),
          onTap: () {
            // Navigate to contact support
          },
        ),
        ListTile(
          leading: const Icon(Icons.report_problem),
          title: const Text('Report a Problem'),
          subtitle: const Text('Let us know if something isn\'t working'),
          onTap: () {
            // Navigate to report problem
          },
        ),
      ],
    );
  }

  Widget _buildDayChip(WeekDay day) {
    final bool isSelected = _settings.availableDays.contains(day);
    return FilterChip(
      label: Text(_getWeekDayName(day)),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _settings.availableDays.add(day);
          } else {
            _settings.availableDays.remove(day);
          }
        });
      },
    );
  }

  String _getWeekDayName(WeekDay day) {
    switch (day) {
      case WeekDay.monday:
        return 'Mon';
      case WeekDay.tuesday:
        return 'Tue';
      case WeekDay.wednesday:
        return 'Wed';
      case WeekDay.thursday:
        return 'Thu';
      case WeekDay.friday:
        return 'Fri';
      case WeekDay.saturday:
        return 'Sat';
      case WeekDay.sunday:
        return 'Sun';
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectLicenseExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _settings.licenseExpiry,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null && picked != _settings.licenseExpiry) {
      setState(() {
        _settings = _settings.copyWith(licenseExpiry: picked);
      });
    }
  }

  Future<void> _selectTimeRange(
      BuildContext context, bool isWorkingHours, bool isStart) async {
    final TimeOfDay initialTime = isWorkingHours
        ? (isStart
        ? _settings.workingHours.start
        : _settings.workingHours.end)
        : (isStart ? _settings.breakTime.start : _settings.breakTime.end);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != initialTime) {
      setState(() {
        if (isWorkingHours) {
          _settings = _settings.copyWith(
            workingHours: WorkingHours(
              start: isStart ? picked : _settings.workingHours.start,
              end: isStart ? _settings.workingHours.end : picked,
            ),
          );
        } else {
          _settings = _settings.copyWith(
            breakTime: WorkingHours(
              start: isStart ? picked : _settings.breakTime.start,
              end: isStart ? _settings.breakTime.end : picked,
            ),
          );
        }
      });
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings Help'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'This page allows you to manage your account settings, preferences, and schedule.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  '• Profile Information: Update your personal details',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Account Information: Manage your license details',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Preferences: Customize your app experience',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Schedule: Set your working days and hours',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Security: Manage your account security options',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Support: Get help with the app',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Change Password Page (stub)
class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: const Center(
        child: Text('Change Password Interface'),
      ),
    );
  }
}

// Two-Factor Authentication Page (stub)
class TwoFactorAuthPage extends StatelessWidget {
  const TwoFactorAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
      ),
      body: const Center(
        child: Text('Two-Factor Authentication Interface'),
      ),
    );
  }
}

// Enum for week days
enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

// Working hours model
class WorkingHours {
  final TimeOfDay start;
  final TimeOfDay end;

  const WorkingHours({
    required this.start,
    required this.end,
  });
}

// Instructor Settings Data Model
class InstructorSettings {
  final String instructorId;
  final String name;
  final String email;
  final String phone;
  final String licenseNumber;
  final DateTime licenseExpiry;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;
  final String bio;
  final List<WeekDay> availableDays;
  final WorkingHours workingHours;
  final WorkingHours breakTime;

  InstructorSettings({
    required this.instructorId,
    required this.name,
    required this.email,
    required this.phone,
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.language,
    required this.bio,
    required this.availableDays,
    required this.workingHours,
    required this.breakTime,
  });

  // Copy with method to create a new instance with updated values
  InstructorSettings copyWith({
    String? name,
    String? email,
    String? phone,
    String? licenseNumber,
    DateTime? licenseExpiry,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? language,
    String? bio,
    List<WeekDay>? availableDays,
    WorkingHours? workingHours,
    WorkingHours? breakTime,
  }) {
    return InstructorSettings(
      instructorId: this.instructorId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
      bio: bio ?? this.bio,
      availableDays: availableDays ?? this.availableDays,
      workingHours: workingHours ?? this.workingHours,
      breakTime: breakTime ?? this.breakTime,
    );
  }
}