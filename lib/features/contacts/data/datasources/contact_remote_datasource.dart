import 'package:core/core.dart';
import 'package:core/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:core/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';

import '../models/contact_dtos.dart';

abstract class ContactRemoteDataSource {
  Stream<List<ContactDto>?> watchContacts({
    String? username,
  });
}

@Injectable(as: ContactRemoteDataSource)
class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final FirestoreService _service;
  final AuthRemoteDataSource _remoteDataSource;

  ContactRemoteDataSourceImpl(this._service, this._remoteDataSource);
  @override
  Stream<List<ContactDto>?> watchContacts({String? username}) async* {
    final currentUser = await _remoteDataSource.getCurrentUser();

    final query = _service.instance.userCollection
        .where('id', isNotEqualTo: currentUser?.id);

    if (username != null) {
      query.where('username', isEqualTo: username);
    }

    yield* query.snapshots().map((snapshot) => snapshot.docs
        .map((e) => ContactDto.fromJson(e.data() as Map<String, dynamic>))
        .toList());
  }
}
