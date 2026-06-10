import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../models/deposit_entry_model.dart';

abstract class DepositsRemoteDataSource {
  Future<List<DepositEntryModel>> getDepositsByCycle(String cycleId);
  Future<List<DepositEntryModel>> getDepositsByMember(String memberId);
  Future<String> addDeposit({
    required String adminId,
    required String cycleId,
    required String memberId,
    required double amount,
    required String depositDate,
    String? note,
  });
  Future<void> deleteDeposit(String depositId);
}

@LazySingleton(as: DepositsRemoteDataSource)
class DepositsRemoteDataSourceImpl implements DepositsRemoteDataSource {
  final SupabaseService _supabase;
  DepositsRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<DepositEntryModel>> getDepositsByCycle(String cycleId) async {
    try {
      final response = await _supabase
          .from(AppConstants.depositEntriesTable)
          .select()
          .eq('cycle_id', cycleId)
          .order('deposit_date', ascending: false);
      return (response as List)
          .map((e) => DepositEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<DepositEntryModel>> getDepositsByMember(String memberId) async {
    try {
      final response = await _supabase.rpc(
        AppConstants.getMemberDepositsFunction,
        params: {'p_member_id': memberId},
      );
      return (response as List)
          .map((e) => DepositEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> addDeposit({
    required String adminId,
    required String cycleId,
    required String memberId,
    required double amount,
    required String depositDate,
    String? note,
  }) async {
    try {
      final result = await _supabase.rpc(
        AppConstants.adminAddDepositFunction,
        params: {
          'p_admin_id': adminId,
          'p_cycle_id': cycleId,
          'p_member_id': memberId,
          'p_amount': amount,
          'p_deposit_date': depositDate,
          if (note != null) 'p_note': note,
        },
      );
      return result.toString();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteDeposit(String depositId) async {
    try {
      await _supabase
          .from(AppConstants.depositEntriesTable)
          .delete()
          .eq('id', depositId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
