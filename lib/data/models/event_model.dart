class Event {
  final int? id;
  final String title;
  final String description;
  final String location;
  final String priorityColor;
  final String time; // Time in HH:MM format or as needed
  final String date; // Date in YYYY-MM-DD format

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.priorityColor,
    required this.time,
    required this.date,
  });

  // Convert Event to a Map for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'priorityColor': priorityColor,
      'time': time,
      'date': date,
    };
  }

  // Convert a Map to an Event object
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      priorityColor: map['priorityColor'],
      time: map['time'],
      date: map['date'],
    );
  }
}
