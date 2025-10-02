class Company {
  final String id;
  final String name;
  final String address;

  Company({required this.id, required this.name, required this.address});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(id: json["ID"] as String, name: json["name"] as String, address: json["name"] as String);
  }
}
