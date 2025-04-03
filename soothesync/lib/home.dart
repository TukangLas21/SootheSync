import 'package:flutter/material.dart';
import 'package:soothesync/medication.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Health Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: Text(
                    'U',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Hi, User', // Replace with actual username
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 24),

            Text(
              'Today\'s Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard('Average Heart Rate', '82 bpm', '+3 bpm'),
                _buildSummaryCard('Oxygen Level', '98%', '-2%'),
                _buildSummaryCard('Anxiety Score', '7', '-2'),
                _buildSummaryCard('Severity Level', 'High', ''),
              ],
            ),
            SizedBox(height: 24),

            // Pill box
            Text(
              'Pill Checklist',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildPillItem('Morning Pill', '8:00 AM', 'Take 1 pill'),
            _buildPillItem('Evening Pill', '6:00 PM', 'Take 2 pills'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditMedicationPage(),
                  ),
                );
              },
              child: Text('Edit Medication'),
            ),
            SizedBox(height: 24),

            // Emergency Contact
            Text(
              'Emergency Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEmergencyContact('Hospital', Icons.local_hospital),
                _buildEmergencyContact('911', Icons.phone),
              ],
            ),
          ],
        ),
      ),
      // Navbar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // TODO: Handle navigation
        },
      ),
    );
  }

  // Helper function to build summary cards
  Widget _buildSummaryCard(String title, String value, String change) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (change.isNotEmpty)
              Text(change, style: TextStyle(fontSize: 14, color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  // Helper function to build pill checklist items
  Widget _buildPillItem(String name, String time, String action) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(name),
      subtitle: Text(time),
      trailing: Text(action),
    );
  }

  // Helper function to build emergency contact items
  Widget _buildEmergencyContact(String name, IconData icon) {
    return Column(
      children: [
        IconButton(onPressed: () {}, icon: Icon(icon, size: 40)),
        Text(name),
      ],
    );
  }
}