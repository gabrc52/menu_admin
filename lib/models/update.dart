import 'date_truncation.dart';

class Update {
  /// Date this update was pushed
  final DateTime updateDate;

  /// If dailyAttempt = n it means an update has been pushed n times today
  final int dailyAttempt;

  /// The number stored in the backend for easy comparing
  int get number => numberFrom(updateDate, dailyAttempt);

  Update({required this.updateDate, required this.dailyAttempt});

  factory Update.fromNumber(int number) {
    String numberString = number.toString();
    assert(numberString.length == 10);
    int year = int.parse(numberString.substring(0, 4));
    int month = int.parse(numberString.substring(4, 6));
    int day = int.parse(numberString.substring(6, 8));
    int dailyAttempt = int.parse(numberString.substring(8));
    return Update(
      updateDate: DateTime(year, month, day),
      dailyAttempt: dailyAttempt,
    );
  }

  static int numberFrom(DateTime date, int attempt) {
    assert(attempt < 100);
    date = date.truncate();
    return int.parse(
        '${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}${attempt.toString().padLeft(2, '0')}');
  }

  Update next() {
    final today = DateTime.now().truncate();
    if (today == updateDate) {
      return Update(updateDate: today, dailyAttempt: dailyAttempt + 1);
    } else {
      return Update(updateDate: today, dailyAttempt: 1);
    }
  }
}
