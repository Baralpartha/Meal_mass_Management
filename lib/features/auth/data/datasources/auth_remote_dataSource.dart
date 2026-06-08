import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../models/member_model.dart';

abstract class AuthRemoteDataSource {
  Future<MemberModel> login({
    required String mobileNumber,
    required String password,
  });

  Future<MemberModel> register({
    required String fullName,
    required String mobileNumber,
    required String password,
    String? district,
    String? thana,
    String? address,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseService _supabase;

  AuthRemoteDataSourceImpl(this._supabase);

  @override
  Future<MemberModel> login({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final response = await _supabase
          .from(AppConstants.membersTable)
          .select()
          .eq('mobile_number', mobileNumber)
          .eq('password', password)
          .maybeSingle();

      if (response == null) {
        throw const AuthException(message: 'Invalid mobile number or password');
      }

      final member = MemberModel.fromJson(response as Map<String, dynamic>);

      if (member.status == 'pending') {
        throw const AuthException(message: 'Your account is pending approval');
      }
      if (member.status == 'rejected') {
        throw const AuthException(message: 'Your account has been rejected');
      }
      if (member.status == 'inactive' || member.isActive == false) {
        throw const AuthException(message: 'Your account is inactive');
      }

      return member;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MemberModel> register({
    required String fullName,
    required String mobileNumber,
    required String password,
    String? district,
    String? thana,
    String? address,
  }) async {
    try {
      // Check if mobile already exists
      final existing = await _supabase
          .from(AppConstants.membersTable)
          .select('id')
          .eq('mobile_number', mobileNumber)
          .maybeSingle();

      if (existing != null) {
        throw const AuthException(
            message: 'Mobile number already registered');
      }

      final response = await _supabase
          .from(AppConstants.membersTable)
          .insert({
        'full_name': fullName,
        'mobile_number': mobileNumber,
        'password': password,
        if (district != null) 'district': district,
        if (thana != null) 'thana': thana,
        if (address != null) 'address': address,
        'role': 'member',
        'status': 'pending',
        'opening_balance': 0,
        'is_active': true,
      })
          .select()
          .single();

      return MemberModel.fromJson(response as Map<String, dynamic>);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}