import 'package:flutter/material.dart';
import 'package:soothesync/medication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class EditPillPage extends StatefulWidget {
  final String pillName;
  final num pillDosage;
  final TimeOfDay time;
  final String docId; // Document ID for the pill

  EditPillPage({
    required this.pillName,
    required this.pillDosage,
    required this.time,
    required this.docId,
  });

  @override
  _EditPillPageState createState() => _EditPillPageState();
}

class _EditPillPageState extends State<EditPillPage> {
  late TextEditingController _pillNameController;
  late TextEditingController _pillDosageController;
  late TimeOfDay _time;
  // late String _docId; // Document ID for the pill
  // String get _docId => widget.pill.docId; // Getter for docId

  @override
  void initState() {
    super.initState();
    // _docId = widget.pill.docId; // Initialize the docId
    _pillNameController = TextEditingController(text: widget.pillName);
    _pillDosageController = TextEditingController(
      text: widget.pillDosage.toString(),
    );
    _time = widget.time;
  }

  @override
  void dispose() {
    _pillNameController.dispose();
    _pillDosageController.dispose();
    super.dispose();
  }

  // Function to pick time using TimePicker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (selectedTime != null && selectedTime != _time) {
      setState(() {
        _time = selectedTime;
      });
    }
  }

  Future<void> saveChanges() async {
    // Get the updated values from the form fields
    String updatedName = _pillNameController.text;
    num updatedDosage = num.tryParse(_pillDosageController.text) ?? 0.0; // Handle invalid input

    // Convert TimeOfDay to DateTime, then to Firestore Timestamp
    DateTime now = DateTime.now();
    DateTime updatedTime = DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
    Timestamp updatedTimestamp = Timestamp.fromDate(updatedTime);

    // Update the Firestore document with the new data
    CollectionReference pills = FirebaseFirestore.instance.collection('pill_data');
    await pills.doc(widget.docId).update({
      'name': updatedName,
      'dosage': updatedDosage.toString(),
      'time': updatedTimestamp,
    }).then((value) {
      print("Pill updated successfully");
      // You can navigate back or show a success message here
      Navigator.pop(context); // Go back to the previous page after saving
    }).catchError((error) {
      print("Failed to update pill: $error");
      // Handle error (e.g., show an error message to the user)
    });
  }

  TextInputFormatter _commaToDotFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String newText = newValue.text.replaceAll(',', '.'); // Replace comma with dot
      return newValue.copyWith(text: newText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Medication', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _pillNameController,
              decoration: InputDecoration(labelText: 'Pill Name'),
            ),
            TextField(
              controller: _pillDosageController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                _commaToDotFormatter(), // Replace commas with dots
              ],
              decoration: InputDecoration(labelText: 'Dosage (mg)'),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Time'),
              subtitle: Text('${_time.format(context)}'),
              onTap: () => _selectTime(context),
              trailing: Icon(Icons.access_time),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
