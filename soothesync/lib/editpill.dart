import 'package:flutter/material.dart';
import 'package:soothesync/medication.dart';

class EditPillPage extends StatefulWidget {
  final PillItem pill;

  EditPillPage({required this.pill});

  @override
  _EditPillPageState createState() => _EditPillPageState();
}

class _EditPillPageState extends State<EditPillPage> {
  late TextEditingController _pillNameController;
  late TextEditingController _pillDosageController;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _pillNameController = TextEditingController(text: widget.pill.pillName);
    _pillDosageController =
        TextEditingController(text: widget.pill.pillDosage.toString());
    _time = widget.pill.time;
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

  void _saveChanges() {
    final updatedPill = PillItem(
      pillName: _pillNameController.text,
      pillDosage: int.parse(_pillDosageController.text),
      time: _time,
    );
    Navigator.pop(context, updatedPill);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pill'),
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
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}