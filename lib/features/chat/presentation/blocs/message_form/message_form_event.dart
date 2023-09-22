part of 'message_form_bloc.dart';

@freezed
class MessageFormEvent with _$MessageFormEvent {
  const factory MessageFormEvent.initialized(Message initialMessage) =
      _Initialized;
  const factory MessageFormEvent.dataChanged(String dataStr) = _DataChanged;
  const factory MessageFormEvent.imageFileChanged(File? file) =
      _ImageFileChanged;
  const factory MessageFormEvent.submitted(String roomId) = _Submitted;
}
