import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soothesync/addpill.dart';
import 'package:soothesync/editpill.dart';

class EditMedicationPage extends StatefulWidget {
  @override
  _EditMedicationPageState createState() => _EditMedicationPageState();
}

class _EditMedicationPageState extends State<EditMedicationPage> {
  List<PillItem> pillsData = [];

  void realTimeListen() {
    FirebaseFirestore.instance.collection("pill_data").snapshots().listen((
      snapshot,
    ) {
      setState(() {
        pillsData =
            snapshot.docs.map((doc) {
              return PillItem.fromFirestore(doc);
            }).toList();
      });
    });
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

  @override
  void initState() {
    super.initState();
    realTimeListen();
    syncDatabase();
  }

  Color bgColor = Color(0xFF4B6AC8);

  void _editPillItem(int index) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditPillPage(
              pillName: pillsData[index].pillName,
              pillDosage: pillsData[index].pillDosage,
              time: pillsData[index].time,
              docId: pillsData[index].docId, // Pass the document ID
            ),
      ),
    );

    // final updatedPill = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EditPillPage(pill: pillsData[index]),
    //   ),
    // );
    // if (updatedPill != null) {
    //   setState(() {
    //     pillsData[index] = updatedPill;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
        title: Text(
          'Medication',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 36.0, top: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPillPage()),
                  );
                },
                child: Text(
                  'Add Medication',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Container(
              height: 500,
              child: ListView.builder(
                itemCount: pillsData.length,
                itemBuilder: (context, index) {
                  final pillItem = pillsData[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 36.0,
                    ),
                    child: ListTile(
                      title: Text(
                        pillItem.pillName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${pillItem.pillDosage} mg\n${pillItem.time.format(context)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 61, 65, 66),
                        ),
                      ),
                      onTap: () => _editPillItem(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PillItem {
  final String pillName;
  final num pillDosage;
  final TimeOfDay time;
  bool isTaken;
  final String docId;

  PillItem({
    required this.pillName,
    required this.pillDosage,
    required this.time,
    this.isTaken = false,
    required this.docId,
  });

  factory PillItem.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    num dosage =
        data['dosage'] is int
            ? data['dosage']
            : double.parse(data['dosage'].toString());

    Timestamp timestamp = data['time'] as Timestamp;
    DateTime dateTime = timestamp.toDate();
    TimeOfDay timeOfDay = TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );

    return PillItem(
      pillName: data['name'],
      pillDosage: dosage,
      time: timeOfDay,
      isTaken: data['isTaken'] ?? false,
      docId: doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    Timestamp timestamp = Timestamp.fromDate(dateTime);

    return {
      'name': pillName,
      'dosage': pillDosage,
      'time': timestamp,
      'isTaken': isTaken,
    };
  }
}
