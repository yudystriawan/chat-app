part of 'contact_watcher_bloc.dart';

@freezed
class ContactWatcherState with _$ContactWatcherState {
  const factory ContactWatcherState.initial() = _Initial;
  const factory ContactWatcherState.loadInProgress() = _LoadInProgress;
  const factory ContactWatcherState.loadFailure(Failure failure) = _LoadFailure;
  const factory ContactWatcherState.loadSuccess(KtList<Contact> contacts) =
      _LoadSuccess;
}
