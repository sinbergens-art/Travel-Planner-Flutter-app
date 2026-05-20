import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime date) =>
      DateFormat('MMM dd, yyyy').format(date);

  static String formatDateTime(DateTime dateTime) =>
      DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);

  static String formatShort(DateTime date) =>
      DateFormat('dd MMM').format(date);

  static String formatRange(DateTime start, DateTime end) =>
      '${formatShort(start)} – ${formatShort(end)}, ${end.year}';

  static int daysBetween(DateTime from, DateTime to) =>
      to.difference(from).inDays.abs();
}
