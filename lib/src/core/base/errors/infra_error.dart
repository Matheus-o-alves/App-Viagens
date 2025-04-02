class ServerException implements Exception {
  final String message;
  final int statusCode;

  const ServerException({required this.message, required this.statusCode});
}

class ConnectionException implements Exception {
  final String message;

  const ConnectionException({required this.message});
}
