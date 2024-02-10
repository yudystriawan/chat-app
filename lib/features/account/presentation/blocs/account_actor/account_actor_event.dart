part of 'account_actor_bloc.dart';

@freezed
class AccountActorEvent with _$AccountActorEvent {
  const factory AccountActorEvent.onlineStatusChanged(bool status) =
      _OnlineStatusChanged;
  const factory AccountActorEvent.accountRemoved(String accountId) =
      _AccountRemoved;
}
