import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../models/admin_dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<AdminDashboardModel> getAdminDashboard(String adminId);
  Future<List<MemberBalanceModel>> getMemberDashboard(String memberId);
  Future<List<MemberBalanceModel>> getAllMemberBalances(String cycleId);
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final SupabaseService _supabase;
  DashboardRemoteDataSourceImpl(this._supabase);

  @override
  Future<AdminDashboardModel> getAdminDashboard(String adminId) async {
    try {
      // 👈 ডিবাগ প্রিন্ট অ্যাড করা হলো
      print('=== [DEBUG] GET ADMIN DASHBOARD DATA SOURCE ===');
      print('Passed adminId: "$adminId" (Length: ${adminId.length})');
      print('RPC Function: ${AppConstants.getAdminDashboardFunction}');

      final response = await _supabase.rpc(
        AppConstants.getAdminDashboardFunction,
        params: {'p_admin_id': adminId},
      );

      print('RPC Raw Response: $response');

      final row = (response as List).first as Map<String, dynamic>;
      return AdminDashboardModel.fromJson(row);
    } catch (e) {
      print('💥 Error in getAdminDashboard DataSource: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MemberBalanceModel>> getMemberDashboard(String memberId) async {
    try {
      // 👈 ডিবাগ প্রিন্ট অ্যাড করা হলো
      print('=== [DEBUG] GET MEMBER DASHBOARD DATA SOURCE ===');
      print('Passed memberId: "$memberId" (Length: ${memberId.length})');
      print('RPC Function: ${AppConstants.getMemberDashboardFunction}');

      final response = await _supabase.rpc(
        AppConstants.getMemberDashboardFunction,
        params: {'p_member_id': memberId},
      );

      print('RPC Raw Response: $response');

      return (response as List)
          .map((e) => MemberBalanceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('💥 Error in getMemberDashboard DataSource: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MemberBalanceModel>> getAllMemberBalances(String cycleId) async {
    try {
      // 👈 ডিবাগ প্রিন্ট অ্যাড করা হলো
      print('=== [DEBUG] GET ALL MEMBER BALANCES DATA SOURCE ===');
      print('Passed cycleId: "$cycleId"');

      final response = await _supabase
          .from(AppConstants.memberCycleBalanceView)
          .select()
          .eq('cycle_id', cycleId);

      print('View Raw Response: $response');

      return (response as List)
          .map((e) => MemberBalanceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('💥 Error in getAllMemberBalances DataSource: $e');
      throw ServerException(message: e.toString());
    }
  }
}