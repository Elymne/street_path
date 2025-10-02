import 'package:poc_street_path/models/activity.model.dart';
import 'package:poc_street_path/models/company.model.dart';
import 'package:poc_street_path/models/zone.model.dart';

class Person {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;

  /// *
  final Zone zone;
  final Activity activity;
  final Company company;

  /// *
  final DateTime createdAt;

  /// *
  final String? portrait;
  final String? description;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,

    /// *
    required this.zone,
    required this.activity,
    required this.company,

    /// *
    required this.createdAt,

    /// *
    this.portrait,
    this.description,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json["ID"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      birthDate: DateTime.fromMillisecondsSinceEpoch(json["birthDate"]),

      /// *
      zone: Zone.fromJson(json["zone"]),
      activity: Activity.fromJson(json["activity"]),
      company: Company.fromJson(json["company"]),

      /// *
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),

      /// * Nullable.
      portrait: json["portrait"] as String?,
      description: json["portrait"] as String?,
    );
  }
}
