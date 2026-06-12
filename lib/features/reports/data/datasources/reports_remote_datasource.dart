import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../models/cycle_member_summary_model.dart';
import '../../../../features/dashboard/data/models/admin_dashboard_model.dart';

abstract class ReportsRemoteDataSource {
  Future<List<CycleMemberSummaryModel>> getCycleSummaries(String cycleId);
  Future<List<MemberBalanceModel>> getMemberBalanceView(String cycleId);
  Future<List<MemberBalanceModel>> getAllMemberBalances();
}

@LazySingleton(as: ReportsRemoteDataSource)
class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final SupabaseService _supabase;
  ReportsRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<CycleMemberSummaryModel>> getCycleSummaries(
      String cycleId) async {
    try {
      final response = await _supabase
          .from(AppConstants.cycleMemberSummariesTable)
          .select()
          .eq('cycle_id', cycleId);
      return (response as List)
          .map((e) =>
              CycleMemberSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MemberBalanceModel>> getMemberBalanceView(
      String cycleId) async {
    try {
      final response = await _supabase
          .from(AppConstants.memberCycleBalanceView)
          .select()
          .eq('cycle_id', cycleId);
      return (response as List)
          .map((e) => MemberBalanceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MemberBalanceModel>> getAllMemberBalances() async {
    try {
      final response =
          await _supabase.from(AppConstants.memberCycleBalanceView).select();
      return (response as List)
          .map((e) => MemberBalanceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
