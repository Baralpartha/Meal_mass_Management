import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../models/meal_entry_model.dart';

abstract class MealsRemoteDataSource {
  Future<List<MealEntryModel>> getMealsByCycle(String cycleId);
  Future<List<MealEntryModel>> getMealsByMember(String memberId);
  Future<List<MealEntryModel>> getMealsByCycleAndMember(
      {required String cycleId, required String memberId});
  Future<String> addMeal({
    required String adminId,
    required String cycleId,
    required String memberId,
    required String mealType,
    required int quantity,
    required String mealDate,
    String? note,
  });
  Future<void> deleteMeal(String mealId);
}

@LazySingleton(as: MealsRemoteDataSource)
class MealsRemoteDataSourceImpl implements MealsRemoteDataSource {
  final SupabaseService _supabase;

  MealsRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<MealEntryModel>> getMealsByCycle(String cycleId) async {
    try {
      final response = await _supabase
          .from(AppConstants.mealEntriesTable)
          .select()
          .eq('cycle_id', cycleId)
          .order('meal_date', ascending: false);
      return (response as List)
          .map((e) => MealEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MealEntryModel>> getMealsByMember(String memberId) async {
    try {
      final response = await _supabase.rpc(
        AppConstants.getMemberMealsFunction,
        params: {'p_member_id': memberId},
      );
      return (response as List)
          .map((e) => MealEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MealEntryModel>> getMealsByCycleAndMember(
      {required String cycleId, required String memberId}) async {
    try {
      final response = await _supabase
          .from(AppConstants.mealEntriesTable)
          .select()
          .eq('cycle_id', cycleId)
          .eq('member_id', memberId)
          .order('meal_date', ascending: false);
      return (response as List)
          .map((e) => MealEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> addMeal({
    required String adminId,
    required String cycleId,
    required String memberId,
    required String mealType,
    required int quantity,
    required String mealDate,
    String? note,
  }) async {
    try {
      final result = await _supabase.rpc(
        AppConstants.adminAddMealFunction,
        params: {
          'p_admin_id': adminId,
          'p_cycle_id': cycleId,
          'p_member_id': memberId,
          'p_meal_type': mealType,
          'p_quantity': quantity,
          'p_meal_date': mealDate,
          if (note != null) 'p_note': note,
        },
      );
      return result.toString();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteMeal(String mealId) async {
    try {
      await _supabase
          .from(AppConstants.mealEntriesTable)
          .delete()
          .eq('id', mealId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}