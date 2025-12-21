/// Configuration. Signature de l'envoyeur spécifique à mon app.
/// Service unique pour tout le monde.
final int bleManufacturerId = 0xbedb35;

// * L'identifiant du protocole de mon app spécifiquement pour filtrer rapidement la data.
final int bleProtocolId = 0x0f;

// * Types de messages.
final int bleTypeContents = 0x01; // * Message de base pour du transfert de contenus.

// * Version de payload.
final int blePayloadVersion = 0x01; // * Première version pourle PoC (Simplement du text).
