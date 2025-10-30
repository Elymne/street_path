import 'package:flutter/foundation.dart';
import 'package:poc_street_path/core/globals.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:poc_street_path/domain/repositories/reaction.repository.dart';

class GetShareableContents extends Usecase<GetShareableContentsParams, String> {
  final ContentRepository _contentRepository;
  final CommentRepository _commentRepository;
  final ReactionRepository _reactionRepository;

  GetShareableContents(this._contentRepository, this._commentRepository, this._reactionRepository);

  @override
  Future<Result<String>> execute(GetShareableContentsParams params) async {
    try {
      final List<Content> contents = [];

      contents.addAll(await _contentRepository.findMany(10, 1, shippingModes: [ShippingMode.creator], orderBy: [ContentOrderBy.newest]));

      if (contents.length < 10) {
        contents.addAll(
          await _contentRepository.findMany(
            10 - contents.length,
            1,
            createdWhile: defaultDbDataTime,
            shippingModes: [ShippingMode.important],
            orderBy: [ContentOrderBy.newest],
          ),
        );
      }

      if (contents.length < 10) {
        contents.addAll(
          await _contentRepository.findMany(
            10 - contents.length,
            1,
            shippingModes: [ShippingMode.normal],
            orderBy: [ContentOrderBy.newest],
          ),
        );
      }

      for (final content in contents) {
        if (kDebugMode) {
          print(content);
        }
      }

      return Success('');
    } catch (err, stack) {
      SpLog().e('GetShareablePosts: Une exception a été levée.', err, stack: stack);
      return Failure("Une erreur s'est produite en voulant récupérer les posts partageables…");
    }
  }
}

class GetShareableContentsParams {
  GetShareableContentsParams();
}
