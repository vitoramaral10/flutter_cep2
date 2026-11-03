/// Why a ZIP code lookup failed.
enum CepErrorType {
  /// The input does not have 8 digits; no request was sent.
  invalidFormat,

  /// ViaCEP has no address for the ZIP code.
  notFound,

  /// ViaCEP answered with a status other than 200.
  http,

  /// No answer within the configured timeout.
  timeout,

  /// The request could not be sent (no connection, DNS, TLS...).
  network,

  /// The body could not be read as a ViaCEP answer.
  invalidResponse,

  /// Not set; used by exceptions created outside this package.
  unknown,
}

/// Exception thrown when a ZIP code lookup fails.
class CepException implements Exception {
  /// The error message.
  final String message;

  /// Why the lookup failed.
  final CepErrorType type;

  /// Creates a new [CepException] with the given [message] and [type].
  const CepException(this.message, {this.type = CepErrorType.unknown});

  @override
  String toString() => 'CepException: $message';
}
