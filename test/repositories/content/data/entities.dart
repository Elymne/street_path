import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_link_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_media_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:uuid/uuid.dart';

// * Généré à l'arrache te fait à l'arrache.

List<ContentTextEntity> get contentTextEntities => contentEntities.whereType<ContentTextEntity>().toList();

List<ContentLinkEntity> get contentLinkEntities => contentEntities.whereType<ContentLinkEntity>().toList();

List<ContentMediaEntity> get contentMediaEntities => contentEntities.whereType<ContentMediaEntity>().toList();

List<Object> contentEntities = [
  // * Entitité créé il y a un jour.
  ContentTextEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch - 86_400_000,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 2,
    authorName: 'Alice',
    flowName: 'updates',
    bounces: 0,
    title: 'Morning Brief',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    text: 'Today\'s summary of events and notes.',
  ),

  // * Entité créé il y a deux jours.
  ContentLinkEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch - (86_400_000 * 3),
    receivedAt: DateTime.now().millisecondsSinceEpoch + 4,
    authorName: 'Bob',
    flowName: 'resources',
    bounces: 2,
    title: 'Design Patterns',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    ref: 'https://example.com/design-patterns',
    description: 'A concise guide to common design patterns.',
  ),

  // * Entité créé avec un flow_name spécial.
  ContentMediaEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 5,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 6,
    authorName: 'Carol',
    flowName: 'SPECIAL',
    bounces: 0,
    title: 'City Sunset',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    path: 'media/images/city_sunset.jpg',
    description: 'High-resolution sunset over the skyline.',
  ),

  // * Entité créé par le user.
  ContentTextEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 7,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 8,
    authorName: 'Dave',
    flowName: 'announcements',
    bounces: 1,
    title: 'Maintenance Notice',
    shippingMode: ShippingMode.creator.value,
    storageMode: StorageMode.normal.value,
    text: 'Scheduled maintenance will occur this weekend.',
  ),

  // * Entité qui ne sera pas supprimé automatiquement.
  ContentLinkEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 9,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 10,
    authorName: 'Eve',
    flowName: 'links',
    bounces: 0,
    title: 'API Docs',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.save.value,
    ref: 'https://api.example.com/docs',
    description: 'Reference for the public API endpoints.',
  ),

  // ! Le reste.
  ContentMediaEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 11,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 12,
    authorName: 'Frank',
    flowName: 'podcasts',
    bounces: 3,
    title: 'Episode 12',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    path: 'media/audio/episode_12.mp3',
    description: 'Discussion on architecture and trade-offs.',
  ),
  ContentTextEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 13,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 14,
    authorName: 'Grace',
    flowName: 'tips',
    bounces: 0,
    title: 'Optimization Tricks',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    text: 'Small changes that improve performance significantly.',
  ),
  ContentLinkEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 15,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 16,
    authorName: 'Heidi',
    flowName: 'curation',
    bounces: 1,
    title: 'Community Tools',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    ref: 'https://community.example.com/tools',
    description: 'Hand-picked utilities from the community.',
  ),
  ContentMediaEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 17,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 18,
    authorName: 'Ivan',
    flowName: 'videos',
    bounces: 0,
    title: 'Intro Walkthrough',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    path: 'media/videos/intro_walkthrough.mp4',
    description: 'Short walkthrough of the main features.',
  ),
  ContentTextEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 19,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 20,
    authorName: 'Judy',
    flowName: 'blog',
    bounces: 2,
    title: 'Release Notes',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    text: 'What changed in the latest release and migration tips.',
  ),
  ContentTextEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 21,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 22,
    authorName: 'Kyle',
    flowName: 'stories',
    bounces: 0,
    title: 'User Story',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    text: 'A short case study about product adoption.',
  ),
  ContentLinkEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 23,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 24,
    authorName: 'Laura',
    flowName: 'research',
    bounces: 0,
    title: 'Study Results',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    ref: 'https://research.example.com/results',
    description: 'Findings from the recent usability study.',
  ),
  ContentMediaEntity(
    id: Uuid().v4(),
    createdAt: DateTime.now().millisecondsSinceEpoch + 25,
    receivedAt: DateTime.now().millisecondsSinceEpoch + 26,
    authorName: 'Mallory',
    flowName: 'archives',
    bounces: 1,
    title: 'Historic Photo',
    shippingMode: ShippingMode.normal.value,
    storageMode: StorageMode.normal.value,
    path: 'media/images/historic_photo.png',
    description: 'Scan from the historical archive.',
  ),
];
