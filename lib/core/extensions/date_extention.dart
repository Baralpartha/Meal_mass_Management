import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String toDisplayDate() => DateFormat('dd MMM yyyy').format(this);
  String toApiDate() => DateFormat('yyyy-MM-dd').format(this);
  String toDisplayDateTime() => DateFormat('dd MMM yyyy, hh:mm a').format(this);
  String toTimeAgo() {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inDays > 7) return toDisplayDate();
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

extension StringDateExtension on String {
  DateTime toDateTime() => DateTime.parse(this);
  String toDisplayDate() => DateTime.parse(this).toDisplayDate();
}