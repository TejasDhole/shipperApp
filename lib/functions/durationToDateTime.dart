import 'package:intl/intl.dart';

class DurationToDateTime {
  getDuration(String duration, String currentDate) {
    try{
    DateTime todaysDate = DateTime.parse(currentDate);

    // Initialize days and hours to 0
    int days = 0;
    int hours = 0;
    int minutes = 0;

    // Check if 'day' is in the string and parse accordingly
    if (duration.contains('day')) {
      days = int.parse(duration.split('day')[0]);
      duration = duration.split('day')[1].trim(); // Remaining part
    }

    // Check if 'hours' is in the string and parse accordingly
    if (duration.contains('hours')) {
      hours = int.parse(duration.split('hours')[0]);
      duration = duration.split('hours')[1].trim(); // Remaining part
    }

    // Check if 'mins' is in the string and parse accordingly
    if (duration.contains('mins')) {
      minutes = int.parse(duration.split('mins')[0].trim());
    }

    DateTime newDate = todaysDate.add(Duration(days: days, hours: hours, minutes: minutes));

    String formattedDate = DateFormat('hh:mm a, dd-MM-yyyy').format(newDate);

    return formattedDate;
    }catch(e){
    return "Time estimation is not possible";
  }
  }
}
