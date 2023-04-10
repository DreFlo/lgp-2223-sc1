//create an exception subclass
class DatabaseOperationWithoutId implements Exception {
  final String message;
  DatabaseOperationWithoutId(this.message);
}

class DatabaseOperationWithId implements Exception {
  final String message;
  DatabaseOperationWithId(this.message);
}
