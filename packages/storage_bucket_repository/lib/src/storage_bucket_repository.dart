import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// {@template save_user_profile_picture}
/// Thrown when attempting to save user profile picture.
/// {@endtemplate}
class SaveUserProfilePictureFailure implements Exception {
  /// {@macro get_user_profile_failure}
  const SaveUserProfilePictureFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;
}

/// {@template database_repository}
/// Repository which manages cloud data storage.
/// {@endtemplate}
class StorageBucketRepository {
  /// {@macro database_repository}
  StorageBucketRepository({
    FirebaseStorage? firebaseStorage,
  }) : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final FirebaseStorage _firebaseStorage;

  /// Returns uploaded image url
  /// Uploads image to firebase storage profile_pictures collection
  Future<String> saveProfilePic(File file) async {
    try {
      //Create a reference to the location you want to upload to in firebase
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final fileName = '$time.${file.path.split('.').last}';

      final reference =
          await _firebaseStorage.ref().child("profile_pictures/$fileName");

      //Upload the file to firebase
      await reference.putFile(file);
      return await reference.getDownloadURL();
    } catch (_) {
      throw SaveUserProfilePictureFailure();
    }
  }
}
