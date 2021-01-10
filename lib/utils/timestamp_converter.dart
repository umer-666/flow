// ignore: missing_return
String timeStampConverter(DateTime timeStampInMilliseconds) {
  DateTime today = new DateTime.now();
  Duration oneDay = Duration(days: 1);
  Duration twoDay = Duration(days: 2);
  Duration oneWeek = Duration(days: 7);
  String month;
  switch (timeStampInMilliseconds.month) {
    case 1:
      month = "january";
      break;
    case 2:
      month = "february";
      break;
    case 3:
      month = "march";
      break;
    case 4:
      month = "april";
      break;
    case 5:
      month = "may";
      break;
    case 6:
      month = "june";
      break;
    case 7:
      month = "july";
      break;
    case 8:
      month = "august";
      break;
    case 9:
      month = "september";
      break;
    case 10:
      month = "october";
      break;
    case 11:
      month = "november";
      break;
    case 12:
      month = "december";
      break;
  }

  Duration difference = today.difference(timeStampInMilliseconds);

  if (difference.compareTo(oneDay) < 1) {
    return "today";
  } else if (difference.compareTo(twoDay) < 1) {
    return "yesterday";
  } else if (difference.compareTo(oneWeek) < 1) {
    switch (timeStampInMilliseconds.weekday) {
      case 1:
        return "monday";
      case 2:
        return "tuesday";
      case 3:
        return "wednesday";
      case 4:
        return "thursday";
      case 5:
        return "friday";
      case 6:
        return "saturday";
      case 7:
        return "sunday";
    }
  } else if (timeStampInMilliseconds.year == today.year) {
    return '${timeStampInMilliseconds.day} $month';
  } else {
    return '${timeStampInMilliseconds.day} $month ${timeStampInMilliseconds.year}';
  }
}
