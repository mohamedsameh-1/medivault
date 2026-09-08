abstract class Failure {
  final String failureMessage;
  const Failure({required this.failureMessage});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.failureMessage});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.failureMessage});
}
