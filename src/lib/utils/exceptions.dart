//create an exception subclass
class DatabaseOperationWithoutId implements Exception {
  final String message;
  DatabaseOperationWithoutId(this.message);
}
