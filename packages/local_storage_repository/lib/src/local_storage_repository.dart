import 'dart:typed_data';

import 'package:cryptography_repository/cryptography_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// {@template local_storage_repository}
/// Repository which manages local data storage.
/// {@endtemplate}
class LocalStorageRepository {
  /// {@macro local_storage_repository}
  LocalStorageRepository();

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(KeySetAdapter());
  }

  static final userPrefrencesBoxName = 'userPreferences';
  late Box _userPreferencesBox;

  static Future<LocalStorageRepository> create() async {
    var localStorageRepository = LocalStorageRepository();
    await localStorageRepository.initializeUserPreferencesBox();
    return localStorageRepository;
  }

  Future<void> initializeUserPreferencesBox() async {
    if (Hive.isBoxOpen(userPrefrencesBoxName)) {
      _userPreferencesBox = Hive.box(userPrefrencesBoxName);
      return;
    }
    _userPreferencesBox = await Hive.openBox(userPrefrencesBoxName);
  }

  void setAppLockEnabledStatus(String userId, bool status) {
    _userPreferencesBox.put('$userId-isAppLockEnabled', status);
  }

  bool isAppLockEnabled(String userId) {
    return _userPreferencesBox.get('$userId-isAppLockEnabled',
        defaultValue: false);
  }

  void saveUserKeySet(String userId, KeySet keyset) {
    _userPreferencesBox.put('$userId-keySet', keyset);
  }

  KeySet getUserKeySet(String userId) {
    return _userPreferencesBox.get('$userId-keySet');
  }

  void saveCombinedKey(String roomId, Uint8List combinedKey) {
    _userPreferencesBox.put('$roomId-combinedKey', combinedKey);
  }
  Uint8List? getCombinedKey(String roomId) {
    return _userPreferencesBox.get('$roomId-combinedKey');
  }
  bool isCombinedKeySaved(String roomId) {
    return _userPreferencesBox.containsKey('$roomId-combinedKey');
  }
}