import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soothesync/medication.dart';
import 'package:soothesync/calendar.dart';
import 'package:soothesync/medication.dart';
import 'package:soothesync/history.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  List<Map<String, dynamic>> anxietyLogs = [];
  List<PillItem> pillsData = [];

  late int anxietyLogLength = 0;

  Future<void> realTimeListen(DateTime date) async {
    final firestore = FirebaseFirestore.instance;

    // Normalize the time to the start of the day (00:00:00)
    final startOfDay = DateTime(date.year, date.month, date.day);
    // Normalize the time to the end of the day (23:59:59)
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    firestore
        .collection('anxiety_logs')
        .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dateTime', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            setState(() {
              anxietyLogs =
                  snapshot.docs.map((doc) {
                    return {
                      'date': doc['dateTime'],
                      'heartRate': doc['heartRate'],
                      'oxygenLevel': doc['oxygenLevel'],
                      'anxietyScore': doc['anxietyScore'],
                      'symptoms': List<String>.from(doc['symptoms']),
                      'docId':
                          doc.id, // Always include the document ID if needed
                    };
                  }).toList();
            });
          } else {
            print(
              "No logs found for the date: ${DateFormat('yyyy-MM-dd').format(date)}",
            );
          }
        });
  }

  Future<void> fetchPillData() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('pill_data').get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        pillsData =
            querySnapshot.docs.map((doc) {
              return PillItem.fromFirestore(doc);
            }).toList();
      });
    } else {
      print("No pill data found.");
    }
  }

  Future<void> syncDatabase() async {
    CollectionReference pills = FirebaseFirestore.instance.collection(
      'pill_data',
    );

    var snapshot = await pills.get();
    var existingDocIds = snapshot.docs.map((doc) => doc.id).toList();

    for (var pill in pillsData) {
      if (existingDocIds.contains(pill.docId)) {
        // Update existing document
        await pills.doc(pill.docId).update(pill.toMap());
      } else {
        // Add new document
        await pills.add(pill.toMap());
      }
    }
  }

  void _toggleIsTaken(int index) {
    setState(() {
      pillsData[index].isTaken = !pillsData[index].isTaken; // Toggle the value
      syncDatabase();
    });
  }

  DateTime _selectedDate = DateTime.now();

  int _currentIndex = 0;
  Color bgColor = Color(0xFF4B6AC8);

  @override
  void initState() {
    super.initState();
    realTimeListen(_selectedDate);
    anxietyLogLength = anxietyLogs.length;
    fetchPillData();
    syncDatabase();
    // Initialize the database and fetch logs if needed
    // _fetchLogs();
  }

  final String imageUrl =
      'https://content.dhhs.vic.gov.au/sites/default/files/logo-ARC.jpg';
  final String url =
      'https://www.betterhealth.vic.gov.au/health/conditionsandtreatments/anxiety-treatment-options';

  void _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Health Tracker")),
      appBar: AppBar(backgroundColor: bgColor, toolbarHeight: 4),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Padding(
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Text(
                'Today\'s Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),

              if (anxietyLogs.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard(
                      'Heart Rate Variability',
                      '${anxietyLogs.last['heartRate']}',
                    ),
                    _buildSummaryCard(
                      'Oxygen Saturation',
                      '${anxietyLogs.last['oxygenLevel']}',
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard(
                      'Anxiety Score',
                      '${anxietyLogs.last['anxietyScore']}',
                    ),
                    _buildSummaryCard(
                      'Severity Level',
                      '${anxietyLogs.last['anxietyScore']}',
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  'No logs available for today.',
                  style: TextStyle(color: Colors.white),
                ),
              ],

              SizedBox(height: 8),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryPage()),
                    );
                  },
                  child: Text('View History'),
                ),
              ),

              SizedBox(height: 16),

              // Pill box
              Text(
                'Pill Checklist',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 250,
                child:
                    pillsData.isEmpty
                        ? Center(
                          child: Text(
                            'No pills registered.',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : ListView.separated(
                          padding: EdgeInsets.all(4),
                          itemCount: pillsData.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final pillItem = pillsData[index];
                            return _buildPillData(pillItem);
                          },
                        ),
              ),

              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMedicationPage(),
                      ),
                    ).then((_) {
                      setState(() {
                        fetchPillData(); // Refresh the pill data after editing
                      });
                    });
                  },
                  child: Text('Edit Medication'),
                ),
              ),

              SizedBox(height: 24),

              _buildEducation(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),

      // Navbar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage()),
            );
          }
        },
      ),
    );
  }

  // Helper function to build summary cards
  Widget _buildSummaryCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
            if (title == 'Severity Level') ...[
              if (value == '1') ...[
                Text(
                  'Minimal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ] else if (value == '2') ...[
                Text(
                  'Mild',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
              ] else if (value == '3') ...[
                Text(
                  'Moderate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ] else if (value == '4') ...[
                Text(
                  'Severe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ] else if (value == '5') ...[
                Text(
                  'Debilitating',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ] else ...[
                Text(
                  'Unknown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ] else ...[
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEducation() {
    return GestureDetector(
      onTap: _launchURL,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Edu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Managing and treating anxiety',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        ),
    );
  }

  Widget _buildPillData(PillItem pillItem) {
    return ListTile(
      title: Text(
        pillItem.pillName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${pillItem.time.format(context)}',
        style: TextStyle(color: const Color.fromARGB(255, 206, 202, 202)),
      ),
      trailing: Checkbox(
        value: pillItem.isTaken,
        onChanged: (bool? value) {
          _toggleIsTaken(pillsData.indexOf(pillItem));
        },
        activeColor: Colors.blue,
        checkColor: Colors.white,
      ),
    );
  }

  // // Helper function to build emergency contact items
  // Widget _buildEmergencyContact(String name, IconData icon) {
  //   return Column(
  //     children: [
  //       IconButton(
  //         onPressed: () {},
  //         icon: Icon(icon, size: 40, color: Colors.white),
  //       ),
  //       Text(name, style: TextStyle(color: Colors.white)),
  //     ],
  //   );
  // }
}
