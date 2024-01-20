import 'dart:io';

import 'package:core/services/storage/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'storage_service_test.mocks.dart';

// Mock FirebaseStorage class using Mockito
@GenerateMocks([FirebaseStorage, Reference, UploadTask, TaskSnapshot])
void main() {
  group('StorageService', () {
    late StorageService sut;
    late MockFirebaseStorage mockFirebaseStorage;
    late MockReference mockImageRef;
    late MockReference mockStorageRef;
    late MockUploadTask mockUploadTask;
    late MockTaskSnapshot mockTaskSnapshot;
    late File mockImage;

    setUp(() {
      mockFirebaseStorage = MockFirebaseStorage();
      sut = StorageService(mockFirebaseStorage);
      mockStorageRef = MockReference();
      mockImageRef = MockReference();
      mockUploadTask = MockUploadTask();
      mockTaskSnapshot = MockTaskSnapshot();
      mockImage = File('path/to/mock/image.jpg');
    });

    test('uploadImage returns downloadURL', () async {
      // Arrange
      const fullPath = 'example.jpg';
      const mockDownloadURL = 'https://example.com/downloadURL';
      final mockMetadata = {'key': 'value'};

      when(mockFirebaseStorage.ref()).thenReturn(mockStorageRef);
      when(mockStorageRef.child(any)).thenReturn(mockImageRef);
      when(mockImageRef.putFile(mockImage, any))
          .thenAnswer((_) => mockUploadTask);

      when(mockUploadTask.then(
        any,
        onError: anyNamed('onError'),
      )).thenAnswer((invocation) async {
        final onValue = invocation.positionalArguments[0];
        return onValue(mockTaskSnapshot);
      });

      when(mockImageRef.getDownloadURL())
          .thenAnswer((_) async => mockDownloadURL);

      // Act
      final result = await sut.uploadImage(
        fullPath: fullPath,
        image: mockImage,
        metadata: mockMetadata,
      );

      // Assert
      expect(result, mockDownloadURL);
    });

    test('useEmulator sets Storage emulator host and port', () {
      // Arrange
      const host = 'localhost';
      const port = 9199;

      // Act
      sut.useEmulator(host, port);

      // Assert
      verify(mockFirebaseStorage.useStorageEmulator(host, port)).called(1);
    });
  });
}
