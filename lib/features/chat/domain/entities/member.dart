part of 'entity.dart';

@freezed
class Member with _$Member {
  const Member._();
  const factory Member({
    required String name,
    required String imageUrl,
    required String id,
  }) = _Member;

  factory Member.empty() => const Member(
        name: '',
        imageUrl: '',
        id: '',
      );
}
