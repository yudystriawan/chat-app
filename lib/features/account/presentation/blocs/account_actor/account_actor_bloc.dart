import 'package:bloc/bloc.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/set_online_status.dart';

part 'account_actor_bloc.freezed.dart';
part 'account_actor_event.dart';
part 'account_actor_state.dart';

@injectable
class AccountActorBloc extends Bloc<AccountActorEvent, AccountActorState> {
  final SetOnlineStatus _setOnlineStatus;

  AccountActorBloc(
    this._setOnlineStatus,
  ) : super(const AccountActorState.initial()) {
    on<_OnlineStatusChanged>(_onOnlineStatusChanged);
  }
  void _onOnlineStatusChanged(
    _OnlineStatusChanged event,
    Emitter<AccountActorState> emit,
  ) async {
    final failureOrSuccess = await _setOnlineStatus
        .call(SetOnlineStatusParams(onlineStatus: event.status));

    emit(failureOrSuccess.fold(
      (f) => AccountActorState.actionFailure(f),
      (_) => const AccountActorState.actionSuccess(),
    ));
  }
}
