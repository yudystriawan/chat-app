part of 'contact_loader_bloc.dart';

@freezed
class ContactLoaderEvent with _$ContactLoaderEvent {
  const factory ContactLoaderEvent.fetched(String username) = _Fetched;
}
