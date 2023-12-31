import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firestore_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  QuerySnapshot,
  DocumentReference,
  DocumentSnapshot,
  SetOptions,
])
void main() {
  group('FirestoreService Tests', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
    late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
    late FirestoreService sut;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollectionReference = MockCollectionReference();
      mockDocumentReference = MockDocumentReference();
      mockQuerySnapshot = MockQuerySnapshot();
      mockDocumentSnapshot = MockDocumentSnapshot();
      sut = FirestoreService(mockFirestore);

      // Mock the behavior when calling methods on firestore instance
      when(mockFirestore.collection(argThat(isNotNull)))
          .thenAnswer((_) => mockCollectionReference);
      when(mockCollectionReference.doc(any))
          .thenAnswer((_) => mockDocumentReference);
      when(mockCollectionReference.snapshots(
              includeMetadataChanges:
                  argThat(isA<bool>(), named: 'includeMetadataChanges')))
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockDocumentReference.set(
        argThat(isA<Map<String, dynamic>>()),
      )).thenAnswer((_) async {});
      when(mockDocumentReference.snapshots(
              includeMetadataChanges:
                  argThat(isA<bool>(), named: 'includeMetadataChanges')))
          .thenAnswer((_) => Stream.value(mockDocumentSnapshot));
      when(mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);
    });

    test('watchAll returns a stream of lists', () {
      // Arrange
      const collectionPath = 'your_collection_path';

      // Act
      final result = sut.watchAll(collectionPath);

      // Assert
      expect(result, isA<Stream<List<Map<String, dynamic>>>>());
    });

    test('watch returns a stream of a map', () {
      // Arrange
      const collectionPath = 'your_collection_path';
      const docId = 'your_document_id';

      // Act
      final result = sut.watch(collectionPath, docId);

      // Assert
      expect(result, isA<Stream<Map<String, dynamic>?>>());
    });

    test('upsert calls set on the firestore collection', () async {
      // Arrange
      const collectionPath = 'your_collection_path';
      const docId = 'your_document_id';
      final data = {'key': 'value'};

      // Act
      await sut.upsert(collectionPath, docId, data);

      // Assert
      verify(mockDocumentReference.set(data, argThat(isA<SetOptions>())))
          .called(1);
    });

    test('delete calls delete on the firestore collection', () async {
      // Arrange
      const collectionPath = 'your_collection_path';
      const docId = 'your_document_id';

      // Act
      await sut.delete(collectionPath, docId);

      // Assert
      verify(mockDocumentReference.delete()).called(1);
    });

    test('checkIfExist returns true if document exists', () async {
      // Arrange
      const collectionPath = 'your_collection_path';
      const docId = 'existing_document_id';

      // Mocking the Firestore snapshot result
      when(mockDocumentSnapshot.exists).thenAnswer((_) => true);

      // Act
      final result = await sut.checkIfExist(collectionPath, docId);

      // Assert
      expect(result, true);
    });

    test('checkIfExist returns false if document does not exist', () async {
      // Arrange
      const collectionPath = 'your_collection_path';
      const docId = 'non_existing_document_id';

      // Mocking the Firestore snapshot result
      when(mockDocumentSnapshot.exists).thenAnswer((_) => false);

      // Act
      final result = await sut.checkIfExist(collectionPath, docId);

      // Assert
      expect(result, false);
    });

    test('generateId returns a non-null string', () {
      // Act
      final generatedId = sut.generateId();

      // Assert
      expect(generatedId, isNotNull);
      expect(generatedId, isNotEmpty);
      expect(generatedId, isA<String>());
    });

    test('generated IDs are unique', () {
      // Arrange
      final Set<String> generatedIds = {};

      // Act & Assert
      for (int i = 0; i < 1000; i++) {
        final generatedId = sut.generateId();

        // Check uniqueness
        expect(generatedIds.contains(generatedId), isFalse);

        generatedIds.add(generatedId);
      }
    });

    test('useEmulator sets Firestore emulator host and port', () {
      // Arrange
      const host = 'localhost';
      const port = 8080;

      // Act
      sut.useEmulator(host, port);

      // Assert
      verify(mockFirestore.useFirestoreEmulator(host, port)).called(1);
    });
  });
}
