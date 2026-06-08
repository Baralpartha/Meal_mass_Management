import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../models/bazar_entry_model.dart';

abstract class BazarRemoteDataSource {
  Future<List<BazarEntryModel>> getBazarByCycle(String cycleId);
  Future<List<BazarEntryModel>> getBazarByMember(String memberId);
  Future<String> addBazar({
    required String adminId,
    required String cycleId,
    required String memberId,
    required String description,
    required double amount,
    String? quantity,
    required String bazarDate,
  });
  Future<void> deleteBazar(String bazarId);
}

@LazySingleton(as: BazarRemoteDataSource)
class BazarRemoteDataSourceImpl implements BazarRemoteDataSource {
  final SupabaseService _supabase;
  BazarRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<BazarEntryModel>> getBazarByCycle(String cycleId) async {
    try {
      final response = await _supabase
          .from(AppConstants.bazarEntriesTable)
          .select()
          .eq('cycle_id', cycleId)
          .order('bazar_date', ascending: false);
      return (response as List)
          .map((e) => BazarEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BazarEntryModel>> getBazarByMember(String memberId) async {
    try {
      final response = await _supabase.rpc(
        AppConstants.getMemberBazarsFunction,
        params: {'p_member_id': memberId},
      );
      return (response as List)
          .map((e) => BazarEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> addBazar({
    required String adminId,
    required String cycleId,
    required String memberId,
    required String description,
    required double amount,
    String? quantity,
    required String bazarDate,
  }) async {
    try {
      final result = await _supabase.rpc(
        AppConstants.adminAddBazarFunction,
        params: {
          'p_admin_id': adminId,
          'p_cycle_id': cycleId,
          'p_member_id': memberId,
          'p_description': description,
          'p_amount': amount,
          if (quantity != null) 'p_quantity': quantity,
          'p_bazar_date': bazarDate,
        },
      );
      return result.toString();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteBazar(String bazarId) async {
    try {
      await _supabase
          .from(AppConstants.bazarEntriesTable)
          .delete()
          .eq('id', bazarId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}