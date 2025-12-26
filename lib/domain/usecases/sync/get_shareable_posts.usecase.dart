import 'dart:convert';
import 'package:poc_street_path/core/globals.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/content/comment.model.dart';
import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/reaction.model.dart';
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
      final List<Map<String, Object>> data = [];
      final List<Content> contents = [];

      contents.addAll(await _contentRepository.findMany(maxSync, 0, shippingModes: [ShippingMode.creator]));

      if (contents.length < 10) {
        contents.addAll(
          await _contentRepository.findMany(
            maxSync - contents.length,
            0,
            createdWhile: defaultDbDataTime,
            shippingModes: [ShippingMode.important],
          ),
        );
      }

      if (contents.length < 10) {
        contents.addAll(
          await _contentRepository.findMany(maxSync - contents.length, 0, shippingModes: [ShippingMode.normal]),
        );
      }

      for (final content in contents) {
        final res = await Future.wait([
          _commentRepository.findFromContent(content.id),
          _reactionRepository.findFromContent(content.id),
        ]);
        data.addAll([
          content.toRaw(),
          ...(res[0] as List<Comment>).map((elem) => elem.toRaw()),
          ...(res[1] as List<Reaction>).map((elem) => elem.toRaw()),
        ]);
      }

      return Success(jsonEncode(data));
    } catch (err, stack) {
      SpLog().e('GetShareablePosts: Une exception a été levée.', err, stack: stack);
      return Failure(FailureCode.databaseFailure);
    }
  }
}

class GetShareableContentsParams {
  GetShareableContentsParams();
}
