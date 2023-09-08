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

  bool get isPrivate => this == RoomType.private;
  bool get isGroup => this == RoomType.group;
}

@freezed
class Room with _$Room {
  const Room._();
  const factory Room({
    required String id,
    required KtList<String> members,
    required String createdBy,
    required RoomType type,
    DateTime? createdAt,
  }) = _Room;

  factory Room.empty() => const Room(
        id: '',
        members: KtList.empty(),
        createdBy: '',
        type: RoomType.nan,
      );
}
