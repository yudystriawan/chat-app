import 'package:bloc/bloc.dart';
import 'package:chat_app/features/account/domain/usecases/remove_account.dart';
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
  final RemoveAccount _removeAccount;

  AccountActorBloc(
    this._setOnlineStatus,
    this._removeAccount,
  ) : super(const AccountActorState.initial()) {
    on<_OnlineStatusChanged>(_onOnlineStatusChanged);
    on<_AccountRemoved>(_onAccountRemoved);
  }
  void _onOnlineStatusChanged(
    _OnlineStatusChanged event,
    Emitter<AccountActorState> emit,
  ) async {
    final failureOrSuccess = await _setOnlineStatus(
      SetOnlineStatusParams(onlineStatus: event.status),
    );

    emit(failureOrSuccess.fold(
      (f) => AccountActorState.actionFailure(f),
      (_) => const AccountActorState.actionSuccess(),
    ));
  }

  void _onAccountRemoved(
    _AccountRemoved event,
    Emitter<AccountActorState> emit,
  ) async {
    final failureOrSuccess = await _removeAccount(
      RemoveAccountParams(event.accountId),
    );

    emit(failureOrSuccess.fold(
      (f) => AccountActorState.actionFailure(f),
      (_) => const AccountActorState.actionSuccess(),
    ));
  }
}
