// * Nom de mon app unique.
// Reste le même peu importe la langue d'où le fait qu'il ne soit pas dans le système de gestion de la langue.
const String appName = 'StreetPath';

// * Marge globale de tous mes écrans.
const double screenMargin = 12.0;

// * Nom du service/runner streetpath qui tourne en background.
const String streetPathServiceName = 'street_path_service';

// * Nom de la signature du service de communication pour que les apps puissent se reconnaître.
const String streetPathSignatureName = 'streetpath-connect';

// * Nom de la notif du service StreetPath.
const String streetPathChannelName = 'StreetPath Service';
const String streetPathChannelDesc = 'StreetPath Service Background Runner for data sync bewteen app users.';

// * ID du StreetPath Service en train de tourner (uniquement un par appareil).
const int streetPathServiceId = 256;

// * Temps limite par défaut de la survie d'une donnée dans l'application.
const int defaultDbDataTime = 86_400_000 * 2; // 2 jours.

// * La taille max (octets) par defaut que l'application peut stocker sur le téléphone de l'utilisateur. Cette valeur est utilisé si l'utilisateur ne définie pas une taille maximum.
const int defaultDbLimitSize = 2_000_000_000; // 2go

// * Le nombre d'éléments supprimés automatiquement avant chaque vérification du poid des données de l'application.
const int chunkDeleteCount = 10;
