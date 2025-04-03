import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Current day
  DateTime _focusedDay = DateTime.now();

  // Selected day
  DateTime? _selectedDay;

  // Example event log
  // TODO: event log logic
  Map<DateTime, List<String>> _events = {
    DateTime(2025, 2, 9): ['Panic Attack - Occured'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      body: Column(
        children: [
          // Calendar section
          _buildCalendar(),

          // Log section
          _buildLogSection(),

          // Symptoms section
          _buildSymptomsSection(),

          // Consultation section
          _buildConsultationSection(),
        ],
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
        currentIndex: 1,
        onTap: (index) {
          // TODO: Handle navigation
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
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
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue),
        titleTextStyle: TextStyle(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: BoxDecoration(color: Colors.blue),
      ),
      // Provide events for each day if needed
      eventLoader: (day) {
        return _events[DateTime(day.year, day.month, day.day)] ?? [];
      },
    );
  }

  Widget _buildLogSection() {
    // Fetch events for the selected day
    final dayEvents =
        _events[DateTime(
          _selectedDay?.year ?? _focusedDay.year,
          _selectedDay?.month ?? _focusedDay.month,
          _selectedDay?.day ?? _focusedDay.day,
        )] ??
        [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (dayEvents.isEmpty)
            Text('No events for this day.')
          else
            Column(
              children:
                  dayEvents.map((event) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(event.split(' - ').first),
                        Text(event.split(' - ').last),
                      ],
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSymptomsSection() {
    // TODO: Symptoms list and logic
    final symptoms = [
      'Palpitations',
      'Intense Fear',
      'Sweating',
      'Shaking',
      'Shortness of Breath',
      'Numbness',
    ];

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Symptoms',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Handle add symptom
                    },
                    child: Text('Add More'),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Symptoms list
              Expanded(
                child: ListView.builder(
                  itemCount: symptoms.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(symptoms[index]),
                        trailing: Icon(Icons.add),
                        onTap: () {
                          // TODO: Add symptom logic
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationSection() {
    return Container(
      margin: const EdgeInsets.all(16.0),
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
                  Icon(
                    Icons.delete,
                    color: Colors.blue,
                    size: 20,
                  ),
                ],
              ),

              // Right side
              Row(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Colors.blue,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text('16.00 - 20.00', style: TextStyle(fontSize: 14, color: Colors.blue),),
                ],
              ),
            ],
          ),

          SizedBox(height: 8),

          // Hospital address
          Text(
            'Santo Borromeus Hospital, Jl. Ir. H. Juanda No. 100',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),

          // Contact number
          Text(
            'Insert contact number',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
