import 'package:flutter/material.dart';
import 'package:soothesync/home.dart';
import 'package:soothesync/backend/dbhelper.dart';
import 'package:soothesync/backend/log.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:soothesync/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> _initializeDatabase() async {
  await DatabaseHelper.instance.database;
  await _insertSampleData();
}

Future<void> _insertSampleData() async {
  // Sample log data
  AnxietyLog sampleLog1 = AnxietyLog(
    dateTime: DateTime.now(),
    heartRate: 85,
    oxygenLevel: 98,
    anxietyScore: 7,
    severityLevel: 'High',
    symptoms: ['Sweating', 'Shaking', 'Shortness of breath'],
  );

  AnxietyLog sampleLog2 = AnxietyLog(
    dateTime: DateTime.now().subtract(
      Duration(days: 1),
    ), // Sample data for a previous day
    heartRate: 78,
    oxygenLevel: 95,
    anxietyScore: 5,
    severityLevel: 'Medium',
    symptoms: ['Headache', 'Fatigue'],
  );

  // Insert the sample logs into the database
  await DatabaseHelper.instance.insertLog(sampleLog1);
  await DatabaseHelper.instance.insertLog(sampleLog2);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeDatabase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.blue),
      home: HomePage(),
    );
  }
}
