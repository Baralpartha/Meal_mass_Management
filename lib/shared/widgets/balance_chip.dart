import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../core/extensions/number_extentation.dart';

class BalanceChip extends StatelessWidget {
  final double balance;
  final String? statusLabel;

  const BalanceChip({super.key, required this.balance, this.statusLabel});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    if (balance > 0) {
      color = AppTheme.advance;
      label = statusLabel ?? 'Advance';
    } else if (balance < 0) {
      color = AppTheme.due;
      label = statusLabel ?? 'Due';
    } else {
      color = AppTheme.settled;
      label = statusLabel ?? 'Settled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(balance.toCurrencyBDT(),
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
          const SizedBox(width: 4),
          Text('($label)',
              style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}
