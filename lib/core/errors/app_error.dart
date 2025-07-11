abstract class AppError implements Exception {
  final String message;
  final dynamic cause;
  final StackTrace? stackTrace;

  AppError(this.message, {this.cause, this.stackTrace});

  @override
  String toString() {
    return 'AppError: $message${cause != null ? ', Cause: $cause' : ''}';
  }
}

class NetworkError extends AppError {
  final int? statusCode;

  NetworkError(
    String message, {
    this.statusCode,
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);

  @override
  String toString() {
    return 'NetworkError: $message${statusCode != null ? ', Status Code: $statusCode' : ''}${cause != null ? ', Cause: $cause' : ''}';
  }
}

class ServerError extends AppError {
  ServerError(
    String message, {
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}

class CacheError extends AppError {
  CacheError(
    String message, {
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}

class ValidationError extends AppError {
  final Map<String, String>? fieldErrors;

  ValidationError(
    String message, {
    this.fieldErrors,
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}

class UnauthorizedError extends AppError {
  UnauthorizedError({
    String message = 'Unauthorized access',
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}

class UnexpectedError extends AppError {
  UnexpectedError({
    String message = 'An unexpected error occurred',
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}

class NotFoundError extends AppError {
  NotFoundError(
    String message, {
    dynamic cause,
    StackTrace? stackTrace,
  }) : super(message, cause: cause, stackTrace: stackTrace);
}
