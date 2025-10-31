import 'dart:convert';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/core/utils/json_utils.dart';
import 'package:poc_street_path/domain/models/content/comment.model.dart';
import 'package:poc_street_path/domain/models/content/content_link.model.dart';
import 'package:poc_street_path/domain/models/content/content_media.model.dart';
import 'package:poc_street_path/domain/models/content/content_text.model.dart';
import 'package:poc_street_path/domain/models/content/reaction.model.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/domain/repositories/raw_data.repository.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';

class SyncPost extends Usecase<SyncPostParams, int> {
  final RawDataRepository _rawDataRepository;
  final ContentRepository _contentRepository;
  final CommentRepository _commentRepository;
  final ReactionRepository _reactionRepository;

  SyncPost(this._rawDataRepository, this._contentRepository, this._commentRepository, this._reactionRepository);

  @override
  Future<Result<int>> execute(SyncPostParams params) async {
    try {
      int count = 0;

      final rawDataList = await _rawDataRepository.findAll();

      for (final rawData in rawDataList) {
        final jsonList = jsonDecode(rawData.data);
        // * Les contenus transférés sont toujours contenu dans des listes, même si il n'y a qu'une valeur.
        if (jsonList is! List) {
          continue;
        }

        for (final json in jsonList) {
          // * Check [ContentText]
          if (isValidJson(json, ContentText.allowed)) {
            if (await _contentRepository.exists(json['id'])) {
              continue;
            }
            await _contentRepository.insert(ContentText.fromJson(json));
            count++;
          }

          // * Check [ContentLink]
          if (isValidJson(json, ContentLink.allowed)) {
            if (await _contentRepository.exists(json['id'])) {
              continue;
            }
            // TODO: Vérif de la provenance du lien, et si il est bien construit.
            // Possibilité de gestion d'une blacklist de sites imo pour l'utilisateur.
            await _contentRepository.insert(ContentLink.fromJson(json));
            count++;
          }

          // * Check [ContentMedia]
          if (isValidJson(json, ContentMedia.allowed)) {
            if (await _contentRepository.exists(json['id'])) {
              continue;
            }
            // TODO: Vérif du média, de son type, et de son enregistrement sur le tel.
            await _contentRepository.insert(ContentMedia.fromJson(json));
            count++;
          }

          // * Check [Comment]
          if (isValidJson(json, Comment.allowed)) {
            if (await _commentRepository.exists(json['id'])) {
              continue;
            }
            await _commentRepository.insert(Comment.fromJson(json));
            count++;
          }

          // * Check [Reaction]
          if (isValidJson(json, Reaction.allowed)) {
            if (await _reactionRepository.exists(json['id'])) {
              continue;
            }
            await _reactionRepository.insert(Reaction.fromJson(json));
            count++;
          }
        }
      }

      // * Suppression des données brutes.
      await _rawDataRepository.clear();

      return Success(count);
    } catch (err, stack) {
      SpLog().e('SyncPost: Une exception a été levée.', err, stack: stack);
      return Failure("Une erreur s'est produite lors de la synchronisation des données BLE/WIFI…");
    }
  }
}

class SyncPostParams {}
