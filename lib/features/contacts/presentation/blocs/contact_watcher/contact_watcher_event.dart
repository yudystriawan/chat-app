part of 'contact_watcher_bloc.dart';

@freezed
class ContactWatcherEvent with _$ContactWatcherEvent {
  const factory ContactWatcherEvent.watchAllStarted({
    String? username,
  }) = _WatchAllStarted;
  const factory ContactWatcherEvent.contactsReceived(
      Either<Failure, KtList<Contact>> failureOrContacts) = _ContactsReceived;
}
