import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../models/khala_bill_model.dart';

abstract class KhalaBillRemoteDataSource {
  Future<List<KhalaBillModel>> getKhalaBillsByMember(String memberId);
  Future<List<KhalaBillModel>> getKhalaBillsByCycle(String cycleId);
  Future<String> addKhalaBill({
    required String adminId, required String cycleId, required String memberId,
    required double amount, String? note, required String billDate,
  });
  Future<void> deleteKhalaBill(String billId);
}

@LazySingleton(as: KhalaBillRemoteDataSource)
class KhalaBillRemoteDataSourceImpl implements KhalaBillRemoteDataSource {
  final SupabaseService _supabase;
  KhalaBillRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<KhalaBillModel>> getKhalaBillsByMember(String memberId) async {
    try {
      final r = await _supabase.rpc(AppConstants.getMemberKhalaBillsFunction,
          params: {'p_member_id': memberId});
      return (r as List).map((e) => KhalaBillModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) { throw ServerException(message: e.toString()); }
  }

  @override
  Future<List<KhalaBillModel>> getKhalaBillsByCycle(String cycleId) async {
    try {
      final r = await _supabase.from(AppConstants.khalaBillsTable)
          .select().eq('cycle_id', cycleId).order('bill_date', ascending: false);
      return (r as List).map((e) => KhalaBillModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) { throw ServerException(message: e.toString()); }
  }

  @override
  Future<String> addKhalaBill({
    required String adminId, required String cycleId, required String memberId,
    required double amount, String? note, required String billDate,
  }) async {
    try {
      final r = await _supabase.rpc(AppConstants.adminAddKhalaBillFunction, params: {
        'p_admin_id': adminId, 'p_cycle_id': cycleId, 'p_member_id': memberId,
        'p_amount': amount, 'p_bill_date': billDate,
        if (note != null) 'p_note': note,
      });
      return r.toString();
    } catch (e) { throw ServerException(message: e.toString()); }
  }

  @override
  Future<void> deleteKhalaBill(String billId) async {
    try {
      await _supabase.from(AppConstants.khalaBillsTable).delete().eq('id', billId);
    } catch (e) { throw ServerException(message: e.toString()); }
  }
}
