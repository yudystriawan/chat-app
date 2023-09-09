import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/chat/domain/usecases/get_members.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/entities/entity.dart';

part 'member_watcher_bloc.freezed.dart';
part 'member_watcher_event.dart';
part 'member_watcher_state.dart';

@injectable
class MemberWatcherBloc extends Bloc<MemberWatcherEvent, MemberWatcherState> {
  final GetMembers _getMembers;

  StreamSubscription<Either<Failure, KtList<Member>>>?
      _membersStreamSubscription;

  MemberWatcherBloc(
    this._getMembers,
  ) : super(MemberWatcherState.initial()) {
    on<_WatchAllStarted>(_onWatchAllStarted);
    on<_MembersReceived>(_onMembersReceived);
  }

  void _onWatchAllStarted(
    _WatchAllStarted event,
    Emitter<MemberWatcherState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _membersStreamSubscription?.cancel();
    _membersStreamSubscription =
        _getMembers(GetMembersParams(ids: event.memberIds)).listen(
            (failureOrMembers) =>
                add(MemberWatcherEvent.membersReceived(failureOrMembers)));
  }

  void _onMembersReceived(
    _MembersReceived event,
    Emitter<MemberWatcherState> emit,
  ) async {
    final newState = state.copyWith(
      isLoading: false,
      failureOption: none(),
    );

    emit(event.failureOrMembers.fold(
      (f) => newState.copyWith(failureOption: optionOf(f)),
      (members) => newState.copyWith(members: members),
    ));
  }
}
