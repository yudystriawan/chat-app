import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';

@injectable
class AddRoom implements Usecase<String, CreateRoomParams> {
  final ChatRepository _repository;

  AddRoom(this._repository);

  @override
  Future<Either<Failure, String>> call(params) {
    return _repository.addRoom(
      members: params.members,
      type: params.type.value,
    );
  }
}

class CreateRoomParams extends Equatable {
  final KtList<String> members;
  final RoomType type;

  const CreateRoomParams({
    required this.members,
    required this.type,
  });

  @override
  List<Object> get props => [members, type];
}
