import 'package:intl/intl.dart';

String formatDateBydMMMYYYY(DateTime dateTime) {
  return DateFormat('d MMMM yyyy').format(dateTime);
}
