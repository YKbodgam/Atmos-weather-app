/// Base failure class for all error handling
abstract class Failure {
  final String message;

  Failure({required this.message});
}

/// Network-related failures
class NetworkFailure extends Failure {
  NetworkFailure({super.message = 'Network error occurred'});
}

/// Timeout failures
class TimeoutFailure extends Failure {
  TimeoutFailure({super.message = 'Request timeout'});
}

/// Server-side failures
class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure({super.message = 'Server error', this.statusCode});
}

/// Cache-related failures
class CacheFailure extends Failure {
  CacheFailure({super.message = 'Cache error'});
}

/// JSON parsing failures
class ParsingFailure extends Failure {
  ParsingFailure({super.message = 'Failed to parse data'});
}

/// Generic unknown failures
class UnknownFailure extends Failure {
  UnknownFailure({super.message = 'Unknown error occurred'});
}

/// Not found failures
class NotFoundFailure extends Failure {
  NotFoundFailure({super.message = 'Resource not found'});
}
