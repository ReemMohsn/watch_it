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
    if (kDebugMode) {
      debugPrintStack(
        label: AppStrings.requestFailed(error.runtimeType),
        stackTrace: stackTrace,
      );
    }

    return Left<Failure, T>(SupabaseErrorMapper.map(error));
  }
}
