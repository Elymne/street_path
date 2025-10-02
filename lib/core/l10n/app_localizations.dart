import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// Le titre de l'application
  ///
  /// In fr, this message translates to:
  /// **'RedFlags'**
  String get title;

  /// Message de chargement et de vérification de l'accès au serveur et de l'application. Une petite animation stylax est visible.
  ///
  /// In fr, this message translates to:
  /// **'Vérification des données en cours'**
  String get checkLoading;

  /// Message signifiant que l'application est prête à être utilisé.
  ///
  /// In fr, this message translates to:
  /// **'Chargement terminé!'**
  String get checkSuccess;

  /// Message signifiant que l'application n'arrive pas à se connecter au serveur.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'accéder au serveur'**
  String get netFailure;

  /// Message signifiant que l'application a détecté une erreur et ne peux pas continuer l'action en cours.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur interne s\'est produite…'**
  String get applicationFailure;

  /// Texte de bouton d'accès à une ressource (vue, page, données…).
  ///
  /// In fr, this message translates to:
  /// **'Accéder'**
  String get accessButton;

  /// Texte de bouton d'accès à une recherche (vue, page, données…).
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get searchButton;

  /// Texte de bouton OKAY.
  ///
  /// In fr, this message translates to:
  /// **'Ok'**
  String get okButton;

  /// Texte de bouton Suivant.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get nextButton;

  /// Texte de bouton Retour.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get backButton;

  /// Texte de bouton Précédent.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get previousButton;

  /// Texte de bouton Créer.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get createButton;

  /// Réponse lorsqu'une personne a été créée par l'utilisateur.
  ///
  /// In fr, this message translates to:
  /// **'Personne ajoutée avec succès.'**
  String get personCreationSuccess;

  /// Texte de titre de la page d'ajout d'un redflag.
  ///
  /// In fr, this message translates to:
  /// **'Création'**
  String get createScreenTitle;

  /// Sous-Texte de titre de la page d'ajout d'un redflag.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute un potenciel redflag'**
  String get createScreenSubTitle;

  /// Texte de menu : Ajoute une personne.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get homeAddOption;

  /// Texte de menu : Recherche quelqu'un.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get homeSearchOption;

  /// Texte de menu : Regarder les nouvelles data.
  ///
  /// In fr, this message translates to:
  /// **'News'**
  String get homeNews;

  /// Texte de menu : Regarder les Options.
  ///
  /// In fr, this message translates to:
  /// **'Options'**
  String get homeOptions;

  /// Texte de titre de description d'une data.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get descriptionTitle;

  /// Titre de la homepage.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour'**
  String get homeScreenTitle;

  /// Sous-titre de la homepage.
  ///
  /// In fr, this message translates to:
  /// **'Comment vas-tu ?'**
  String get homeScreenSubTitle;

  /// Titre Navigation de la page de recherche par nom/prénom.
  ///
  /// In fr, this message translates to:
  /// **'Exploration'**
  String get searchScreenTitle;

  /// Sous-titre Navigation de la page de recherche.
  ///
  /// In fr, this message translates to:
  /// **'Recherche précise'**
  String get searchScreenSubTitle;

  /// Titre Navigation de la page de résultats de la recherche.
  ///
  /// In fr, this message translates to:
  /// **'Résultats'**
  String get personListViewScreenTitle;

  /// Sous-Titre Navigation de la page de résultats de la recherche.
  ///
  /// In fr, this message translates to:
  /// **'Personnes Trouvées'**
  String get personListViewScreenSubTitle;

  /// Label du champ de texte pour le nom de la ou les personnes recherchées.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get lastname;

  /// Label du champ de texte pour le prénom de la ou les personnes recherchées.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get firstname;

  /// Label du champ de texte pour la date de naissance de la ou les personnes recherchées.
  ///
  /// In fr, this message translates to:
  /// **'Date de Naissance'**
  String get birthDate;

  /// Label du champ de la ville actuelle de la ou les personnes recherchées.
  ///
  /// In fr, this message translates to:
  /// **'Ville/Région actuelle'**
  String get zoneName;

  /// Label du champ de l'entreprise dans laquelle travaille cette personne.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise/société'**
  String get companyName;

  /// Label du champ de texte d'activité ou métier actuelle de la ou les personnes recherchées.
  ///
  /// In fr, this message translates to:
  /// **'Métier/Activité'**
  String get activityName;

  /// Un message d'erreur lorsque l'utilisateur rentre un utilisateur qui existe déjà en DB.
  ///
  /// In fr, this message translates to:
  /// **'Cette personne semble déjà exister dans notre base de données.'**
  String get personDuplicationError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
