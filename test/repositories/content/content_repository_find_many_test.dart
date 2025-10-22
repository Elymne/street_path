import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_link_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_media_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/content_text_entity.dart';
import 'package:poc_street_path/infrastructure/datasources/repositories/content_repository_impl.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/domain/gateways/path.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final PathGateway pathGateway;
  late final ObjectBoxGateway objectboxGateway;
  late final ContentRepository contentRepository;

  // * Accès direct aux tables pour les tests.
  late final Box<ContentTextEntity> boxContentText;
  late final Box<ContentLinkEntity> boxContentLink;
  late final Box<ContentMediaEntity> boxContentMedia;

  // * Contenu de tests.
  List<ContentTextEntity> currentTextContents = [];
  List<ContentLinkEntity> currentLinkContents = [];
  List<ContentMediaEntity> currentMediaContents = [];

  setUpAll(() async {
    pathGateway = _MockPathGateway();
    final dir = Directory.systemTemp.createTempSync('shareable_data_test')..path;
    when(() => pathGateway.getBaseDir()).thenAnswer((_) async => dir.path);
    objectboxGateway = ObjectBoxGateway(pathGateway);
    await objectboxGateway.connect();
    contentRepository = ContentRepositoryImpl(objectboxGateway);

    boxContentText = objectboxGateway.getConnector()!.box<ContentTextEntity>();
    boxContentLink = objectboxGateway.getConnector()!.box<ContentLinkEntity>();
    boxContentMedia = objectboxGateway.getConnector()!.box<ContentMediaEntity>();
  });

  setUp(() {
    boxContentText.removeAll();
    boxContentLink.removeAll();
    boxContentMedia.removeAll();

    currentTextContents = boxContentText.getAll();
    currentLinkContents = boxContentLink.getAll();
    currentMediaContents = boxContentMedia.getAll();

    expect(currentTextContents.isEmpty, true, reason: "Empty on start");
    expect(currentLinkContents.isEmpty, true, reason: "Empty on start");
    expect(currentMediaContents.isEmpty, true, reason: "Empty on start");
  });

  tearDownAll(() async {
    boxContentText.removeAll();
    boxContentLink.removeAll();
    boxContentMedia.removeAll();
    await objectboxGateway.disconnect();
  });

  test("ContentRepository: Récupération de la liste des contenus sans options. Aucune données en DB.", () async {
    final contents = await contentRepository.findMany();
    expect(contents.length, 0);
  });

  test(
    "ContentRepository: Récupération de la liste des contenus sans options. Quelques données de chaque type de contenu en DB.",
    () async {
      boxContentText.put(
        ContentTextEntity(
          id: Uuid().v4(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          authorName: "authorName",
          flowName: "flowName",
          bounces: 0,
          title: "title",
          text: "text",
        ),
      );
      boxContentLink.put(
        ContentLinkEntity(
          id: Uuid().v4(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          authorName: "authorName",
          flowName: "flowName",
          bounces: 0,
          title: "title",
          ref: "_https://linktosomewhere",
          description: "",
        ),
      );
      boxContentMedia.put(
        ContentMediaEntity(
          id: Uuid().v4(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          authorName: "authorName",
          flowName: "flowName",
          bounces: 0,
          title: "title",
          path: "path/to/somewhere",
          description: "description",
        ),
      );
      final contents = await contentRepository.findMany();
      expect(contents.length, 3);
    },
  );

  test("ContentRepository: Récupération d'une liste de contenu limité.", () async {
    final List<ContentTextEntity> contents = [];
    for (var i = 0; i < 20; i++) {
      contents.add(
        ContentTextEntity(
          id: Uuid().v4(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          authorName: 'author_$i',
          flowName: 'flow_$i',
          bounces: 0,
          title: 'title_$i',
          text: 'text content $i',
        ),
      );
    }
    boxContentText.putMany(contents);
    final res1 = await contentRepository.findMany(limit: 10);
    expect(res1.length, 10);

    expect(boxContentText.removeAll(), 20);
    final List<ContentTextEntity> contents2 = [];
    for (var i = 0; i < 8; i++) {
      contents2.add(
        ContentTextEntity(
          id: Uuid().v4(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          authorName: 'author_$i',
          flowName: 'flow_$i',
          bounces: 0,
          title: 'title_$i',
          text: 'text content $i',
        ),
      );
    }

    boxContentText.putMany(contents2);
    final res2 = await contentRepository.findMany(limit: 10);
    expect(res2.length, 8);
  });

  test("ContentRepository: Récupération d'une liste en fonction du timming.", () async {
    final id = Uuid().v4();
    boxContentText.put(
      ContentTextEntity(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch - 100_000,
        authorName: "authorName",
        flowName: "flowName",
        bounces: 0,
        title: "title",
        text: "text",
      ),
    );

    final res1 = await contentRepository.findMany(minTime: 10_000);
    expect(res1.length, 0);

    final res2 = await contentRepository.findMany(minTime: 200_000);
    expect(res2.length, 1);
  });

  test("ContentRepository: Récupération d'une liste en fonction des flows.", () async {
    final id = Uuid().v4();
    boxContentText.put(
      ContentTextEntity(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch - 100_000,
        authorName: "authorName",
        flowName: "normal",
        bounces: 0,
        title: "title",
        text: "text",
      ),
    );

    final res1 = await contentRepository.findMany(flows: ["important", "useless"]);
    expect(res1.length, 0);

    final res2 = await contentRepository.findMany(flows: ["normal"]);
    expect(res2.length, 1);

    final res3 = await contentRepository.findMany(flows: ["normal", "important"]);
    expect(res3.length, 1);
  });

  test("ContentRepository: Récupération d'une liste avec filtrage complet.", () async {
    final id = Uuid().v4();
    boxContentText.put(
      ContentTextEntity(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch - 100_000,
        authorName: "authorName",
        flowName: "normal",
        bounces: 0,
        title: "title",
        text: "text",
      ),
    );

    final res1 = await contentRepository.findMany(flows: ["useless"], minTime: 10_000);
    expect(res1.length, 0);

    final res2 = await contentRepository.findMany(flows: ["useless"], minTime: 200_000);
    expect(res2.length, 0);

    final res3 = await contentRepository.findMany(flows: ["normal"], minTime: 10_000);
    expect(res3.length, 0);

    final res4 = await contentRepository.findMany(flows: ["normal"], minTime: 200_000);
    expect(res4.length, 1);
  });

  test("ContentRepository: placeholdertest", () {});
}

class _MockPathGateway extends Mock implements PathGateway {}
