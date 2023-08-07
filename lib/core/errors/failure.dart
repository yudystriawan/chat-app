import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError({int? code, String? message}) =
      _ServerError;
  const factory Failure.unexpectedError() = _UnexpectedError;
}
