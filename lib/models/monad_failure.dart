sealed class MonadFailure {}

class TypesMismatchFailure extends MonadFailure {
  final String expected;
  final String actual;

  TypesMismatchFailure({required this.expected, required this.actual});
}
