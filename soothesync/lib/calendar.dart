import 'package:flutter/material.dart';
import 'package:soothesync/home.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:soothesync/backend/dbhelper.dart';
import 'package:soothesync/backend/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _currentIndex = 1;

  // Current day
  DateTime _focusedDay = DateTime.now();

  // Selected day
  DateTime? _selectedDay;

  // Example event log
  // TODO: event log logic
  List<Map<String, dynamic>> anxietyLogs = [];
  List<String> selectedSymptoms = [];
  String? _docId = "";

  void realTimeListen() {
    FirebaseFirestore.instance.collection('anxiety_logs').snapshots().listen((
      snapshot,
    ) {
      setState(() {
        anxietyLogs =
            snapshot.docs.map((doc) {
              return {
                'date': doc['dateTime'], // Firestore Timestamp
                'heartRate': doc['heartRate'],
                'oxygenLevel': doc['oxygenLevel'],
                'anxietyScore': doc['anxietyScore'],
                'symptoms':
                    doc['symptoms'] != null
                        ? List<String>.from(doc['symptoms'])
                        : [],
                'docId': doc.id, // Ensure docId is included
              };
            }).toList();
      });
    });
  }

  // Future<void> fetchAllLogs() async {
  //   final firestore = FirebaseFirestore.instance;
  //   final querySnapshot = await firestore.collection('anxiety_logs').get();

  //   querySnapshot.docs.forEach((doc) {
  //     print('Document ID: ${doc.id}');
  //   });

  //   setState(() {
  //     anxietyLogs =
  //         querySnapshot.docs.map((doc) {
  //           return {
  //             'date': doc['dateTime'],
  //             'heartRate': doc['heartRate'],
  //             'oxygenLevel': doc['oxygenLevel'],
  //             'anxietyScore': doc['anxietyScore'],
  //             'severityLevel': doc['severityLevel'],
  //             'symptoms': List<String>.from(doc['symptoms']),
  //             'docId': doc.id,
  //           };
  //         }).toList();
  //   });
  // }

  Future<void> addSymptoms(List<String> selectedSymptoms, String? docId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('anxiety_logs').doc(docId);

      // Fetch the existing symptoms array from the document
      DocumentSnapshot docSnapshot = await docRef.get();
      List<String> currentSymptoms = List<String>.from(docSnapshot['symptoms'] ?? []);

      // Find the symptoms to remove (those that are no longer in selectedSymptoms)
      List<String> symptomsToRemove = currentSymptoms.where((symptom) => !selectedSymptoms.contains(symptom)).toList();

      // Find the symptoms to add (those that are in selectedSymptoms but not in currentSymptoms)
      List<String> symptomsToAdd = selectedSymptoms.where((symptom) => !currentSymptoms.contains(symptom)).toList();

      // Remove the old symptoms and add the new ones
      await docRef.update({
        'symptoms': FieldValue.arrayRemove(symptomsToRemove),
      });

      if (symptomsToAdd.isNotEmpty) {
        await docRef.update({
          'symptoms': FieldValue.arrayUnion(symptomsToAdd),
        });
      }
    } catch (e) {
      print('Error adding symptoms: $e');
    }
  }

  void _toggleSymptomSelection(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    realTimeListen();
    // fetchAllLogs();
  }

  Color bgColor = Color(0xFF4B6AC8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
      ),
      body: SingleChildScrollView(
        // Wrap Column with SingleChildScrollView to make it scrollable
        child: Column(
          children: [
            // Calendar section
            _buildCalendar(),

            // Log section
            _buildLogSection(),

            // Symptoms section
            _buildSymptomsSection(),

            // Consultation section
            // _buildConsultationSection(),
          ],
        ),
      ),
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
          if (_currentIndex == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: TableCalendar(
          firstDay: DateTime.utc(2021),
          lastDay: DateTime.utc(2050),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,

          // Handle day selection
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              final log = anxietyLogs.firstWhere(
                (log) =>
                    (log['date'].toDate().year == selectedDay.year &&
                        log['date'].toDate().month == selectedDay.month &&
                        log['date'].toDate().day == selectedDay.day) ||
                    (log['date'].toDate().year == focusedDay.year &&
                        log['date'].toDate().month == focusedDay.month &&
                        log['date'].toDate().day == focusedDay.day &&
                        focusedDay.day == selectedDay.day),
                orElse: () => {}, // Return null if no log is found
              );

              // Update selectedSymptoms with symptoms from the log
              if (log.isNotEmpty) {
                selectedSymptoms = List<String>.from(log['symptoms'] ?? []);
                _docId = log['docId'];
              } else {
                selectedSymptoms = [];
                _docId = null;
              }
              print('_docIdLog: $_docId'); // Debugging
            });
          },

          // Calendar Styling
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(Icons.chevron_left, color: bgColor),
            rightChevronIcon: Icon(Icons.chevron_right, color: bgColor),
            titleTextStyle: TextStyle(
              color: bgColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Provide events for each day if needed
          eventLoader: (day) {
            return anxietyLogs
                .where(
                  (log) =>
                      log['date'].toDate().year == day.year &&
                      log['date'].toDate().month == day.month &&
                      log['date'].toDate().day == day.day,
                )
                .map((log) {
                  return log['symptoms'];
                })
                .toList();
            // return _eventLog[DateTime(day.year, day.month, day.day)] ?? [];
          },
        ),
      ),
    );
  }

  Widget _buildLogSection() {
    final dayEvents =
        anxietyLogs
            .where(
              (log) =>
                  log['date'].toDate().year == _focusedDay.year &&
                  log['date'].toDate().month == _focusedDay.month &&
                  log['date'].toDate().day == _focusedDay.day,
            )
            .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Log',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),

          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (dayEvents.isEmpty)
                  Text('No events for this day.')
                else
                  Text('Anxiety Attack Occured'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsSection() {
    // Find the log for the selected day, if any
    // final log = anxietyLogs.where(
    //   (log) =>
    //       log['date'].toDate().year == _focusedDay.year &&
    //       log['date'].toDate().month == _focusedDay.month &&
    //       log['date'].toDate().day == _focusedDay.day,
    // ).toList();

    print(selectedSymptoms); // Debugging line

    final log = anxietyLogs.firstWhere(
      (log) =>
          (_selectedDay != null &&
              log['date'].toDate().year == _selectedDay!.year &&
              log['date'].toDate().month == _selectedDay!.month &&
              log['date'].toDate().day == _selectedDay!.day) ||
          (_focusedDay != null &&
              log['date'].toDate().year == _focusedDay!.year &&
              log['date'].toDate().month == _focusedDay!.month &&
              log['date'].toDate().day == _focusedDay!.day),
      orElse: () => {}, // Return an empty map if no log is found
    );

    // If no log is found for the selected day, return a message
    if (log.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Text(
          'No log found for the selected day.',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }

    _docId = log['docId']; // Extract docId from the found log
    print('_docId: $_docId'); // Debugging line
    print('Log: $log'); // Debugging line

    final symptoms = [
      'Palpitations',
      'Intense Fear',
      'Sweating',
      'Shaking',
      'Shortness of Breath',
      'Numbness',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Symptoms',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              onPressed: () {
                if (_docId != null && selectedSymptoms.isNotEmpty) {
                  // Update the symptoms in Firestore
                  addSymptoms(selectedSymptoms, _docId);
                } else {
                  if (_docId != null) {
                    print('Cannot save symptoms: No symptoms selected.');
                  } else {
                    print(
                      'Cannot save symptoms: No log found for the selected day.',
                    );
                  }
                }
              },
              icon: Icon(Icons.save),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: symptoms.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(symptoms[index]),
                    trailing: Icon(
                      selectedSymptoms.contains(symptoms[index])
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    onTap: () {
                      _toggleSymptomSelection(symptoms[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Symptoms',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side
                    Row(
                      children: [
                        Text(
                          'Doctor ABCDE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.delete, color: Colors.blue, size: 20),
                      ],
                    ),

                    // Right side
                    Row(
                      children: [
                        Icon(Icons.notifications, color: Colors.blue, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '16.00 - 20.00',
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Hospital address
                Text(
                  'Santo Borromeus Hospital, Jl. Ir. H. Juanda No. 100',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 4),

                // Contact number
                Text(
                  'Insert contact number',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LogEvents {
  final DateTime date;
  final List<String> symptoms;

  LogEvents({required this.date, required this.symptoms});
}
