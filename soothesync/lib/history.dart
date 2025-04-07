import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Example history data

  final List<HistoryItem> historyData = [
    HistoryItem(
      date: 'Today, 23 April 2025',
      heartRate: 82,
      oxygenLevel: 98,
      anxietyScore: 7,
      severityLevel: 'High',
    ),
    HistoryItem(
      date: 'Tuesday, 22 April 2025',
      heartRate: 82,
      oxygenLevel: 98,
      anxietyScore: 7,
      severityLevel: 'High',
    ),
    HistoryItem(
      date: 'Monday, 21 April 2025',
      heartRate: 82,
      oxygenLevel: 98,
      anxietyScore: 7,
      severityLevel: 'High',
    ),
  ];

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
        title: Text('History', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: ListView.separated(
        padding: EdgeInsets.all(16.0),
        itemCount: historyData.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = historyData[index];
          return _buildHistoryItem(item);
        },
      ),
    );
  }

  Widget _buildHistoryItem(HistoryItem item) {
    Color bgColor = Color(0xFF4B6AC8);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: bgColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.date,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          _buildRow('Average Heart Rate', '${item.heartRate}', 'bpm'),
          _buildRow('Oxygen Level', '${item.oxygenLevel}', '%'),
          _buildRow('Anxiety Score', '${item.anxietyScore}', ''),
          _buildRow('Severity Level', item.severityLevel, ''),
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
          Text(
            '$value $metric',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class HistoryItem {
  final String date;
  final int heartRate;
  final int oxygenLevel;
  final int anxietyScore;
  final String severityLevel;

  HistoryItem({
    required this.date,
    required this.heartRate,
    required this.oxygenLevel,
    required this.anxietyScore,
    required this.severityLevel,
  });
}
