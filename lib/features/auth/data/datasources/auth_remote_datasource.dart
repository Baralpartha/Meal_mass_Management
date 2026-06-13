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
      // 1. ইনপুট ডাটা প্রিন্ট করা হচ্ছে
      print('=== [DEBUG] LOGIN START ===');
      print('Input Mobile Number: "$mobileNumber" (Length: ${mobileNumber.length})');
      print('Input Password: "$password"');
      print('Target Table: ${AppConstants.membersTable}');

      final response = await _supabase
          .from(AppConstants.membersTable)
          .select()
          .eq('mobile_number', mobileNumber)
          .eq('password', password)
          .maybeSingle();

      // 2. সুপাবেস থেকে আসা রিলিজ বা রেসপন্স প্রিন্ট
      print('Supabase DB Raw Response: $response');

      if (response == null) {
        print('❌ Login Failed: No user found with this mobile and password combination.');
        throw const AuthException(message: 'Invalid mobile number or password');
      }

      final member = MemberModel.fromJson(response as Map<String, dynamic>);
      print('User Found Successfully! ID: ${member.id}, Role: ${member.role}');
      print('Account Status: ${member.status}, Is Active: ${member.isActive}');

      // 3. স্ট্যাটাস কন্ডিশনগুলো চেক করার প্রিন্ট
      if (member.status == 'pending') {
        print('❌ Access Denied: Account status is pending.');
        throw const AuthException(message: 'Your account is pending approval');
      }
      if (member.status == 'rejected') {
        print('❌ Access Denied: Account status is rejected.');
        throw const AuthException(message: 'Your account has been rejected');
      }
      if (member.status == 'inactive' || member.isActive == false) {
        print('❌ Access Denied: Account is inactive.');
        throw const AuthException(message: 'Your account is inactive');
      }

      print('✅ Login Process Success! Returning member model.');
      print('=== [DEBUG] LOGIN END ===');
      return member;
    } on AuthException catch (e) {
      print('⚠️ AuthException Caught in Login: ${e.message}');
      rethrow;
    } catch (e) {
      print('💥 ServerException Caught in Login: $e');
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
      print('=== [DEBUG] REGISTER START ===');
      print('Registering Full Name: $fullName');
      print('Registering Mobile Number: "$mobileNumber"');

      // Check if mobile already exists
      final existing = await _supabase
          .from(AppConstants.membersTable)
          .select('id')
          .eq('mobile_number', mobileNumber)
          .maybeSingle();

      print('Existing User Check Response: $existing');

      if (existing != null) {
        print('❌ Registration Failed: Mobile number already exists.');
        throw const AuthException(
            message: 'Mobile number already registered');
      }

      print('Proceeding to insert new member...');
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

      print('Supabase Register Insert Response: $response');

      final member = MemberModel.fromJson(response as Map<String, dynamic>);
      print('✅ Registration Process Success! New Member ID: ${member.id}');
      print('=== [DEBUG] REGISTER END ===');
      return member;
    } on AuthException catch (e) {
      print('⚠️ AuthException Caught in Register: ${e.message}');
      rethrow;
    } catch (e) {
      print('💥 ServerException Caught in Register: $e');
      throw ServerException(message: e.toString());
    }
  }
}