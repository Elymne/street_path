// import 'dart:ui';
// import 'package:poc_street_path/app/router/router.notifier.dart';
// import 'package:poc_street_path/app/screens/create_person_screen/widgets/form_widget_activity.dart';
// import 'package:poc_street_path/app/screens/create_person_screen/widgets/form_widget_company.dart';
// import 'package:poc_street_path/app/screens/create_person_screen/form/person_form_state.provider.dart';
// import 'package:poc_street_path/app/screens/create_person_screen/widgets/form_widget_identity.dart';
// import 'package:poc_street_path/app/screens/create_person_screen/widgets/form_widget_zone.dart';
// import 'package:poc_street_path/app/screens/create_person_screen/states/activities_state.provider.dart';
// import 'package:poc_street_path/app/screens/create_person_screen/states/companies_state.provider.dart';
// import 'package:poc_street_path/app/screens/create_person_screen/states/create_person_result_state.provider.dart';
// import 'package:poc_street_path/app/screens/create_person_screen/states/zones_state.provider.dart';
// import 'package:poc_street_path/app/screens/home_screen/home_screen.dart';
// import 'package:poc_street_path/app/widgets/layouts/title_container.dart';
// import 'package:poc_street_path/app/widgets/routing/slide_widget.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:poc_street_path/app/widgets/shakles/shakle_text_button.dart';
// import 'package:poc_street_path/core/states/widget_state.dart';
// import 'package:poc_street_path/core/themes/style_constant.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';

// class CreatePersonScreen extends ConsumerStatefulWidget {
//   const CreatePersonScreen({super.key});

//   @override
//   ConsumerState<CreatePersonScreen> createState() => _State();
// }

// class _State extends ConsumerState<CreatePersonScreen> {
//   final formState = ValueNotifier(PersonFormButtonState(isFirstPageValid: false, isSecondPageValid: false));
//   late final _pageCtrl = PageController(initialPage: 0)..addListener(() => setState(() {}));
//   late final _formCtrl = PersonFormState(formState);
//   bool isFreezing = false;

//   @override
//   Widget build(BuildContext context) {
//     ref.listen(createPersonResultStateProvider, (_, next) async {
//       if (next.status == WidgetStatus.success) {
//         setState(() => isFreezing = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(AppLocalizations.of(context)!.personCreationSuccess),
//             backgroundColor: Theme.of(context).colorScheme.primary,
//           ),
//         );
//         ref.read(zonesStateProvider.notifier).reset();
//         ref.read(activitiesStateProvider.notifier).reset();
//         ref.read(companiesStateProvider.notifier).reset();
//         ref.read(createPersonResultStateProvider.notifier).reset();
//         ref.read(routerNotifierprovider.notifier).pushAndRemoveUntil(Navigator.of(context), const HomeScreen());
//         return;
//       }

//       if (next.status == WidgetStatus.failure) {
//         setState(() => isFreezing = false);
//         if (next.errorIndex == CreatePersonResultState.networkError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(AppLocalizations.of(context)!.netFailure), backgroundColor: Theme.of(context).colorScheme.error),
//           );
//           return;
//         }
//         if (next.errorIndex == CreatePersonResultState.userInputError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(AppLocalizations.of(context)!.personDuplicationError),
//               backgroundColor: Theme.of(context).colorScheme.error,
//             ),
//           );
//           return;
//         }
//       }

//       if (next.status == WidgetStatus.loading) {
//         setState(() => isFreezing = true);
//         return;
//       }
//     });

//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         if (_pageCtrl.page == 0) {
//           ref.read(zonesStateProvider.notifier).reset();
//           ref.read(activitiesStateProvider.notifier).reset();
//           ref.read(companiesStateProvider.notifier).reset();
//           ref.read(createPersonResultStateProvider.notifier).reset();
//           ref.read(routerNotifierprovider.notifier).pop(Navigator.of(context));
//           return;
//         }
//         _pageCtrl.animateToPage(_pageCtrl.page!.toInt() - 1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(screenGlobalMargin),
//                 child: Column(
//                   children: [
//                     TitleContainer(
//                       title: AppLocalizations.of(context)!.createScreenTitle,
//                       subtitle: AppLocalizations.of(context)!.createScreenSubTitle,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     SizedBox(height: 40),
//                     Expanded(
//                       child: PageView(
//                         controller: _pageCtrl,
//                         physics: NeverScrollableScrollPhysics(),
//                         children: [
//                           FormWidgetIdentity(formCtrl: _formCtrl),
//                           FormWidgetZone(formCtrl: _formCtrl),
//                           FormWidgetActivity(formCtrl: _formCtrl),
//                           FormWidgetCompany(formCtrl: _formCtrl),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     ValueListenableBuilder(
//                       valueListenable: formState,
//                       builder: (context, value, _) {
//                         return Align(
//                           alignment: Alignment.centerRight,
//                           child: SlideWidget(
//                             duration: Duration(milliseconds: 1000),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Visibility(
//                                   visible: _pageCtrl.page != null ? _pageCtrl.page!.toInt() > 0 : false,
//                                   child: ShakleTextButton(
//                                     AppLocalizations.of(context)!.previousButton,
//                                     onPressed: () {
//                                       if (_pageCtrl.page == null) return;
//                                       _pageCtrl.animateToPage(
//                                         _pageCtrl.page!.toInt() - 1,
//                                         duration: Duration(milliseconds: 200),
//                                         curve: Curves.easeIn,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Visibility(
//                                       visible: value.cannotNext(_pageCtrl.page == null ? 0 : _pageCtrl.page!.toInt()),
//                                       child: ShakleTextButton(AppLocalizations.of(context)!.nextButton),
//                                     ),
//                                     Visibility(
//                                       visible: value.canNext(_pageCtrl.page == null ? 0 : _pageCtrl.page!.toInt()),
//                                       child: ShakleTextButton(
//                                         AppLocalizations.of(context)!.nextButton,
//                                         onPressed: () {
//                                           if (_pageCtrl.page == null) return;
//                                           _pageCtrl.animateToPage(
//                                             _pageCtrl.page!.toInt() + 1,
//                                             duration: Duration(milliseconds: 200),
//                                             curve: Curves.easeIn,
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     Visibility(
//                                       visible: value.canCreate(_pageCtrl.page == null ? 0 : _pageCtrl.page!.toInt()),
//                                       child: ShakleTextButton(
//                                         AppLocalizations.of(context)!.createButton,
//                                         onPressed: () {
//                                           ref.read(createPersonResultStateProvider.notifier).create(_formCtrl);
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             /// * Loading *
//             if (isFreezing)
//               BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: Container(color: Colors.black.withAlpha(100))),
//             if (isFreezing) Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   }
// }
