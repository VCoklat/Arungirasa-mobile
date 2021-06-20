import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

class ErrorReporter {
  static final _reporter = ErrorReporter._internal();

  static ErrorReporter get instance => _reporter;

  ErrorReporter._internal();

  void captureException( final dynamic exception, [ final StackTrace? stackTrace, ] ) {
    if (kReleaseMode) {
      if (exception is MissingRequiredKeysException ||
          exception is DisallowedNullValueException) {
        FirebaseCrashlytics.instance.recordError(
          new Exception( exception.message ),
          stackTrace ?? StackTrace.current,
        );
      } else {
        FirebaseCrashlytics.instance.recordError(exception, stackTrace ?? StackTrace.current );
      }
    } else {
      if (exception is MissingRequiredKeysException ||
          exception is DisallowedNullValueException) {
        print(exception.message);
      } else {
        print(exception);
        print(stackTrace);
      }
    }
  }

  void setUserContext( final User user ) => FirebaseCrashlytics.instance.setUserIdentifier( user.uid );
}