import '../../core/constants/app_constants.dart';
import '../../core/constants/app_string.dart';

class FormValidators {
  FormValidators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }

  static String? mobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.fieldRequired;
    final cleaned = value.trim().replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length != AppConstants.mobileNumberLength ||
        !RegExp(r'^0[0-9]{10}$').hasMatch(cleaned)) {
      return AppStrings.invalidMobile;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    if (value.length < AppConstants.minPasswordLength) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static String? positiveAmount(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.fieldRequired;
    final amount = double.tryParse(value.trim());
    if (amount == null || amount <= 0) return AppStrings.invalidAmount;
    return null;
  }

  static String? nonNegativeAmount(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.fieldRequired;
    final amount = double.tryParse(value.trim());
    if (amount == null || amount < 0) return AppStrings.invalidAmount;
    return null;
  }

  static String? positiveInteger(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.fieldRequired;
    final qty = int.tryParse(value.trim());
    if (qty == null || qty <= 0) return AppStrings.invalidQuantity;
    return null;
  }
}