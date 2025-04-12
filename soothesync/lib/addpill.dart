import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AddPillPage extends StatefulWidget {
  @override
  _AddPillPageState createState() => _AddPillPageState();
}

class _AddPillPageState extends State<AddPillPage> {
  // Controllers for the form fields
  late TextEditingController _pillNameController;
  late TextEditingController _pillDosageController;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty text fields
    _pillNameController = TextEditingController();
    _pillDosageController = TextEditingController();
    _time = TimeOfDay(hour: 8, minute: 0); // Default time
  }

  @override
  void dispose() {
    _pillNameController.dispose();
    _pillDosageController.dispose();
    super.dispose();
  }

  // Function to add pill to Firestore
  Future<void> addPill() async {
    // Get the updated values from the form fields
    String pillName = _pillNameController.text;
    num pillDosage =
        num.tryParse(_pillDosageController.text) ?? 0.0; // Handle invalid input

    // Convert TimeOfDay to DateTime, then to Firestore Timestamp
    DateTime now = DateTime.now();
    DateTime pillTime = DateTime(
      now.year,
      now.month,
      now.day,
      _time.hour,
      _time.minute,
    );
    Timestamp pillTimestamp = Timestamp.fromDate(pillTime);

    // Add the pill data to Firestore
    CollectionReference pills = FirebaseFirestore.instance.collection(
      'pill_data',
    );
    await pills
        .add({
          'name': pillName,
          'dosage': pillDosage.toString(), // Store dosage as String
          'time': pillTimestamp,
        })
        .then((value) {
          print("Pill added successfully");
          Navigator.pop(context); // Go back to the previous page after saving
        })
        .catchError((error) {
          print("Failed to add pill: $error");
          // Handle error (e.g., show an error message to the user)
        });
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

  TextInputFormatter _commaToDotFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String newText = newValue.text.replaceAll(',', '.'); // Replace comma with dot
      return newValue.copyWith(text: newText);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Medication', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),         
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
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
                _commaToDotFormatter(), // Custom formatter to replace comma with dot
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
              onPressed: addPill,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
