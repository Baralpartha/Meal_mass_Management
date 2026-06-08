import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../models/cycle_model.dart';

abstract class CyclesRemoteDataSource {
  Future<List<CycleModel>> getAllCycles();
  Future<CycleModel?> getRunningCycle();
  Future<String> startNewCycle({
    required String adminId,
    required String cycleCode,
    required String startDate,
  });
  Future<String> closeCycle({
    required String adminId,
    required String cycleId,
    required String endDate,
  });
}

@LazySingleton(as: CyclesRemoteDataSource)
class CyclesRemoteDataSourceImpl implements CyclesRemoteDataSource {
  final SupabaseService _supabase;

  CyclesRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<CycleModel>> getAllCycles() async {
    try {
      final response = await _supabase
          .from(AppConstants.cyclesTable)
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((e) => CycleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CycleModel?> getRunningCycle() async {
    try {
      final response = await _supabase
          .from(AppConstants.cyclesTable)
          .select()
          .eq('status', 'running')
          .maybeSingle();
      if (response == null) return null;
      return CycleModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> startNewCycle({
    required String adminId,
    required String cycleCode,
    required String startDate,
  }) async {
    try {
      final result = await _supabase.rpc(
        AppConstants.startNewCycleFunction,
        params: {
          'p_admin_id': adminId,
          'p_cycle_code': cycleCode,
          'p_start_date': startDate,
        },
      );
      return result.toString();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> closeCycle({
    required String adminId,
    required String cycleId,
    required String endDate,
  }) async {
    try {
      final result = await _supabase.rpc(
        AppConstants.closeCycleFunction,
        params: {
          'p_admin_id': adminId,
          'p_cycle_id': cycleId,
          'p_end_date': endDate,
        },
      );
      return result.toString();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}