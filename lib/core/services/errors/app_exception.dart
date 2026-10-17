/// An expected application error, converted to Failure by requestHandler.
class AppException implements Exception {
  const AppException({required this.message, required this.code});

  final String message;
  final String code;
}
