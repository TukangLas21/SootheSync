import 'package:flutter/material.dart';

class EditMedicationPage extends StatefulWidget {
  @override
  _EditMedicationPageState createState() => _EditMedicationPageState();
}

class _EditMedicationPageState extends State<EditMedicationPage> {
  // List of pills
  List<Map<String, String>> morningPills = [
    {'name': 'Depram', 'dosage': '50 mg', 'time': '04:60'},
    {'name': 'Thorazine', 'dosage': '500 mg', 'time': '03:00'},
  ];
  List<Map<String, String>> afternoonPills = [
    {'name': 'Depram', 'dosage': '50 mg', 'time': '14:60'},
    {'name': 'Thorazine', 'dosage': '500 mg', 'time': '03:00'},
  ];

  // Dropdown
  String selectedTime = 'Before meal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Medication'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: Add new medication logic here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Morning Pills Section
            Text(
              'Morning Pills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...morningPills.map((pill) {
              return _buildPillItem(pill, 'Morning');
            }).toList(),
            SizedBox(height: 16),

            // Evening Pills Section
            Text(
              'Evening Pills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...morningPills.map((pill) {
              return _buildPillItem(pill, 'Evening');
            }).toList(),
            SizedBox(height: 16),

            // Add pills
            ElevatedButton(
              onPressed: () {
                // TODO: Add pills logic here
              },
              child: Text('Add Pills'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillItem(Map<String, String> pill, String time) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pill name and dose
            Text(
              pill['name']!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              pill['dosage']!,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),

            // Time to consume
            DropdownButton<String>(
              value: selectedTime,
              onChanged: (newValue) {
                setState(() {
                  selectedTime = newValue!;
                });
              },
              items:
                  <String>[
                    'Before meal',
                    'After meal',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
