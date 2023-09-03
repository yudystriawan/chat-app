part of 'contact_loader_bloc.dart';

@freezed
class ContactLoaderState with _$ContactLoaderState {
  const factory ContactLoaderState.initial() = _Initial;
  const factory ContactLoaderState.loadInProgress() = _LoadInProgress;
  const factory ContactLoaderState.loadFailure(Failure failure) = _LoadFailure;
  const factory ContactLoaderState.loadSuccess(Contact contact) = _LoadSuccess;
}
