class HttpConnectionError implements Exception {
  final String? message;
  const HttpConnectionError( this.message );
  @override String toString() => message ?? "HttpConnectionError: Unknown Error";
}

class HttpException implements Exception {
  final String message;
  const HttpException({ required final int code, final String? statusText, final String? errorBody }) : message = "$code: $statusText, $errorBody";
  @override String toString() => message;
}

class HttpBadRequestException extends HttpException {
  const HttpBadRequestException({ final String? statusText, final String? errorBody, }) : super(
    code: 400,
    statusText: statusText,
    errorBody: errorBody,
  );
}

class HttpConflictException extends HttpException {
  const HttpConflictException({ final String? statusText, final String? errorBody, }) : super(
    code: 409,
    statusText: statusText,
    errorBody: errorBody,
  );
}

class HttpNotFoundException extends HttpException {
  const HttpNotFoundException({ final String? statusText, final String? errorBody, }) : super(
    code: 404,
    statusText: statusText,
    errorBody: errorBody,
  );
}

class HttpUnauthorizedException extends HttpException {
  const HttpUnauthorizedException({ final String? statusText, final String? errorBody, }) : super(
    code: 401,
    statusText: statusText,
    errorBody: errorBody,
  );
}
