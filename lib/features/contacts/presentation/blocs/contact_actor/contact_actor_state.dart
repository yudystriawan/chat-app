part of 'contact_actor_bloc.dart';

@freezed
class ContactActorState with _$ContactActorState {
  const factory ContactActorState.initial() = _Initial;
  const factory ContactActorState.actionInProgress() = _ActionInProgress;
  const factory ContactActorState.actionFailure(Failure failure) =
      _ActionFailure;
  const factory ContactActorState.addContactSuccess() = _AddContactSuccess;
}
