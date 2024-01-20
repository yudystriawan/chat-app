import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/add_contact.dart';

part 'contact_actor_bloc.freezed.dart';
part 'contact_actor_event.dart';
part 'contact_actor_state.dart';

@injectable
class ContactActorBloc extends Bloc<ContactActorEvent, ContactActorState> {
  final AddContact _addContact;

  ContactActorBloc(
    this._addContact,
  ) : super(const ContactActorState.initial()) {
    on<_ContactAdded>(_onContactAdded);
  }

  void _onContactAdded(
    _ContactAdded event,
    Emitter<ContactActorState> emit,
  ) async {
    emit(const ContactActorState.actionInProgress());

    final failureOrSuccess =
        await _addContact(AddContactParams(username: event.username));

    emit(failureOrSuccess.fold(
      (f) => ContactActorState.actionFailure(f),
      (_) => const ContactActorState.addContactSuccess(),
    ));
  }
}
