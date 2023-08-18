import 'package:hive_flutter/hive_flutter.dart';

/// {@template local_storage_repository}
/// Repository which manages local data storage.
/// {@endtemplate}
class LocalStorageRepository {
  /// {@macro local_storage_repository}
  LocalStorageRepository();

  static init() async {
    await Hive.initFlutter();
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
    return _userPreferencesBox.get('$userId-isAppLockEnabled', defaultValue: false);
  }
}
