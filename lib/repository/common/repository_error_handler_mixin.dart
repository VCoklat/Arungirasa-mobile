import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import 'exception.dart';

mixin RepositoryErrorHandlerMixin on GetConnect {
  getException<T>( final Response<T> response ) {
    switch( response.status.code ) {
      case HttpStatus.badRequest:
        return new HttpBadRequestException(
          statusText: response.statusText,
          errorBody: response.bodyString,
        );
      case HttpStatus.notFound:
        return new HttpNotFoundException(
          statusText: response.statusText,
          errorBody: response.bodyString,
        );
      case HttpStatus.unauthorized:
        return new HttpUnauthorizedException(
          statusText: response.statusText,
          errorBody: response.bodyString,
        );
      case HttpStatus.conflict:
        return new HttpConflictException(
          statusText: response.statusText,
          errorBody: response.bodyString,
        );
      default: {
        if ( response.status.connectionError ) {
          return new HttpConnectionError( response.statusText );
        } else {
          return new HttpException(
            code: HttpStatus.notFound,
            statusText: response.statusText,
            errorBody: response.bodyString,
          );
        }
      }
    }
  }
}