import 'package:intl/intl.dart';

extension NumberExtension on num {
  String toCurrency() => NumberFormat('#,##0.00').format(this);
  String toCurrencyBDT() => '৳${NumberFormat('#,##0.00').format(this)}';
  String toDecimal([int places = 2]) => toStringAsFixed(places);
  bool get isPositive => this > 0;
  bool get isNegative => this < 0;
  bool get isZero => this == 0;
}

extension NullableNumberExtension on num? {
  String toCurrencyBDT() => '৳${NumberFormat('#,##0.00').format(this ?? 0)}';
  num get orZero => this ?? 0;
}