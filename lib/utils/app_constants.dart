import 'package:intl/intl.dart';

/// ------------------------------------------------------------
/// 1) Date only   → "dd MMM yyyy"   (e.g. 25 Feb 2025)
/// ------------------------------------------------------------
String formatDate(int epochSeconds, {bool toLocal = true}) {
  final dt = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000, isUtc: true);
  final safe   = toLocal ? dt.toLocal() : dt;             // optional local conversion
  return DateFormat('dd MMM yyyy').format(safe);
}

/// ------------------------------------------------------------
/// 2) Date + time → "dd MMM yyyy, hh:mm a" (e.g. 25 Feb 2025, 12:17 AM)
/// ------------------------------------------------------------
String formatDateTime(int epochSeconds, {bool toLocal = true}) {
  final dt = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000, isUtc: true);
  final safe   = toLocal ? dt.toLocal() : dt;
  return DateFormat('dd MMM yyyy, hh:mm a').format(safe);
}
