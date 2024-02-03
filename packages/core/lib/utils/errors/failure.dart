import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError({int? code, String? message}) =
      _ServerError;
  const factory Failure.unexpectedError() = _UnexpectedError;
  const factory Failure.canceledByUser() = _CanceledByUser;
  const factory Failure.unauthenticated() = _Unauthenticated;
  const factory Failure.notFound() = _NotFound;
  const factory Failure.invalidParameter({String? message}) = _InvalidParameter;
}
