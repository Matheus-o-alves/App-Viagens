abstract class Failure {
  final String message;
  
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  final int statusCode;
  
  const ServerFailure({
    required String message,
    this.statusCode = 500,
  }) : super(message: message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.message});
}

class GenericFailure extends Failure {
  final Object error;
  
   GenericFailure({required this.error}) 
    : super(message: error.toString());
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}
