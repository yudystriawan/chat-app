import 'package:bloc/bloc.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/contact.dart';
import '../../../domain/usecases/find_contact.dart';

part 'contact_loader_bloc.freezed.dart';
part 'contact_loader_event.dart';
part 'contact_loader_state.dart';

@injectable
class ContactLoaderBloc extends Bloc<ContactLoaderEvent, ContactLoaderState> {
  final FindContact _findContact;

  ContactLoaderBloc(
    this._findContact,
  ) : super(const ContactLoaderState.initial()) {
    on<_Fetched>(_onFetched);
  }

  void _onFetched(
    _Fetched event,
    Emitter<ContactLoaderState> emit,
  ) async {
    emit(const ContactLoaderState.loadInProgress());

    final failureOrContact =
        await _findContact(FindContactParams(username: event.username));

    emit(failureOrContact.fold(
      (f) => ContactLoaderState.loadFailure(f),
      (contact) => ContactLoaderState.loadSuccess(contact),
    ));
  }
}
