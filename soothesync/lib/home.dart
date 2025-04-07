import 'package:flutter/material.dart';
import 'package:soothesync/medication.dart';
import 'package:soothesync/calendar.dart';
import 'package:soothesync/medication.dart';
import 'package:soothesync/history.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Color bgColor = Color(0xFF4B6AC8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Health Tracker")),
      appBar: AppBar(
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 24),

            Text(
              'Today\'s Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryCard('Average Heart Rate', '82 bpm', '+3 bpm'),
                  _buildSummaryCard('Oxygen Level', '98%', '-2%'),
                  _buildSummaryCard('Anxiety Score', '7', '-2'),
                  _buildSummaryCard('Severity Level', 'High', ''),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryPage(),
                    ),
                  );
                },
                child: Text('View History'),
              ),
            ),

            SizedBox(height: 24),

            // Pill box
            Text(
              'Pill Checklist',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            _buildPillItem('Morning Pill', '8:00 AM', 'Take 1 pill'),
            _buildPillItem('Evening Pill', '6:00 PM', 'Take 2 pills'),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
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
            ),

            SizedBox(height: 24),

            // Emergency Contact
            Text(
              'Emergency Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage())
            );
          }
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
      title: Text(name, style: TextStyle(color: Colors.white)),
      subtitle: Text(time, style: TextStyle(color: Colors.grey)),
      trailing: Text(action, style: TextStyle(color: Colors.grey)),
    );
  }

  // Helper function to build emergency contact items
  Widget _buildEmergencyContact(String name, IconData icon) {
    return Column(
      children: [
        IconButton(onPressed: () {}, icon: Icon(icon, size: 40, color: Colors.white,)),
        Text(name, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}