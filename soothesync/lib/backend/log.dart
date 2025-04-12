class AnxietyLog {
  final int? id;
  final DateTime dateTime;
  final int heartRate;
  final int oxygenLevel;
  final int anxietyScore;
  final String severityLevel;
  final List<String> symptoms;

  AnxietyLog({
    this.id,
    required this.dateTime,
    required this.heartRate,
    required this.oxygenLevel,
    required this.anxietyScore,
    required this.severityLevel,
    required this.symptoms,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'heartRate': heartRate,
      'oxygenLevel': oxygenLevel,
      'anxietyScore': anxietyScore,
      'severityLevel': severityLevel,
      'symptoms': symptoms.join(', '),
    };
  }

  static AnxietyLog fromMap(Map<String, dynamic> map) {
    return AnxietyLog(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      heartRate: map['heartRate'],
      oxygenLevel: map['oxygenLevel'],
      anxietyScore: map['anxietyScore'],
      severityLevel: map['severityLevel'],
      symptoms: (map['symptoms'] as String).split(', '),
    );
  }
}
