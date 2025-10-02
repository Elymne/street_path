import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/models/person.model.dart';
import 'package:poc_street_path/actions/response.model.dart';

final Map<GetPersonsProviderParams, List<Person>> _cached = {};
Timer? _timer;

final getPersonsProvider = FutureProvider.autoDispose.family<List<Person>, GetPersonsProviderParams>((ref, params) async {
  /// * Check if we should clear the cache or not.
  if (_timer != null) {
    _timer = Timer(Duration(milliseconds: 10_000), () {
      _cached.clear();

      _timer = null;
    });
  }

  /// * Check if cached data exists. Return if it's the case.
  final cached = _cached[params];
  if (cached != null) {
    return cached;
  }

  /// * Make http request.
  final response = await Dio().get<String>(
    "${dotenv.env["HOST"]}/persons",
    queryParameters: {
      if (params.firstname.isNotEmpty) "firstname": params.firstname,
      if (params.lastname.isNotEmpty) "lastname": params.lastname,
      if (params.birthDate.isNotEmpty) "birthDate": params.birthDate,
      if (params.zoneID.isNotEmpty) "jobname": params.zoneID,
      if (params.activityID.isNotEmpty) "jobname": params.activityID,
      if (params.companyID.isNotEmpty) "jobname": params.companyID,
    },
  );

  /// * Check response code.
  if (response.statusCode != 200) {
    throw Exception();
  }

  /// * Check data type.
  if (response.data == null) {
    throw Exception();
  }

  /// * get resp
  final ResponseData<List> raw = jsonDecode(response.data!);

  /// * Parse json data.
  final persons = raw.data.cast<Map<String, dynamic>>().map((json) => Person.fromJson(json)).toList();

  /// * Cache result.
  _cached[params] = persons;

  /// * Return result.
  return persons;
});

class GetPersonsProviderParams {
  final String firstname;
  final String lastname;
  final String birthDate;
  final String zoneID;
  final String activityID;
  final String companyID;
  GetPersonsProviderParams({
    required this.firstname,
    required this.lastname,
    required this.birthDate,
    required this.zoneID,
    required this.activityID,
    required this.companyID,
  });
}
