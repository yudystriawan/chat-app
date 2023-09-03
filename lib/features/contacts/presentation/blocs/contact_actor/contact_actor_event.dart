part of 'contact_actor_bloc.dart';

@freezed
class ContactActorEvent with _$ContactActorEvent {
  const factory ContactActorEvent.contactAdded(String username) = _ContactAdded;
}
