import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:table_calendar/table_calendar.dart';

class BiddingDateTime extends StatefulWidget {
  final Function(bool) refreshParent;
  final double width;

  const BiddingDateTime({super.key, required this.refreshParent, required this.width});

  @override
  State<BiddingDateTime> createState() => _BiddingDateTimeState();
}

class _BiddingDateTimeState extends State<BiddingDateTime> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final TextEditingController _biddingDateTextEditingController = TextEditingController();
  final TextEditingController _biddingTimeTextEditingController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String? Date_Time;
  String? Time_Day;
  TimeOfDay? picked = TimeOfDay.now();

  Future timePicker() async {
    return await showTimePicker(
        context: context,
        initialTime: (picked != null) ? picked! : TimeOfDay.now(),
        orientation: Orientation.portrait,
        initialEntryMode: TimePickerEntryMode.dialOnly,
        cancelText: 'CANCEL',
        confirmText: 'OK',
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                textButtonTheme: TextButtonThemeData(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => truckGreen),
                        foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        textStyle: MaterialStatePropertyAll<TextStyle>(
                            TextStyle(
                                color: white,
                                fontFamily: 'Montserrat',
                                fontSize: size_5)),
                        padding: MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5)),
                        side: MaterialStatePropertyAll<BorderSide>(
                            BorderSide(color: truckGreen, width: 2)))),
                focusColor: truckGreen,
                timePickerTheme: TimePickerThemeData(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  elevation: 5,

                  // cancelButtonStyle: cancelButtonStyle,
                  // confirmButtonStyle: confirmButtonStyle,

                  dialBackgroundColor: Colors.white,
                  dialHandColor: truckGreen,
                  dialTextColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.selected)
                          ? Colors.white
                          : truckGreen),
                  dialTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat Bold',
                      fontSize: size_7),

                  dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.selected)
                          ? truckGreen
                          : Colors.white),

                  dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.selected)
                          ? Colors.white
                          : truckGreen),

                  dayPeriodTextStyle: TextStyle(
                      color: truckGreen,
                      fontFamily: 'Montserrat',
                      fontSize: size_5),
                  dayPeriodShape: RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: truckGreen),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  dayPeriodBorderSide: BorderSide(width: 2, color: truckGreen),

                  hourMinuteShape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: truckGreen,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.selected)
                          ? truckGreen
                          : Colors.white),
                  hourMinuteTextColor: MaterialStateColor.resolveWith(
                      (states) => states.contains(MaterialState.selected)
                          ? Colors.white
                          : truckGreen),
                  hourMinuteTextStyle:
                      TextStyle(fontFamily: 'Montserrat', fontSize: size_12),
                  helpTextStyle: TextStyle(fontFamily: 'Montserrat'),
                ),
              ),
              child: child!);
        }).then((value) {
      picked = value;
      String dayPeriod = (picked!.period == DayPeriod.am) ? 'AM' : 'PM';
      String dayHour = (picked!.hourOfPeriod.toString().length == 1)
          ? '0${picked!.hourOfPeriod.toString()}'
          : picked!.hourOfPeriod.toString();
      String dayMinute = (picked!.minute.toString().length == 1)
          ? '0${picked!.minute.toString()}'
          : picked!.minute.toString();
      Time_Day = '$dayHour : $dayMinute $dayPeriod';
      _biddingTimeTextEditingController.text = '$Time_Day';
      widget.refreshParent(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    if (providerData.biddingEndDate != null &&
        providerData.biddingEndTime != null) {
      //for convert string into DateTime
      _selectedDay = DateFormat.yMMMMd('en_US')
          .parse(providerData.biddingEndDate.toString());
      Date_Time = DateFormat.yMMMMd('en_US').format(_selectedDay!).toString();

      //for time into TimeOfDay
      String time24HourFormat = providerData.biddingEndTime.toString();
      List<String> timeParts = time24HourFormat.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      picked = TimeOfDay(hour: hour, minute: minute);

      //for textEditingController
      String dayPeriod = (picked!.period == DayPeriod.am) ? 'AM' : 'PM';
      String dayHour = (picked!.hourOfPeriod.toString().length == 1)
          ? '0${picked!.hourOfPeriod.toString()}'
          : picked!.hourOfPeriod.toString();
      String dayMinute = (picked!.minute.toString().length == 1)
          ? '0${picked!.minute.toString()}'
          : picked!.minute.toString();
      Time_Day = '$dayHour : $dayMinute $dayPeriod';

      _biddingDateTextEditingController.text = '$Date_Time';
      _biddingTimeTextEditingController.text = '$Time_Day';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * widget.width,
          child: TextField(
            controller: _biddingDateTextEditingController,
            style: TextStyle(
                color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
            textAlign: TextAlign.center,
            showCursor: false,
            mouseCursor: SystemMouseCursors.click,
            onTap: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.588,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.all(10),
                              child: TableCalendar(
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  if (!isSameDay(_selectedDay, selectedDay)) {
                                    setState(() {
                                      _selectedDay = selectedDay;
                                      _focusedDay = focusedDay;
                                      Date_Time = DateFormat.yMMMMd('en_US')
                                          .format(_selectedDay!)
                                          .toString();
                                      if (Date_Time != null) {
                                        _biddingDateTextEditingController.text = '$Date_Time';
                                        print(Date_Time);
                                        print(Time_Day);
                                        if (Date_Time != null &&
                                            Time_Day != null &&
                                            Date_Time!.isNotEmpty &&
                                            Time_Day!.isNotEmpty) {
                                          providerData.updateBiddingEndDateTime(
                                              Date_Time,
                                              '${picked!.hour}:${picked!.minute}');
                                        }
                                        widget.refreshParent(true);
                                        Navigator.of(context).pop();
                                      }
                                    });
                                  }
                                },
                                eventLoader: (day) {
                                  return (isSameDay(DateTime.now(), day))
                                      ? [DateTime.now()]
                                      : [];
                                },
                                calendarFormat: _calendarFormat,
                                focusedDay: _focusedDay,
                                firstDay: DateTime.now(),
                                lastDay: DateTime.utc(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day + 5),
                                headerStyle: HeaderStyle(
                                  headerPadding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  leftChevronIcon: Image.asset(
                                      'assets/images/calendar_previous.png'),
                                  rightChevronIcon: Image.asset(
                                      'assets/images/calendar_next.png'),
                                  formatButtonVisible: false,
                                  titleTextStyle: TextStyle(
                                      color: black,
                                      fontFamily: 'Montserrat',
                                      fontSize: 20),
                                  titleCentered: true,
                                ),
                                calendarStyle: CalendarStyle(
                                    markersAutoAligned: false,
                                    markersAlignment: Alignment.topRight,
                                    markerMargin: EdgeInsets.all(10),
                                    markersMaxCount: 1,
                                    canMarkersOverflow: false,
                                    outsideDecoration: BoxDecoration(
                                      color: white,
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                    ),
                                    weekendDecoration: BoxDecoration(
                                      color: white,
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                    ),
                                    disabledDecoration: BoxDecoration(
                                      color: white,
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                    ),
                                    defaultDecoration: BoxDecoration(
                                      color: white,
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: truckGreen,
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                    ),
                                    selectedTextStyle: TextStyle(
                                        fontFamily: 'Montserrat', color: white),
                                    defaultTextStyle:
                                        TextStyle(fontFamily: 'Montserrat'),
                                    weekendTextStyle:
                                        TextStyle(fontFamily: 'Montserrat'),
                                    withinRangeTextStyle: TextStyle(color: black),
                                    disabledTextStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Montserrat'),
                                    outsideTextStyle: TextStyle(
                                        color: unselectedGrey,
                                        fontFamily: 'Montserrat'),
                                    isTodayHighlighted: false,
                                    markerSize: 4,
                                    markerDecoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (isSameDay(
                                                _selectedDay, DateTime.now()))
                                            ? white
                                            : truckGreen)),
                              )),
                        );
                      },
                    );
                  },
                );
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: borderLightColor, width: 1.5)),
                hintText: 'Choose Date',
                hintStyle: TextStyle(
                    color: borderLightColor,
                    fontFamily: 'Montserrat',
                    fontSize: size_8),
                label: Text('Bidding end Date (optional)',
                    style: TextStyle(
                        color: kLiveasyColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_10,
                        fontWeight: FontWeight.w600),
                    selectionColor: kLiveasyColor),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: Icon(
                  Icons.calendar_month,
                  color: borderLightColor,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: truckGreen, width: 1.5))),
          ),
        ),
        SizedBox(width: 10,),
        Container(
          width: MediaQuery.of(context).size.width * widget.width,
          child: TextField(
            controller: _biddingTimeTextEditingController,
            style: TextStyle(
                color: kLiveasyColor, fontFamily: 'Montserrat', fontSize: size_8),
            textAlign: TextAlign.center,
            showCursor: false,
            mouseCursor: SystemMouseCursors.click,
            onTap: () {
              setState(() {
                timePicker().then((value) {
                      if (Date_Time != null &&
                          Time_Day != null &&
                          Date_Time!.isNotEmpty &&
                          Time_Day!.isNotEmpty) {
                        providerData.updateBiddingEndDateTime(
                            Date_Time,
                            '${picked!.hour}:${picked!.minute}');
                      }
                    });
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: borderLightColor, width: 1.5)),
                hintText: 'Choose Time',
                hintStyle: TextStyle(
                    color: borderLightColor,
                    fontFamily: 'Montserrat',
                    fontSize: size_8),
                label: Text('Bidding end Time (optional)',
                    style: TextStyle(
                        color: kLiveasyColor,
                        fontFamily: 'Montserrat',
                        fontSize: size_10,
                        fontWeight: FontWeight.w600),
                    selectionColor: kLiveasyColor),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: Icon(
                  Icons.watch_later_outlined,
                  color: borderLightColor,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: truckGreen, width: 1.5))),
          ),
        ),
      ],
    );
  }
}
