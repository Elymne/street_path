// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:poc_street_path/app/screens/search_screen/states/search_persons_state.dart';
// import 'package:poc_street_path/app/widgets/shakles/shakle_textfield.dart';
// import 'package:poc_street_path/app/widgets/shakles/shakle_outlined_button.dart';
// import 'package:poc_street_path/core/l10n/app_localizations.dart';
// import 'package:poc_street_path/core/themes/style_constant.dart';

// class SearchScreen extends ConsumerStatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   ConsumerState<SearchScreen> createState() => _State();
// }

// class _State extends ConsumerState<SearchScreen> with TickerProviderStateMixin {
//   // * The time delay before fetching persons on any textfield changes.
//   Timer? _searchDelay;

//   /// * Values for each textfield.
//   String _firstname = "";
//   String _lastname = "";
//   String _birthDate = "";
//   String _zoneName = "";
//   String _activityName = "";
//   String _companyName = "";

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(searchPersonsState);

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(screenGlobalMargin),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // * Full spacer with background animation.
//             Expanded(child: SizedBox()),

//             // * Lastname Input.
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               child: ShakleTextfield(
//                 AppLocalizations.of(context)!.lastname,
//                 onChanged: (value) {
//                   _lastname = value;
//                   _onTextfieldChange();
//                 },
//               ),
//             ),

//             // * Firstname Input.
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               child: ShakleTextfield(
//                 AppLocalizations.of(context)!.firstname,
//                 onChanged: (value) {
//                   _firstname = value;
//                   _onTextfieldChange();
//                 },
//               ),
//             ),

//             // * BirthDate Input.
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               child: ShakleTextfield(
//                 AppLocalizations.of(context)!.birthDate,
//                 onChanged: (value) {
//                   _birthDate = value;
//                   _onTextfieldChange();
//                 },
//               ),
//             ),

//             // * Zone name Input.
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               child: ShakleTextfield(
//                 AppLocalizations.of(context)!.zoneName,
//                 onChanged: (value) {
//                   _zoneName = value;
//                   _onTextfieldChange();
//                 },
//               ),
//             ),

//             // * Activity name Input.
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               child: ShakleTextfield(
//                 AppLocalizations.of(context)!.activityName,
//                 onChanged: (value) {
//                   _activityName = value;
//                   _onTextfieldChange();
//                 },
//               ),
//             ),

//             // * Company name Input.
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               child: ShakleTextfield(
//                 AppLocalizations.of(context)!.activityName,
//                 onChanged: (value) {
//                   _companyName = value;
//                   _onTextfieldChange();
//                 },
//               ),
//             ),

//             // * Full spacer with background animation.
//             Expanded(child: SizedBox()),

//             // * Disabled button because no value found yet.
//             Visibility(
//               visible: state.persons.isEmpty,
//               child: Align(alignment: Alignment.center, child: ShakleOutlinedButton(AppLocalizations.of(context)!.searchButton)),
//             ),

//             // * Access button because values found.
//             Visibility(
//               visible: state.persons.isNotEmpty,
//               child: Align(
//                 alignment: Alignment.center,
//                 child: ShakleOutlinedButton("${AppLocalizations.of(context)!.searchButton} (${state.persons.length})"),
//               ),
//             ),

//             // * Bottom margin.
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Called everytime value textfield from this widget is changed.
//   /// This function fetch persons given textfield values.
//   /// Allow me to know how many person can be find given the textfield values.
//   void _onTextfieldChange() {
//     _searchDelay?.cancel();
//     _searchDelay = Timer(Duration(milliseconds: 200), () async {
//       await ref
//           .read(searchPersonsState.notifier)
//           .searchFromInput(
//             firstname: _firstname,
//             lastname: _lastname,
//             birthDate: _birthDate,
//             zoneName: _zoneName,
//             activityName: _activityName,
//             companyName: _companyName,
//           );
//     });
//   }
// }
