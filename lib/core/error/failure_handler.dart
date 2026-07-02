/// Base failure class for all error handling
abstract class Failure {
  final String message;
  
  Failure({required this.message});
}

/// Network-related failures
class NetworkFailure extends Failure {
  NetworkFailure({String message = 'Network error occurred'})
      : super(message: message);
}

/// Timeout failures
class TimeoutFailure extends Failure {
  TimeoutFailure({String message = 'Request timeout'})
      : super(message: message);
}

/// Server-side failures
class ServerFailure extends Failure {
  final int? statusCode;
  
  ServerFailure({String message = 'Server error', this.statusCode})
      : super(message: message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  CacheFailure({String message = 'Cache error'})
      : super(message: message);
}

/// JSON parsing failures
class ParsingFailure extends Failure {
  ParsingFailure({String message = 'Failed to parse data'})
      : super(message: message);
}

/// Generic unknown failures
class UnknownFailure extends Failure {
  UnknownFailure({String message = 'Unknown error occurred'})
      : super(message: message);
}

/// Not found failures
class NotFoundFailure extends Failure {
  NotFoundFailure({String message = 'Resource not found'})
      : super(message: message);
}
