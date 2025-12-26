/// Classe à n'utiliser que dans les usecases.
abstract class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final FailureCode code;
  final StackTrace? stackTrace;
  final Object? cause;
  const Failure(this.code, {this.stackTrace, this.cause});
}

/// Liste de tous les types d'erreurs possible à travers l'utilisation d'un Usecase.
enum FailureCode { unknown, databaseFailure, serviceFailure, invalidData, notFound, wrongUsage }
