import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soothesync/firebase_options.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> anxietyLogs = [];

  void realTimeListen() {
    FirebaseFirestore.instance.collection('anxiety_logs').snapshots().listen((
      snapshot,
    ) {
      setState(() {
        anxietyLogs =
            snapshot.docs.map((doc) {
              return {
                'date': doc['dateTime'],
                'heartRate': doc['heartRate'],
                'oxygenLevel': doc['oxygenLevel'],
                'anxietyScore': doc['anxietyScore'],
                'symptoms': List<String>.from(doc['symptoms']),
              };
            }).toList();
        
        anxietyLogs.sort((a, b) {
          Timestamp dateA = a['date'];
          Timestamp dateB = b['date'];

          return dateB.compareTo(dateA); // Sort in descending order
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    realTimeListen();
  }

  Color bgColor = Color(0xFF4B6AC8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'History',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body:
          anxietyLogs.isEmpty
              ? Center(
                child: Text(
                  'No history available',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
              : ListView.separated(
                padding: EdgeInsets.all(16.0),
                itemCount: anxietyLogs.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final log = anxietyLogs[index];
                  return _buildHistoryCard(log);
                },
              ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> log) {
    Color bgColor = Color(0xFF4B6AC8);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: bgColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, MMMM d yyyy').format(log['date'].toDate()),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          _buildRow('Heart Rate Variability', '${log['heartRate']}', ''),
          _buildRow('Oxygen Saturation', '${log['oxygenLevel']}', '%'),
          _buildRow('Anxiety Score', '${log['anxietyScore']}', ''),
          _buildRow('Severity Level', '${log['anxietyScore']}', ''),
        ],
      ),
    );
  }


  Widget _buildRow(String label, String value, String metric) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          if (label == 'Severity Level') ...[
              if (value == '1') ...[
                Text(
                  'Minimal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ] else if (value == '2') ...[
                Text(
                  'Mild',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ] else if (value == '3') ...[
                Text(
                  'Moderate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ] else if (value == '4') ...[
                Text(
                  'Severe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ] else if (value == '5') ...[
                Text(
                  'Debilitating',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ] else ...[
                Text(
                  'Unknown',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ]
            ] else ...[
            Text(
              '$value $metric',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            ],
        ],
      ),
    );
  }
}
