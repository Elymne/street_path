// * ======================================================================

// * Configuration. Signature de l'envoyeur spécifique à mon app.
final int bleManufacturerId = 0xbedb35;

// * Identifiant ble service (UUID v4).
final String bleServiceId = '3d38905c-4ae9-427e-80be-f6e4f7c6d012';

// * ======================================================================

// * Version de payload.
final int blePayloadVersion = 0x01; // * Première version pourle PoC (Simplement du text).

// * L'identifiant du protocole de mon app spécifiquement pour filtrer rapidement la data.
final int bleProtocolId = 0x0f;

// * Types de messages (identitifants du type de données transféré).
final int bleTypeIdContents = 0x01; // * Contenu
final int bleTypeIdInfo = 0x02; // * Information générale.
