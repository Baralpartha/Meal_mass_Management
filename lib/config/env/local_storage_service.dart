import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../features/auth/data/models/member_model.dart';

abstract class LocalStorageService {
  Future<void> saveMember(MemberModel member);
  MemberModel? getMember();
  Future<void> clearMember();
  Future<void> setLoggedIn(bool value);
  bool isLoggedIn();
  Future<void> clear();
}

@LazySingleton(as: LocalStorageService)
class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageServiceImpl(this._prefs);

  @override
  Future<void> saveMember(MemberModel member) async {
    final json = jsonEncode(member.toJson());
    await _prefs.setString(AppConstants.currentMemberKey, json);
  }

  @override
  MemberModel? getMember() {
    final json = _prefs.getString(AppConstants.currentMemberKey);
    if (json == null) return null;
    try {
      return MemberModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearMember() async {
    await _prefs.remove(AppConstants.currentMemberKey);
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(AppConstants.isLoggedInKey, value);
  }

  @override
  bool isLoggedIn() => _prefs.getBool(AppConstants.isLoggedInKey) ?? false;

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}