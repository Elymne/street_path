class Activity {
  final String id;
  final String name;

  Activity({required this.id, required this.name});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(id: json["ID"] as String, name: json["name"] as String);
  }
}
