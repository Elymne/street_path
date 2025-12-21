// import 'package:flutter/material.dart';
// import 'package:poc_street_path/domain/models/old/activity.model.dart';
// import 'package:poc_street_path/domain/models/old/company.model.dart';
// import 'package:poc_street_path/domain/models/old/zone.model.dart';

// class PersonFormState {
//   final ValueNotifier<PersonFormButtonState> state;

//   String _firstname = "";
//   String get firstname => _firstname;

//   String _lastname = "";
//   String get lastname => _lastname;

//   DateTime? _birthDate;
//   DateTime? get birthDate => _birthDate;

//   Zone? _zone;
//   Zone? get zone => _zone;
//   void resetZone() => _zone = null;

//   Activity? _activity;
//   Activity? get activity => _activity;
//   void resetActivity() => _activity = null;

//   Company? _company;
//   Company? get company => _company;
//   void resetCompany() => _company = null;

//   PersonFormState(this.state);

//   void updateValues({String? firstname, String? lastname, DateTime? birthDate, Zone? zone, Activity? activity, Company? company}) {
//     _firstname = firstname ?? _firstname;
//     _lastname = lastname ?? _lastname;
//     _birthDate = birthDate ?? _birthDate;
//     _zone = zone ?? _zone;
//     _activity = activity ?? _activity;
//     _company = company ?? _company;

//     state.value = PersonFormButtonState(
//       isFirstPageValid: _firstname.length >= 2 && _lastname.length >= 2 && _birthDate != null,
//       isSecondPageValid: _zone != null,
//     );
//   }
// }

// class PersonFormButtonState {
//   final bool isFirstPageValid;
//   final bool isSecondPageValid;

//   PersonFormButtonState({required this.isFirstPageValid, required this.isSecondPageValid});

//   bool cannotNext(int currentPage) {
//     return (!isFirstPageValid && currentPage == 0) || (isFirstPageValid && !isSecondPageValid && currentPage == 1);
//   }

//   bool canNext(int currentPage) {
//     return (isFirstPageValid && currentPage == 0) || (isFirstPageValid && isSecondPageValid && currentPage >= 1 && currentPage < 3);
//   }

//   bool canCreate(int currentPage) {
//     return (isFirstPageValid && isSecondPageValid && currentPage == 3);
//   }
// }
