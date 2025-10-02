import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/models/zone.model.dart';

final Map<GetZonesProviderParams, List<Zone>> _cached = {};
Timer? _timer;

final getZonesProvider = FutureProvider.autoDispose.family<List<Zone>, GetZonesProviderParams>((ref, params) async {
  if (_timer != null) {
    _timer = Timer(Duration(milliseconds: 10_000), () {
      _cached.clear();
      _timer = null;
    });
  }
  final cached = _cached[params];
  if (cached != null) {
    return cached;
  }
  final response = await Dio().get<String>("${dotenv.env["HOST"]}/zones", queryParameters: {"name": params.zoneName});
  if (response.statusCode != 200) {
    throw Exception();
  }
  if (response.data == null) {
    throw Exception();
  }
  final List<dynamic> raw = jsonDecode(response.data!)["data"];
  final zones = raw.cast<Map<String, dynamic>>().map((json) => Zone.fromJson(json)).toList();
  _cached[params] = zones;
  return zones;
});

class GetZonesProviderParams {
  final String zoneName;
  GetZonesProviderParams({required this.zoneName});
}
