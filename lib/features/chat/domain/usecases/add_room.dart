import '../reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';

@injectable
class AddRoom implements Usecase<String, AddRoomParams> {
  final ChatRepository _repository;

  AddRoom(this._repository);

  @override
  Future<Either<Failure, String>> call(params) async {
    if (params.hasFailure) {
      return left(params.failure!);
    }

    if (params.membersIds.size > 2 && params.type.isPrivate) {
      return left(
          const Failure.invalidParameter(message: 'Must be a group type'));
    }

    return _repository.addRoom(
      membersIds: params.membersIds,
      type: params.type.value,
    );
  }
}

class AddRoomParams extends Equatable {
  final KtList<String> membersIds;
  final RoomType type;

  const AddRoomParams({
    required this.membersIds,
    required this.type,
  });

  Failure? get failure {
    if (type == RoomType.nan) {
      return const Failure.invalidParameter(message: 'RoomType must be set');
    }

    if (membersIds.isEmpty()) {
      return const Failure.invalidParameter(
          message: 'MembersIds cannot be empty');
    }

    return null;
  }

  bool get hasFailure => failure != null;

  @override
  List<Object> get props => [membersIds, type];
}
