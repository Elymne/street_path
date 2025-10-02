class Link {
  final String id;
  final String value;

  Link({required this.id, required this.value});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(id: json["ID"] as String, value: json["value"] as String);
  }
}
