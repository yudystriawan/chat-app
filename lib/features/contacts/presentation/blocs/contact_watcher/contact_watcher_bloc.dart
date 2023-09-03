import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/contacts/domain/usecases/watch_contacts.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/entities/contact.dart';

part 'contact_watcher_bloc.freezed.dart';
part 'contact_watcher_event.dart';
part 'contact_watcher_state.dart';

@injectable
class ContactWatcherBloc
    extends Bloc<ContactWatcherEvent, ContactWatcherState> {
  final WatchContacts _watchContacts;

  StreamSubscription<Either<Failure, KtList<Contact>>>?
      _contactStreamSubsctipion;

  ContactWatcherBloc(this._watchContacts)
      : super(const ContactWatcherState.initial()) {
    on<_WatchAllStarted>(_onWatchAllStarted);
    on<_ContactsReceived>(_onContactsReceived);
  }

  void _onWatchAllStarted(
    _WatchAllStarted event,
    Emitter<ContactWatcherState> emit,
  ) async {
    emit(const ContactWatcherState.loadInProgress());
    await _contactStreamSubsctipion?.cancel();
    _contactStreamSubsctipion = _watchContacts(const NoParams()).listen(
        (contacts) => add(ContactWatcherEvent.contactsReceived(contacts)));
  }

  void _onContactsReceived(
    _ContactsReceived event,
    Emitter<ContactWatcherState> emit,
  ) async {
    emit(event.failureOrContacts.fold(
      (f) => ContactWatcherState.loadFailure(f),
      (contacts) => ContactWatcherState.loadSuccess(contacts),
    ));
  }
}
