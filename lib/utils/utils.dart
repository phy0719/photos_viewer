import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class Utils {
  static bool areDatesInSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }
}

