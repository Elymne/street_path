import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addPersonProvider = FutureProvider.autoDispose.family<void, AddPersonProviderParams>((ref, params) async {
  final response = await Dio().post<Map<String, dynamic>>(
    "${dotenv.env["HOST"]}/persons",
    data: {
      "firstname": params.firstname,
      "lastname": params.lastname,
      "birthDate": params.birthDate.millisecondsSinceEpoch,
      "zoneID": params.zoneID,
      "activityID": params.activityID,
      "companyID": params.companyID,
    },
  );

  if (response.statusCode == 201) {
    return;
  }

  if (response.statusCode == 406) {
    throw Exception();
  }

  throw Exception();
});

class AddPersonProviderParams {
  final String firstname;
  final String lastname;
  final DateTime birthDate;
  final String zoneID;
  final String? companyID;
  final String? activityID;
  AddPersonProviderParams({
    required this.firstname,
    required this.lastname,
    required this.birthDate,
    required this.zoneID,
    required this.companyID,
    required this.activityID,
  });
}
