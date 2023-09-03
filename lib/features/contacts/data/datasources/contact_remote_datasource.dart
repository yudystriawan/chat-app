import 'package:core/core.dart';
import 'package:core/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';

import '../models/contact_dtos.dart';

abstract class ContactRemoteDataSource {
  Stream<List<ContactDto>?> watchContacts();
}

@Injectable(as: ContactRemoteDataSource)
class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final FirestoreService _service;

  ContactRemoteDataSourceImpl(this._service);
  @override
  Stream<List<ContactDto>?> watchContacts() {
    return _service.instance.userCollection.snapshots().map((snapshot) =>
        snapshot.docs
            .map((e) => ContactDto.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }
}
