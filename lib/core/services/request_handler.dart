import 'dart:async';

import 'package:e_learning/core/constants/app_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:e_learning/core/services/errors/failure.dart';
import 'package:e_learning/core/services/errors/supabase_error_mapper.dart';
import 'package:flutter/foundation.dart';

Future<Either<Failure, T>> requestHandler<T>(
  Future<T> Function() request,
) async {
  try {
    final data = await request();
    return Right<Failure, T>(data);
  } catch (error, stackTrace) {
    return Left<Failure, T>(_mapFailure(error, stackTrace));
  }
}

Stream<Either<Failure, T>> requestStreamHandler<T>(Stream<T> request) =>
    request.transform(
      StreamTransformer<T, Either<Failure, T>>.fromHandlers(
        handleData: (data, sink) => sink.add(Right<Failure, T>(data)),
        handleError: (error, stackTrace, sink) =>
            sink.add(Left<Failure, T>(_mapFailure(error, stackTrace))),
      ),
    );

Failure _mapFailure(Object error, StackTrace stackTrace) {
  final failure = SupabaseErrorMapper.map(error);
  if (kDebugMode) {
    debugPrintStack(
      label:
          '${AppStrings.requestFailed(error.runtimeType)} '
          '[${failure.code ?? 'unknown'}]',
      stackTrace: stackTrace,
    );
  }
  return failure;
}
