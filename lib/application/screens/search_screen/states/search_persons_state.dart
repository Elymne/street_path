// import 'dart:developer';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:poc_street_path/core/states/widget_state.dart';
// import 'package:poc_street_path/models/person.model.dart';
// import 'package:poc_street_path/models/zone.model.dart';
// import 'package:poc_street_path/actions/zones/get_zones.provider.dart';
// import 'package:poc_street_path/actions/persons/get_persons.provider.dart';

// final searchPersonsState = StateNotifierProvider<SearchPersonsNotifier, SearchPersonsState>((ref) {
//   return SearchPersonsNotifier(ref);
// });

// class SearchPersonsNotifier extends StateNotifier<SearchPersonsState> {
//   final Ref ref;

//   SearchPersonsNotifier(this.ref) : super(SearchPersonsState(status: WidgetStatus.init, persons: [], zones: []));

//   Future<void> searchFromInput({
//     String firstname = "",
//     String lastname = "",
//     String birthDate = "",
//     String zoneName = "",
//     String companyName = "",
//     String activityName = "",
//   }) async {
//     try {
//       if (firstname.isEmpty && lastname.isEmpty && birthDate.isEmpty && zoneName.isEmpty && companyName.isEmpty && activityName.isEmpty) {
//         state = SearchPersonsState(status: WidgetStatus.init, persons: [], zones: []);
//         return;
//       }

//       state = SearchPersonsState(status: WidgetStatus.loading, persons: state.persons, zones: state.zones);

//       final getPersonsParams = GetPersonsProviderParams(
//         firstname: firstname,
//         lastname: lastname,
//         birthDate: birthDate,
//         zoneID: "",
//         activityID: "",
//         companyID: "",
//       );
//       final getPersons = ref.read(getPersonsProvider(getPersonsParams).future);

//       final getZonesParams = GetZonesProviderParams(zoneName: zoneName);
//       final getZones = ref.read(getZonesProvider(getZonesParams).future);

//       final responses = await Future.wait([getPersons, getZones]);

//       state = SearchPersonsState(status: WidgetStatus.success, persons: responses[0] as List<Person>, zones: responses[1] as List<Zone>);
//     } catch (e, stack) {
//       state = SearchPersonsState(status: WidgetStatus.failure, persons: state.persons, zones: state.zones);
//       log("$e $stack");
//     }
//   }
// }

// class SearchPersonsState extends WidgetState {
//   final List<Person> persons;
//   final List<Zone> zones;

//   SearchPersonsState({required super.status, required this.persons, required this.zones});
// }
