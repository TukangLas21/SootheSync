import 'package:flutter/material.dart';
import 'package:soothesync/editpill.dart';

class EditMedicationPage extends StatefulWidget {
  @override
  _EditMedicationPageState createState() => _EditMedicationPageState();
}

class _EditMedicationPageState extends State<EditMedicationPage> {
  // Example list of pills
  List<PillItem> pills = [
    PillItem(
      pillName: 'Depram',
      pillDosage: 50,
      time: TimeOfDay(hour: 4, minute: 0),
    ),
    PillItem(
      pillName: 'Thorazine',
      pillDosage: 500,
      time: TimeOfDay(hour: 3, minute: 0),
    ),
    PillItem(
      pillName: 'Zoloft',
      pillDosage: 100,
      time: TimeOfDay(hour: 2, minute: 0),
    ),
    PillItem(
      pillName: 'Prozac',
      pillDosage: 20,
      time: TimeOfDay(hour: 1, minute: 0),
    ),
  ];

  Color bgColor = Color(0xFF4B6AC8);

  void _editPillItem(int index) async {
    final updatedPill = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPillPage(pill: pills[index])),
    );

    if (updatedPill != null) {
      setState(() {
        pills[index] = updatedPill;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Medication', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: pills.length,
        itemBuilder: (context, index) {
          final pillItem = pills[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(pillItem.pillName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              subtitle: Text(
                '${pillItem.pillDosage} pills\n${pillItem.time.format(context)}',
              ),
              onTap: () => _editPillItem(index),
            ),
          );
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //       ),
  //       title: Text('Medication'),
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.add),
  //           onPressed: () {
  //             // TODO: Add new medication logic here
  //           },
  //         ),
  //       ],
  //     ),
  //     backgroundColor: bgColor,
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Morning Pills Section
  //           Text(
  //             'Morning Pills',
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //           ...morningPills.map((pill) {
  //             return _buildPillItem(pill, 'Morning');
  //           }).toList(),
  //           SizedBox(height: 16),

  //           // Evening Pills Section
  //           Text(
  //             'Evening Pills',
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //           ...morningPills.map((pill) {
  //             return _buildPillItem(pill, 'Evening');
  //           }).toList(),
  //           SizedBox(height: 16),

  //           // Add pills
  //           ElevatedButton(
  //             onPressed: () {
  //               // TODO: Add pills logic here
  //             },
  //             child: Text('Add Pills'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // // Widget _buildPillItem(PillItem item) {

  // // }

  // Widget _buildPillItem(Map<String, String> pill, String time) {
  //   return Card(
  //     elevation: 4,
  //     margin: EdgeInsets.symmetric(vertical: 8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Pill name and dose
  //           Text(
  //             pill['name']!,
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //           ),
  //           Text(
  //             pill['dosage']!,
  //             style: TextStyle(fontSize: 14, color: Colors.grey),
  //           ),
  //           SizedBox(height: 8),

  //           // Time to consume
  //           DropdownButton<String>(
  //             value: selectedTime,
  //             onChanged: (newValue) {
  //               setState(() {
  //                 selectedTime = newValue!;
  //               });
  //             },
  //             items:
  //                 <String>[
  //                   'Before meal',
  //                   'After meal',
  //                 ].map<DropdownMenuItem<String>>((String value) {
  //                   return DropdownMenuItem<String>(
  //                     value: value,
  //                     child: Text(value),
  //                   );
  //                 }).toList(),
  //           ),
  //           SizedBox(height: 8),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class PillItem {
  final String pillName;
  final int pillDosage;
  final TimeOfDay time;

  PillItem({
    required this.pillName,
    required this.pillDosage,
    required this.time,
  });
}
