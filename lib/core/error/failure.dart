/// Base class for all failures in the application
/// Uses equatable for proper comparison in tests
abstract class Failure extends Equatable {
  const Failure({required this.message});

  /// Human-readable error message
  final String message;

  @override
  List<Object> get props => [message];
}

/// Failure thrown when server returns an error
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Failure thrown when cache operations fail
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure thrown when network is unavailable
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}