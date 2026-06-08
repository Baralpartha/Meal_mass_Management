import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../auth/data/models/member_model.dart';

abstract class MembersRemoteDataSource {
  Future<List<MemberModel>> getAllMembers();
  Future<List<MemberModel>> getMembersByStatus(String status);
  Future<String> approveMember(
      {required String adminId, required String memberId});
  Future<String> rejectMember(
      {required String adminId, required String memberId});
  Future<MemberModel> getMemberById(String memberId);
  Future<void> updateMemberOpeningBalance(
      {required String memberId, required double balance});
}

@LazySingleton(as: MembersRemoteDataSource)
class MembersRemoteDataSourceImpl implements MembersRemoteDataSource {
  final SupabaseService _supabase;

  MembersRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<MemberModel>> getAllMembers() async {
    try {
      final response = await _supabase
          .from(AppConstants.membersTable)
          .select()
          .eq('role', 'member')
          .order('created_at', ascending: false);
      return (response as List)
          .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MemberModel>> getMembersByStatus(String status) async {
    try {
      final response = await _supabase
          .from(AppConstants.membersTable)
          .select()
          .eq('role', 'member')
          .eq('status', status)
          .order('created_at', ascending: false);
      return (response as List)
          .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> approveMember(
      {required String adminId, required String memberId}) async {
    try {
      final result = await _supabase.rpc(
        AppConstants.adminApproveFunction,
        params: {'p_admin_id': adminId, 'p_member_id': memberId},
      );
      return result as String;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> rejectMember(
      {required String adminId, required String memberId}) async {
    try {
      final result = await _supabase.rpc(
        AppConstants.adminRejectFunction,
        params: {'p_admin_id': adminId, 'p_member_id': memberId},
      );
      return result as String;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MemberModel> getMemberById(String memberId) async {
    try {
      final response = await _supabase
          .from(AppConstants.membersTable)
          .select()
          .eq('id', memberId)
          .single();
      return MemberModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateMemberOpeningBalance(
      {required String memberId, required double balance}) async {
    try {
      await _supabase
          .from(AppConstants.membersTable)
          .update({'opening_balance': balance}).eq('id', memberId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}