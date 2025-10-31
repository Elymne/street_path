import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/content_text.model.dart';
import 'package:poc_street_path/domain/repositories/content.repository.dart';
import 'package:uuid/uuid.dart';

class AddContentText extends Usecase<AddContentTextParams, bool> {
  final ContentRepository _contentRepository;

  AddContentText(this._contentRepository);

  @override
  Future<Result<bool>> execute(AddContentTextParams params) async {
    try {
      final newContent = ContentText(
        id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        authorName: params.authorName,
        bounces: 0,
        flowName: params.flowName,
        title: params.title,
        storageMode: StorageMode.save,
        shippingMode: ShippingMode.creator,
        text: params.text,
      );

      await _contentRepository.insert(newContent);

      return Success(true);
    } catch (err, stack) {
      SpLog().e('AddRawData: Une exception a été levée.', err, stack: stack);
      return Failure("Une erreur s'est produite lors de l'ajout d'une données brute.");
    }
  }
}

class AddContentTextParams {
  final String authorName;
  final String flowName;
  final String title;
  final String text;
  AddContentTextParams(this.authorName, this.flowName, this.title, this.text);
}
