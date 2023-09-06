import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'room.freezed.dart';

enum RoomType {
  nan(0),
  private(1),
  group(2);

  final int value;
  const RoomType(this.value);

  factory RoomType.fromValue(int? value) =>
      RoomType.values.singleWhereOrNull((element) => element.value == value) ??
      RoomType.nan;
}

@freezed
class Room with _$Room {
  const Room._();
  const factory Room({
    required String id,
    required KtList<String> userId,
    required String createdBy,
    required RoomType type,
    DateTime? createdAt,
  }) = _Room;

  factory Room.empty() => const Room(
        id: '',
        userId: KtList.empty(),
        createdBy: '',
        type: RoomType.nan,
      );
}
