// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get title => 'RedFlags';

  @override
  String get checkLoading => 'Vérification des données en cours';

  @override
  String get checkSuccess => 'Chargement terminé!';

  @override
  String get netFailure => 'Impossible d\'accéder au serveur';

  @override
  String get applicationFailure => 'Une erreur interne s\'est produite…';

  @override
  String get accessButton => 'Accéder';

  @override
  String get searchButton => 'Rechercher';

  @override
  String get okButton => 'Ok';

  @override
  String get nextButton => 'Suivant';

  @override
  String get backButton => 'Retour';

  @override
  String get previousButton => 'Précédent';

  @override
  String get createButton => 'Créer';

  @override
  String get personCreationSuccess => 'Personne ajoutée avec succès.';

  @override
  String get createScreenTitle => 'Création';

  @override
  String get createScreenSubTitle => 'Ajoute un potenciel redflag';

  @override
  String get homeAddOption => 'Ajouter';

  @override
  String get homeSearchOption => 'Rechercher';

  @override
  String get homeNews => 'News';

  @override
  String get homeOptions => 'Options';

  @override
  String get descriptionTitle => 'Description';

  @override
  String get homeScreenTitle => 'Bonjour';

  @override
  String get homeScreenSubTitle => 'Comment vas-tu ?';

  @override
  String get searchScreenTitle => 'Exploration';

  @override
  String get searchScreenSubTitle => 'Recherche précise';

  @override
  String get personListViewScreenTitle => 'Résultats';

  @override
  String get personListViewScreenSubTitle => 'Personnes Trouvées';

  @override
  String get lastname => 'Nom';

  @override
  String get firstname => 'Prénom';

  @override
  String get birthDate => 'Date de Naissance';

  @override
  String get zoneName => 'Ville/Région actuelle';

  @override
  String get companyName => 'Entreprise/société';

  @override
  String get activityName => 'Métier/Activité';

  @override
  String get personDuplicationError =>
      'Cette personne semble déjà exister dans notre base de données.';
}
